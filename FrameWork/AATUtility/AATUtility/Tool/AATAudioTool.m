//
//  AATAudioTool.m
//  AATUtility
//
//  Created by chdo on 2018/1/9.
//  Copyright © 2018年 aat. All rights reserved.
//

#import "AATAudioTool.h"
#import "AATUtility.h"

NSNotificationName const AATAudioToolDidStopPlayNoti = @"AATAudioToolDidStopPlayNoti";

@interface AATAudioTool()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    NSTimer *_timer; //定时器
    NSTimeInterval startTime;
    NSString *filePath;
}

@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址
@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器
@property (nonatomic, strong) AVAudioPlayer *player; //播放器
@property (nonatomic, strong) AVAudioSession *session;

@end


@implementation AATAudioTool

+(instancetype)share{
    
    static dispatch_once_t onceToken;
    static AATAudioTool *single;
    
    dispatch_once(&onceToken, ^{
        single = [[AATAudioTool alloc] init];
        single.updateInterval = 0.01;
        [[NSNotificationCenter defaultCenter] addObserver:single selector:@selector(enterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    });
    return single;
}


-(AVAudioSession *)session{
    if (!_session){
        
        AVAudioSession *session =[AVAudioSession sharedInstance];
        NSError *err;
        [session setActive:YES error:&err];
        [self handleError:err];
        _session = session;
    }
    return _session;
}

-(void)enterBackGround:(NSNotification *)noti{
    [self stopRecord];
    [self stopPlay];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ====================================录音====================================

-(BOOL)isRecorderRecording{
    return self.recorder.isRecording;
}
-(AVAudioRecorder *)configRecorder:(NSError **)outError{
    
    _recorder = nil;
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   // 采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 44100],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   // 采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:32],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   // 录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],  AVEncoderAudioQualityKey,
                                   nil];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:outError];
    _recorder.delegate = self;
    return _recorder;
}

- (void)startRecord {
    
    if (_player) {
        // 停止播放/录音
        [self stopPlay];
        
    }
    // 设置session
    NSError *sessionError;
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if ([self handleError:sessionError]){
        return;
    }

    // 设置文件地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",[NSString dateTimeStamp]]];
    self.recordFileUrl = [NSURL fileURLWithPath:filePath];
    
    // 配置录音器
    NSError *error;
    [self configRecorder:&error];
    [self handleError:error];
    
    //设置参数
    if (self.recorder) {
        // 开始录音
        self.recorder.meteringEnabled = YES;
        [self.recorder prepareToRecord];
        BOOL res = [self.recorder record];
        NSLog(@"?? %d",res);
        startTime = -1;
        [self addTimer];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate aatAudioToolDidStopRecord:nil startTime:0 endTime:0 errorInfo:@"音频格式和文件存储格式不匹配,无法初始化Recorder"];
        });
    }
}


- (void)stopRecord {
    
    [self removeTimer];
    if ([self.recorder isRecording]) {
        CRMLog(@"正常结束录音");
        [self.recorder stop];
    }
}

-(void)intertrptRecord{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate aatAudioToolDidSInterrupted];
        self.delegate = nil;
        [self removeTimer];
        if ([self.recorder isRecording]) {
            CRMLog(@"中断了");
            [self.recorder stop];
        }
    });
}


/**
 *  添加定时器
 */
- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.updateInterval target:self selector:@selector(refreshRecord) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}

-(void)refreshRecord {
    
    if (startTime < 0 && !self.recorder.isRecording) { // 还未开始录音
        CRMLog(@"还未开始录音");
        return;
    } else if (startTime < 0 && self.recorder.isRecording) { // 开始录音 记录时间
        CRMLog(@"开始录音 记录时间");
        startTime = self.recorder.currentTime;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate aatAudioToolDidStartRecord:startTime];
        });
        return;
    } else if (startTime > 0 && self.recorder.isRecording) { // 录音中
        
        NSTimeInterval duration = self.recorder.currentTime - startTime;
        
        if (duration > 60.0) { // 停止录音
            [self stopRecord];
            return;
        }
        
        [self.recorder updateMeters];
        double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate aatAudioToolUpdateCurrentTime:self.recorder.currentTime
                                                fromTime:startTime
                                                   power:lowPassResults];
        });
        CRMLog([NSString stringWithFormat:@"录音中 %f --peakPower:%f",self.recorder.currentTime, lowPassResults]);
    } else {
        CRMLog(@"没有在录音，中断了");
    }
    
}

#pragma mark  ---AVAudioRecorderDelegate---
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate aatAudioToolDidStopRecord:recorder.url startTime:startTime endTime:recorder.currentTime errorInfo:nil];
    });
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate aatAudioToolDidStopRecord:recorder.url startTime:startTime endTime:recorder.currentTime errorInfo:@"被打断了"];
    });
}

-(void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder{
    
}

-(void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags{
    
}

-(void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags{
    
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate aatAudioToolDidStopRecord:recorder.url startTime:startTime endTime:recorder.currentTime errorInfo:error.description];
    });
}



#pragma mark ====================================播放====================================
-(BOOL)isPlaying{
    return [self.player isPlaying];
}

-(AVAudioPlayer *)player{
    if (!_player) {
        NSError *err;
        NSURL *fileUrl;
        if ([[NSFileManager defaultManager] fileExistsAtPath: self.audioPath]){
            fileUrl = [NSURL fileURLWithPath:self.audioPath];
        } else {
            fileUrl = [NSURL URLWithString:self.audioPath];
        }
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL: fileUrl error: &err];
        _player.delegate = self;
        [self.session setCategory: AVAudioSessionCategoryPlayback error:&err];
        [_player prepareToPlay];
        [self handleError:err];
    }
    return _player;
}

- (void)play {
    
    NSError *outError;
    [self.session setCategory:AVAudioSessionCategoryPlayback error:&outError];
    
    [self intertrptRecord];
    if ([self.player isPlaying]){
        [self stopPlay];
        self.player = nil;
    };
    
    [self.player play];
}

-(void)stopPlay{
    [[NSNotificationCenter defaultCenter] postNotificationName: AATAudioToolDidStopPlayNoti object:nil];
    [self.player stop];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [[NSNotificationCenter defaultCenter] postNotificationName: AATAudioToolDidStopPlayNoti object:nil];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    [[NSNotificationCenter defaultCenter] postNotificationName: AATAudioToolDidStopPlayNoti object:nil];
}
/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    [[NSNotificationCenter defaultCenter] postNotificationName: AATAudioToolDidStopPlayNoti object:nil];
}


#pragma mark ====================================public====================================
-(BOOL)handleError:(NSError *)err{
    if (err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate aatAudioToolDidStopRecord:nil startTime:0 endTime:0 errorInfo:[NSString stringWithFormat:@"Error creating session: %@",[err description]]];
            [self removeTimer];
        });
        return YES;
    }
    return NO;
}

+ (void)checkCameraAuthorizationGrand:(void (^)(void))permissionGranted withNoPermission:(void (^)(void))noPermission{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (videoAuthStatus) {
            case AVAuthorizationStatusNotDetermined:
            {
                //第一次提示用户授权
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!granted) {
                            noPermission();
                        }else{
//                            permissionGranted();
                        }
                    });
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized:
            {
                //通过授权
                permissionGranted();
                break;
            }
            case AVAuthorizationStatusRestricted:
                //不能授权
                CRMLog(@"不能完成授权，可能开启了访问限制");
                noPermission();
            case AVAuthorizationStatusDenied:{
                [AATHUD alert:@"麦克风授权" message:@"跳转相机授权设置" confirm:^{
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([ [UIApplication sharedApplication] canOpenURL:url])
                    {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                } cancle:^{
                    
                }];
            }
                break;
            default:
                break;
        }
    });
}


@end
