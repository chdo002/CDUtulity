//
//  UIScreen+CRM.m
//  Pods-Utility_Example
//
//  Created by chdo on 2017/12/9.
//

#import "UIScreen+CRM.h"

@implementation UIScreen (CRM)

+(UIImage *)snapShot{
    // UIStatusBar 木有
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, 0);
    CGContextRef cot = UIGraphicsGetCurrentContext();
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:cot];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    return img;
}

@end
