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
//UIColor *RGB(CGFloat A, CGFloat B, CGFloat C){
//    return [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0];
//}
CGFloat NaviH(void){
    return 44 + [[UIApplication sharedApplication] statusBarFrame].size.height;
}

CGFloat ScreenW(void){
    return [UIScreen mainScreen].bounds.size.width;
}
CGFloat ScreenH(void){
    return [UIScreen mainScreen].bounds.size.height;
}



NSInteger getSizeOfFilePath(NSString *filePath){
    /** 定义记录大小 */
    NSInteger totalSize = 0;
    /** 创建一个文件管理对象 */
    NSFileManager * manager = [NSFileManager defaultManager];
    /**获取文件下的所有路径包括子路径 */
    NSArray * subPaths = [manager subpathsAtPath:filePath];
    
    /** 遍历获取文件名称 */
    for (NSString * fileName in subPaths) {
        /** 拼接获取完整路径 */
        NSString * subPath = [filePath stringByAppendingPathComponent:fileName];
        /** 判断是否是隐藏文件 */
        if ([fileName hasPrefix:@".DS"]) {
            continue;
        }
        /** 判断是否是文件夹 */
        BOOL isDirectory;
        [manager fileExistsAtPath:subPath isDirectory:&isDirectory];
        if (isDirectory) {
            continue;
        }
        /** 获取文件属性 */
        NSDictionary *dict = [manager attributesOfItemAtPath:subPath error:nil];
        /** 累加 */
        totalSize += [dict fileSize];
        
    }
    if (subPaths.count == 0) {
        NSDictionary *dict = [manager attributesOfItemAtPath:filePath error:nil];
        /** 累加 */
        totalSize += [dict fileSize];
    }
    /** 返回 */
    return totalSize;
}

NSInteger CRMFileSizeByFileUrl(NSURL *filePath){
    return CRMFileSizeByFilePath(filePath.absoluteString);
}

NSInteger CRMFileSizeByFilePath(NSString *filePath){
    return getSizeOfFilePath(filePath);
}





