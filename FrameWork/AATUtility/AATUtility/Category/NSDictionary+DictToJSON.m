//
//  NSDictionary+DictToJSON.m
//  crm_ios
//
//  Created by explorer on 16/3/25.
//  Copyright © 2016年 pingan. All rights reserved.
//

#import "NSDictionary+DictToJSON.h"

@implementation NSDictionary (DictToJSON)
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    if ( dic != nil) {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

@end
