//
//  NSString+MD5.m
//  Pods-Utility_Example
//
//  Created by chdo on 2017/12/11.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)slm_md5: (NSString* )ori
{
    if (!ori || ori.length <= 0) {
        return nil;
    }
    
    const char *value = [ori UTF8String];
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

@end
