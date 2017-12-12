#import "NSString+SLMFramework.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SLMFramework)

-(NSString*)stringEncode{
     return  [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}

//-(NSString)stringDecode{
//    return  [self stringbyre
// }

- (BOOL)isNumberWords
{
    NSString *string = @"^[A-Za-z0-9@.]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", string];
    
    if (([predicate evaluateWithObject:self] == YES)) {
        return YES;
    }
        
    return NO;
}

 - (BOOL)isPhoneNumber
{
    NSString *string = @"^[0-9]{11,12}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", string];
    
    if (([predicate evaluateWithObject:self] == YES)) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isVerificationNumber{
    NSString *string = @"^[0-9]{4,8}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", string];
    
    if (([predicate evaluateWithObject:self] == YES)) {
        return YES;
    }
    
    return NO;

    
}
 - (NSDate *)slm_date
{
    if (self.length <= 0) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:self];
#if !__has_feature(objc_arc)
    [formatter release];
#endif
    return date;
}

- (id)slm_JSONValue
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return nil;
    }
    
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingAllowFragments
                                               error:&error];
    
    if (!obj || error) {
        return nil;
    }
    return obj;
}

- (NSString *)slm_md5
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

- (int)slm_chineseLength
{
    NSUInteger strlength = 0;
    const char *p = [self cStringUsingEncoding:NSUnicodeStringEncoding];
    int length = (int)[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
    int i;
    for (i = 0; i < length; i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (int)(strlength + 1) / 2;
}

- (NSString *)slm_underlineToDump
{
    const char *src = [self UTF8String];
    unsigned long len = strlen(src) + 1;
    char *desc = (char *)malloc(sizeof(char) * len);
    memset(desc, 0, sizeof(char) * len);
    BOOL flag = NO;
    char *temp = (char *)desc;
    char c;
    while ((c = *src++) != '\0') {
        if (c == '_') {
            flag = YES;
            continue;
        }
        if (flag && (c > 'a') && (c < 'z')) {
            *temp++ = c - 32;
        }
        else {
            *temp++ = c;
        }
        flag = NO;
    }
    NSString *result = [[NSString alloc] initWithCString:desc
                                                encoding:NSUTF8StringEncoding];
    free(desc);
#if __has_feature(objc_arc)
    return result;
#else
    return [result autorelease];
#endif
}

@end
