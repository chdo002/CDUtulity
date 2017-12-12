//
//  NSString+Extend.m
//  Pods-Utility_Example
//
//  Created by chdo on 2017/12/12.
//

#import "NSString+Extend.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

@implementation NSString (Extend)

-(UIColor *)hexStringToColor
{
    NSString *cString = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


- (NSString *)MD5
{
    if (!self || self.length <= 0) {
        return nil;
    }
    
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
#if __has_feature(objc_arc)
    return outputString;
#else
    return [outputString autorelease];
#endif
}


- (NSDictionary *)dictionaryWithJsonString {
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


// 时间戳转字符串
+ (NSString *)dateFromTimeStamp:(NSString *)strTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[strTime doubleValue] / 1000];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    
    return confromTimespStr;
}

// 时间戳转字符串2
+ (NSString *)dateFromTimeStamp_2:(NSString *)strTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[strTime doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    
    return confromTimespStr;
}

// 时间戳转字符串3
+ (NSString *)dateFromTimeStamp_3:(NSString *)strTime{
    if (strTime.length == 0) {
        return @" ";
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[strTime doubleValue] / 1000];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    
    return confromTimespStr;
}

// 时间戳转时间
- (NSDate *)dateOfTimeStamp{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue] / 1000];
    return date;
}



+(NSString*)createMsgId{
    long long randNumber = (arc4random()%10000000000) + 10000000000;                                  // 随机数；
    NSString *rand = [NSString stringWithFormat:@"%lld" ,randNumber] ;
    NSString *msgId = [NSString stringWithFormat:@"m%@%@" ,[NSString dateTimeStamp], rand ];
    return msgId;
    
}


//  时间格式字符串 转 时间,日期；
-(NSString*)timeStringToTimeStamp{
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
    //    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    //    [dateFormat setTimeZone:timeZone];
    NSDate *date =[dateFormat dateFromString:self];
    
    // 转换 成功；
    if (date) {
        NSTimeInterval timeInterval = [date timeIntervalSince1970]*1000 ;    // 毫秒；
        long  timeInter = timeInterval;
        NSString *timestamp = [NSString stringWithFormat:@"%ld" ,timeInter] ;
        return timestamp;
        
    }else{
        
        return self;
    }
    
}

+(NSString*)dateTimeStamp{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    double timeInter = recordTime;
    NSString *timestamp = [NSString stringWithFormat:@"%0.f" ,timeInter] ;
    
    return timestamp;
}
@end
