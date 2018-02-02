//
//  NSObject+runtime.h
//  AATUtility
//
//  Created by chdo on 2018/1/24.
//  Copyright © 2018年 aat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (runtime)

+ (NSArray *)properties;

@end
