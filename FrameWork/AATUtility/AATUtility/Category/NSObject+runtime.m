//
//  NSObject+runtime.m
//  AATUtility
//
//  Created by chdo on 2018/1/24.
//  Copyright © 2018年 aat. All rights reserved.
//

#import "NSObject+runtime.h"

@implementation NSObject (runtime)
+ (NSArray *)properties {
    //1获取类的属性
    //参数是 类 和属性的计数指针  返回值是所有属性的数组
    unsigned int count = 0;//属性的计数指针
    objc_property_t *list = class_copyPropertyList([self class], &count);//返回值是所有属性的数组
    //4取得属性名数组
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:count];
    //3 遍历数组
    for(unsigned int i = 0; i < count; ++i)
    {
        //获取到属性
        objc_property_t pty = list[i];
        //获取属性的名称
        const char *cname = property_getName(pty);
        [arrayM addObject:[NSString stringWithUTF8String:cname]];
    }
    free(list);//2 用了class_copyPropertyList方法一定要释放
    
    return arrayM.copy;
}
@end
