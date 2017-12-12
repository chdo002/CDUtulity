//
//  CRMLog.h
//  Utility
//
//  Created by chdo on 2017/12/8.
//

#import <Foundation/Foundation.h>

// 启动日志
void CRMStartLog(void);


// 记录日志
void CRMLog(NSString *log);


// 将日志记录本地  可不调此方法  日志会自动记录到本地
void CRMLogLocallize(void);


// 发送日志
NSError *CRMSendLog(NSArray *Recipients, NSArray *CcRecipients);

@interface CRMLogManger : NSObject
+(void)writeLogTolocal;

// 用户没有添加邮箱账号时，需引导去设置页添加
+(void)openSettings;
+(NSError *)sendLogFile:(NSArray *)Recipients CcRecipients:(NSArray *)CcRecipients;


@end
