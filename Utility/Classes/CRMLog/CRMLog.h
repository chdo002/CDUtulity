//
//  CRMLog.h
//  Utility
//
//  Created by chdo on 2017/12/8.
//

#import <Foundation/Foundation.h>


void CRMLog(NSString *log);

@interface CRMLogObj : NSObject
+(void)sendLogFile:(NSArray *)Recipients CcRecipients:(NSArray *)CcRecipients;
@end
