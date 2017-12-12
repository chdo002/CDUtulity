//
//  NSString+String.m
//  CRMSDKDemo
//
//  Created by chuxiao on 16/8/9.
//  Copyright © 2016年 chuxiao. All rights reserved.
//

#import "NSString+AATString.h"

@implementation NSString (AATString)

+ (NSString *) encryptUseDES:(NSString *)plainText
{
    
    NSString *Code = plainText;
    
    Code = [Code stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    Code = [Code stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    Code = [Code stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    Code = [Code stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    return Code;
    
}

+ (NSString *) decryptedUseDES:(NSString *)plainText
{
    
    NSString *Code = plainText;
    
    Code = [Code stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    Code = [Code stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    Code = [Code stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    Code = [Code stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    return Code;
    
}


+ (NSString *)array_descriptionWithLocale:(NSArray *)array
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu (\n", (unsigned long)array.count];
    
    for (id obj in array) {
        [str appendFormat:@"\t%@, \n", obj];
    }
    
    [str appendString:@")"];
    
    return str;
}

+ (NSString *)dictionary_descriptionWithLocale:(NSDictionary *)dictionary
{
    
    NSArray *allKeys = [dictionary allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n"];
    for (NSString *key in allKeys) {
        id value= dictionary[key];
        [str appendFormat:@"\t\"%@\" = ",key];
   
        int count = 2;
        while ([value isKindOfClass:[NSDictionary class]]) {
            [str appendFormat:@"{\n"];
            
            for (int i = 0; i < count; i ++) {
                [str appendString:@"\t"];
            }
            
            NSArray *allKeys2 = [value allKeys];
            id value2 = nil;
            for (NSString *key in allKeys2) {
                value2 = value[key];
                [str appendFormat:@"\"%@\" = ",key];
                if ([value2 isKindOfClass:[NSString class]]) {
                    [str appendFormat:@"%@\n",value2];
                }
            }
            count ++;
            value = value2;
        }
        
        if (count == 2) {
            [str appendFormat:@"%@\n",value];
        }
        
    }
    [str appendString:@"}"];
    
    return str;
}

+ (id)descriptionWithLocale:(id)obj count:(int)count{
    
    int COUNT = count;
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        
        NSArray *allKeys = [obj allKeys];
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\n"];
        for (NSString *key in allKeys) {
            id value= obj[key];
            
            for (int i = 0; i < COUNT; i ++) {
                [str appendString:@"\t"];
            }
            
            [str appendFormat:@"\"%@\" = ",key];
            if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]){
                int COUNT2 = COUNT + 1;
                id value2 = [NSString descriptionWithLocale:value count:COUNT2];
                [str appendFormat:@"%@,\n",value2];
            }else {
                [str appendFormat:@"%@,\n",value];
            }
        }
        
        for (int i = 0; i < COUNT-1; i ++) {
            [str appendString:@"\t"];
        }
        [str appendString:@"}"];
        return str;
    }
    
    else if([obj isKindOfClass:[NSArray class]]){
        NSArray *array = obj;
        
        NSMutableString *str = [@"(\n" mutableCopy];
        
        for (int i = 0; i < COUNT; i ++) {
            [str appendString:@"\t"];
        }

        for (id value in array) {
            if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                int COUNT2 = COUNT + 1;
                id value2 = [NSString descriptionWithLocale:value count:COUNT2];
                [str appendFormat:@"%@,\n",value2];
            }else{
                [str appendFormat:@"%@,\n", value];
            }
            
            
            
        }
        for (int i = 0; i < COUNT-1; i ++) {
            [str appendString:@"\t"];
        }
        [str appendString:@")"];
        
        return str;
    } else {
        return @"";
    }
    
}

@end
