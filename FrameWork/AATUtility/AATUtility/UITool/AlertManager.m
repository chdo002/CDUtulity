//
//  AlertManager.m
//  AlipayBox
//
//  Created by cat on 14-11-3.
//  Copyright (c) 2014年 iMac. All rights reserved.
//

#import "AlertManager.h"

@interface AlertManager ()<UIAlertViewDelegate>
@property (copy, nonatomic) void (^SureBlock)();
@property (copy, nonatomic) void (^NegateBlock)();
@end

@implementation AlertManager


- (void)showWithTitle:(NSString *)title message:(NSString *)message sure:(NSString *)sureText negate:(NSString *)negateText on:(UIViewController *)viewController  sureBlock:(SureBlock)sureBlock negateBlock:(NegateBlock)negateBlock
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (negateText) {
        UIAlertAction * negateAction = [UIAlertAction actionWithTitle:negateText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (negateBlock) {
                negateBlock();
            }
            
        }];
        [alert  addAction:negateAction];
    }
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:sureText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (sureBlock) {
            sureBlock();
        }
    }];
    [alert  addAction:sureAction];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message sure:(NSString *)sureText negate:(NSString *)negateText on:(UIViewController *)viewController  sureBlock:(SureBlock)sureBlock negateBlock:(NegateBlock)negateBlock
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (negateText) {
        UIAlertAction * negateAction = [UIAlertAction actionWithTitle:negateText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (negateBlock) {
                negateBlock();
            }
            
        }];
        [alert  addAction:negateAction];
    }
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:sureText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (sureBlock) {
            sureBlock();
        }
    }];
    [alert  addAction:sureAction];
    [viewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark- UIAlerViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (self.NegateBlock) {
            self.NegateBlock();
        }
    }else if (buttonIndex == 1){
        if (self.SureBlock) {
            self.SureBlock();
        }
    }
}
@end
