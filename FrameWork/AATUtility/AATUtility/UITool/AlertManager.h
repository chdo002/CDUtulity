//
//  AlertManager.h
//  AlipayBox
//
//  Created by cat on 14-11-3.
//  Copyright (c) 2014年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SureBlock)();
typedef void (^NegateBlock)();


/**
 *  警告:本CRM项目适配iOS8及以上，可直接使用
 *  若要兼容iOS7，必须作为属性来使用，并添加iOS7相关代码
 */
@interface AlertManager : NSObject

- (void)showWithTitle:(NSString *)title message:(NSString *)message sure:(NSString *)sureTitle negate:(NSString *)negateTitle on:(UIViewController *)viewController sureBlock:(SureBlock)sureBlock negateBlock:(NegateBlock)negateBlock;

+ (void)showWithTitle:(NSString *)title message:(NSString *)message sure:(NSString *)sureTitle negate:(NSString *)negateTitle on:(UIViewController *)viewController sureBlock:(SureBlock)sureBlock negateBlock:(NegateBlock)negateBlock;
@end
