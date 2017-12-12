//
//  CRMLog.m
//  Utility
//
//  Created by chdo on 2017/12/8.
//

#import "CRMLog.h"
#import <MessageUI/MessageUI.h>
#import "AATHUD.h"
#import "CRMCrash.h"

@interface CRMLogManger()<MFMailComposeViewControllerDelegate>
{
    NSMutableString *logContent;
    NSString *logFoldDirect;
    NSFileManager *manger;
}
@end


@implementation CRMLogManger

+(CRMLogManger *)shareLog{
    static dispatch_once_t onceToken;
    static CRMLogManger *loger;
    dispatch_once(&onceToken, ^{
        
        loger = [[CRMLogManger alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        path = [path stringByAppendingPathComponent:@"crmLog"];
        loger->logFoldDirect = path;
        
        loger->manger = [NSFileManager defaultManager];
        
        [[NSNotificationCenter defaultCenter] addObserver:loger selector:@selector(saveLog) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:loger selector:@selector(saveLog) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:loger selector:@selector(saveLog) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    });
    return loger;
}


+(void)writeLogTolocal{
    [[CRMLogManger shareLog] saveLog];
}

+(void)cleanLocalLog{
    CRMLogManger *loger = [CRMLogManger shareLog];
    [loger->manger removeItemAtPath:loger->logFoldDirect error:nil];
}

-(void)startLog {

    CRMInstallUncaughtExceptionHandler();
    
    
    CRMLogManger *loger = [CRMLogManger shareLog];
    loger-> logContent = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@ 日志开始\n",[loger timeStr]]];
    NSLog(@"%@", loger-> logContent);
}

-(void)addlog:(NSString *)string{
    NSString *logStr;
    if (logContent) {
        logStr = [NSString stringWithFormat:@"%@  %@\n",[self timeStr],string];
    } else {
        logStr = [NSString stringWithFormat:@"%@ 日志开始\n",[self timeStr]];
        logContent = [[NSMutableString alloc] init];
    }
    NSLog(@"%@",logStr);
    [logContent appendString: logStr];
    if (logContent.length > 20000) {
        [self saveLog];
    }
}



-(void)saveLog{
    if (logContent) {
        NSString *lastLog = [NSString stringWithFormat:@"%@  日志结束", [self timeStr]];
        NSLog(@"%@", lastLog);
        [logContent appendString:lastLog];
    
        NSData *data = [logContent dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:[self logDirect] atomically:YES];
        NSError *err;
        NSString *path = [self logDirect];
        [data writeToFile:path options:NSDataWritingAtomic error:&err];
        if (err) {
            
        }
    }
    logContent = nil;
}

-(NSString *)logDirect{
    
    BOOL isDirectory, isExist;
    isExist = [manger fileExistsAtPath:logFoldDirect isDirectory:&isDirectory]; // /xxx/xxx/Documents/Users/xxxx/
    
    // 文件夹不存在
    if (!isExist || (isExist && !isDirectory)) { //
        [manger     createDirectoryAtPath:logFoldDirect
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:nil];
    }
    
    return [logFoldDirect stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", [self timeStr]]];
}

+(void)openSettings{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

+(NSError *)sendLogFile:(NSArray *)Recipients CcRecipients:(NSArray *)CcRecipients{
    
    NSArray * subPaths = [[CRMLogManger shareLog]->manger subpathsAtPath:[CRMLogManger shareLog]->logFoldDirect];
    if (subPaths.count == 0) {
        NSError *err = [NSError errorWithDomain:@"没有日志" code:-1 userInfo:nil];
        return err;
    }
    
    if (![MFMailComposeViewController canSendMail]){
        NSError *err = [NSError errorWithDomain:@"没有设置邮箱账户" code:-2 userInfo:nil];
        return err;
    }
    
    // 创建邮件发送界面
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:[CRMLogManger shareLog]];
    // 设置收件人
    [mailCompose setToRecipients:Recipients];
    // 设置抄送人
    [mailCompose setCcRecipients:CcRecipients];

    // 设置邮件主题
    [mailCompose setSubject:@"测试日志"];
    //设置邮件的正文内容
    NSString *emailContent = @"将发送下列日志文件";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    // [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    //添加附件
    for (NSString *subPath in subPaths) {
        NSString *filePath = [[CRMLogManger shareLog]->logFoldDirect stringByAppendingPathComponent:subPath];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [mailCompose addAttachmentData:data mimeType:@"txt" fileName:subPath];
    }
    
    // 弹出邮件发送视图
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:mailCompose animated:YES completion:nil];
    return nil;
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error) {
        [AATHUD showInfo:error.description  andDismissAfter:0.6];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)timeStr{
    NSDate *date = [NSDate date];
    NSDateFormatter * formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"YYYY-MM-dd:HH:mm:ss"];
    return [formate stringFromDate:date];
}

@end


void CRMLog(NSString *log) {
//
//    va_list args;
//
//    if (format) {
//        NSLog(@"format:%@",format);
//        va_start(args, format);
//        while(YES){
////        while (( str = va_arg(args, NSString *))) {
//            id obj=va_arg(args,id);
//            if(obj==nil)break;
//            NSLog(@"打小卷的帮凶有：%@", obj);
//        }
//    }
//    va_end(args);
    [[CRMLogManger shareLog] addlog:log];
}

void CRMStartLog(void){
    [[CRMLogManger shareLog] startLog];
}

void CRMLogLocallize(void){
    [[CRMLogManger shareLog] saveLog];
}

NSError *CRMSendLog(NSArray *Recipients, NSArray *CcRecipients){
    return [CRMLogManger sendLogFile:Recipients CcRecipients:CcRecipients];
}
