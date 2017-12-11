//
//  CRMLog.h
//  Utility
//
//  Created by chdo on 2017/12/8.
//

#import <Foundation/Foundation.h>


void CRMLog(NSString *log);

@interface CRMLogManger : NSObject
+(void)writeLogTolocal;

// 用户没有添加邮箱账号时，需引导去设置页添加
+(void)openSettings;


+(NSError *)sendLogFile:(NSArray *)Recipients CcRecipients:(NSArray *)CcRecipients;
@end
