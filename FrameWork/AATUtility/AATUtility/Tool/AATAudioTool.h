//
//  AATAudioTool.h
//  AATUtility
//
//  Created by chdo on 2018/1/9.
//  Copyright © 2018年 aat. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

//Privacy - Microphone Usage Description

extern  NSNotificationName const AATAudioToolDidStopPlayNoti;

@protocol AATAudioToolProtocol

// 开始录音
-(void)aatAudioToolDidStartRecord:(NSTimeInterval)currentTime;

// 录音时，更新
-(void)aatAudioToolUpdateCurrentTime:(NSTimeInterval)currentTime
                            fromTime:(NSTimeInterval)startTime
                               power:(float)power;
// 停止录音
-(void)aatAudioToolDidSInterrupted;

// 停止录音
-(void)aatAudioToolDidStopRecord:(NSURL *)dataPath
                       startTime:(NSTimeInterval)start
                         endTime:(NSTimeInterval)end
                       errorInfo:(NSString *)info;


@end

@interface AATAudioTool : NSObject
+(instancetype)share;

@property (weak) id<AATAudioToolProtocol>delegate;
@property NSTimeInterval updateInterval;

// 录音
+ (void)checkCameraAuthorizationGrand:(void (^)(void))permissionGranted withNoPermission:(void (^)(void))noPermission;
-(BOOL)isRecorderRecording;
- (void)startRecord;
- (void)stopRecord;
-(void)intertrptRecord; // 没有回调

// 播放
@property (copy) NSString *audioPath;
-(BOOL)isPlaying;
- (void)play;
-(void)stopPlay;

@end

