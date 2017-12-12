//
//  NSString+Extend.h
//  Pods-Utility_Example
//
//  Created by chdo on 2017/12/12.
//

#import <Foundation/Foundation.h>
#import<UIKit/UIKit.h>

@interface NSString (Extend)


-(UIColor *)hexStringToColor;

-(NSString *)MD5;

- (NSDictionary *)dictionaryWithJsonString;

// 时间戳转字符串
+ (NSString *)dateFromTimeStamp:(NSString *)strTime;

// 时间戳转字符串2
+ (NSString *)dateFromTimeStamp_2:(NSString *)strTime;

// 时间戳转字符串3
+ (NSString *)dateFromTimeStamp_3:(NSString *)strTime;

// 生成 时间戳；
+(NSString*)dateTimeStamp;
// msgId  生成；
+(NSString*)createMsgId;


// 字符串 转 时间戳；
-(NSString*)timeStringToTimeStamp;

- (NSDate *)dateOfTimeStamp;

@end
