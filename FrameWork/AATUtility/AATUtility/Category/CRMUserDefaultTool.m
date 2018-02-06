//
//  UserDefaultTool.m
//  CRMSDK
//
//  Created by chuxiao on 16/8/8.
//  Copyright © 2016年 chuxiao. All rights reserved.
//

#import "CRMUserDefaultTool.h"

@implementation CRMUserDefaultTool


+ (void)saveObject:(NSString *)key value:(id)value{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:value forKey:key];
}


+ (void)removeObjectWithKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:key];
}


+ (id)getValueForKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:key];
}

@end








