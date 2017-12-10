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
    SVProgressHUDStyleCustom        // uses the fore- and background color properties
};

typedef NS_ENUM(NSUInteger, AATHUDMaskType) {
    AATHUDMaskTypeNone = 1,  // default mask type, allow user interactions while HUD is displayed
    AATHUDMaskTypeClear,     // don't allow user interactions with background objects
    AATHUDMaskTypeBlack,     // don't allow user interactions with background objects and dim the UI in the back of the HUD (as seen in iOS 7 and above)
    AATHUDMaskTypeGradient,  // don't allow user interactions with background objects and dim the UI with a a-la UIAlertView background gradient (as seen in iOS 6)
    AATHUDMaskTypeCustom     // don't allow user interactions with background objects and dim the UI in the back of the HUD with a custom color
};


typedef NS_ENUM(NSUInteger, AATHUDAnimationType) {
    AATHUDAnimationTypeFlat,     // default animation type, custom flat animation (indefinite animated ring)
    AATHUDAnimationTypeNative    // iOS native UIActivityIndicatorView
};


@interface AATHUD : UIView


+(void)showProgress;
+(void)showInfo:(NSString *)infoString;
+(void)showInfo:(NSString *)infoString hasProgress:(BOOL)showPorg;

+(void)dismiss;
@end
