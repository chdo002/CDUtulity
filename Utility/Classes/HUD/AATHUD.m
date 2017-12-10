//
//  AATHUD.m
//  Pods-Utility_Example
//
//  Created by chdo on 2017/12/10.
//

#import "AATHUD.h"

static const CGFloat SVProgressHUDParallaxDepthPoints = 10.0f;
static const CGFloat SVProgressHUDUndefinedProgress = -1;
static const CGFloat SVProgressHUDDefaultAnimationDuration = 0.15f;
static const CGFloat SVProgressHUDVerticalSpacing = 12.0f;
static const CGFloat SVProgressHUDHorizontalSpacing = 12.0f;
static const CGFloat SVProgressHUDLabelSpacing = 8.0f;

@interface AATHUD()

@property (nonatomic, readonly) UIWindow *frontWindow;

@end
@implementation AATHUD

+(void)showProgress{
    [[self sharedView] showProgress:SVProgressHUDUndefinedProgress status:nil];
}

+(void)showInfo:(NSString *)infoString{
    
}

+(void)showInfo:(NSString *)infoString hasProgress:(BOOL)showPorg{
    
}

+(void)dismiss{
    
}

- (void)showProgress:(float)progress status:(NSString*)status {
    __weak AATHUD *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong AATHUD *strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        
        
    }];
}

+ (AATHUD*)sharedView {
    static dispatch_once_t once;
    
    static AATHUD *sharedView;
    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return sharedView;
}

- (UIWindow *)frontWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        BOOL windowKeyWindow = window.isKeyWindow;
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return nil;
}

-(void)updateViewHierarchy{
//    // Add the overlay to the application window if necessary
//    if(!self.controlView.superview) {
//        if(self.containerView){
//            [self.containerView addSubview:self.controlView];
//        } else {
//#if !defined(SV_APP_EXTENSIONS)
//            [self.frontWindow addSubview:self.controlView];
//#else
//            // If SVProgressHUD is used inside an app extension add it to the given view
//            if(self.viewForExtension) {
//                [self.viewForExtension addSubview:self.controlView];
//            }
//#endif
//        }
//    } else {
//        // The HUD is already on screen, but maybe not in front. Therefore
//        // ensure that overlay will be on top of rootViewController (which may
//        // be changed during runtime).
//        [self.controlView.superview bringSubviewToFront:self.controlView];
//    }
//
//    // Add self to the overlay view
//    if(!self.superview) {
//        [self.controlView addSubview:self];
//    }
}

@end
