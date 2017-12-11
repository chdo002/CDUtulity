//
//  UITool.h
//  Utility
//
//  Created by chdo on 2017/12/8.
//

#import <UIKit/UIKit.h>

// 系统版本号
double CRMDeviceSystemVersion(void);

CGSize CRMScreenSize(void);

/**
 颜色
 */
UIColor *CRMHexColor(int hexColor); // 16位颜色
UIColor *CRMRadomColor(void); //随机色



/**
 尺寸
 */
CGFloat NaviH(void);
CGFloat ScreenW(void);
CGFloat ScreenH(void);


//
NSInteger CRMFileSizeByFileUrl(NSURL *filePath);
NSInteger CRMFileSizeByFilePath(NSString *filePath);

