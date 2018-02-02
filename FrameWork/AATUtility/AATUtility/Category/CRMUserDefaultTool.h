//
//  UserDefaultTool.h
//  CRMSDK
//
//  Created by chuxiao on 16/8/8.
//  Copyright © 2016年 chuxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRMUserDefaultTool : NSObject

+ (instancetype)share;

- (void)saveObject:(NSString *)key value:(id)value;
- (void)removeObjectWithKey:(NSString *)key;
- (id)getValueForKey:(NSString *)key;

@end
