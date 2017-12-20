#import <Foundation/Foundation.h>

@interface NSString (SLMFramework)

//predicate
- (BOOL)isNumberWords;

//date
- (NSDate *)slm_date;

//json value
- (id)slm_JSONValue;

//MD5
- (id)slm_md5;

- (int)slm_chineseLength;

/*
 if self using underline naming, such as "user_id",
 then this method returns "userId" which using dump naming.
 */
- (NSString *)slm_underlineToDump;

- (BOOL)isPhoneNumber;
- (BOOL)isVerificationNumber;
@end
