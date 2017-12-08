//
//  UITool.h
//  Utility
//
//  Created by chdo on 2017/12/8.
//

#import <UIKit/UIKit.h>

// 系统版本号
double CRMDeviceSystemVersion(void);

CGSize CRMDeviceScreenSize(void);

/**
 ====================================
 颜色
 ====================================
 */

// 16位颜色
UIColor *CRMHexColor(int hexColor);

//随机色
UIColor *CRMRadomColor(void);

/**
 ====================================
 尺寸
 ====================================
 */

/**
 导航栏高度
 */
CGFloat NaviH(void);
