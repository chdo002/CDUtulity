//
//  AATHUD.h
//  Pods-Utility_Example
//
//  Created by chdo on 2017/12/10.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AATHUDStyle) {
    AATHUDStyleLight,        // default style, white HUD with black text, HUD background will be blurred
    AATHUDStyleDark,         // black HUD and white text, HUD background will be blurred
};

typedef NS_ENUM(NSUInteger, AATHUDAnimationType) {
    AATHUDAnimationTypeFlat,     // default animation type, custom flat animation (indefinite animated ring)
    AATHUDAnimationTypeNative    // iOS native UIActivityIndicatorView
};


@interface AATHUD : UIView

@property (assign, nonatomic) AATHUDStyle defaultStyle;
@property (assign, nonatomic) AATHUDAnimationType defaultAnimationType;
@property (strong, nonatomic) UIFont *font;

+(void)showLoading;
+(void)showLoadingAndDismissAfter:(NSTimeInterval)duration;

+(void)showInfo:(NSString *)infoString;
+(void)showInfo:(NSString *)infoString andDismissAfter:(NSTimeInterval)duration;

+(void)showInfo:(NSString *)infoString showLoading:(BOOL)showLoading;
+(void)showInfo:(NSString *)infoString showLoading:(BOOL)showLoading andDismissAfter:(NSTimeInterval)duration;

+(void)dismiss;


+(void)alert:(NSString *)info message:(NSString *)msg;
+(void)alert:(NSString *)info message:(NSString *)msg confirm:(void(^)(void))comfirm;
+(void)alert:(NSString *)info message:(NSString *)msg confirm:(void(^)(void))comfirm cancle:(void(^)(void))cancle;
@end
