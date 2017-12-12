//
//  NSString+String.h
//  CRMSDKDemo
//
//  Created by chuxiao on 16/8/9.
//  Copyright © 2016年 chuxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AATString)
+ (NSString *) encryptUseDES:(NSString *)plainText;
+ (NSString *) decryptedUseDES:(NSString *)plainText;

+ (NSString *)array_descriptionWithLocale:(NSArray *)array;
+ (id)descriptionWithLocale:(id)obj count:(int)count;

@end
