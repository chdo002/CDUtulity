//
//  UITool.m
//  Utility
//
//  Created by chdo on 2017/12/8.
//

#import "UITool.h"

double CRMDeviceSystemVersion(void) {
    static double version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.doubleValue;
    });
    return version;
}


CGSize CRMScreenSize(void) {
    
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height <= size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}


UIColor *CRMHexColor(int hexColor){
    UIColor *color = [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1];
    return color;
}

UIColor *CRMRadomColor(){
    return [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
}

CGFloat NaviH(void){
    return 44 + [[UIApplication sharedApplication] statusBarFrame].size.height;
}

CGFloat ScreenW(void){
    return [UIScreen mainScreen].bounds.size.width;
}
CGFloat ScreenH(void){
    return [UIScreen mainScreen].bounds.size.height;
}

