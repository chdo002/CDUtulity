//
//  AATHUD.m
//  Pods-Utility_Example
//
//  Created by chdo on 2017/12/10.
//

#import "AATHUD.h"

static const CGFloat AATHUDVerticalSpacing = 12.0f;
static const CGFloat AATHUDHorizontalSpacing = 12.0f;
static const CGFloat AATHUDLabelSpacing = 8.0f;

static const CGFloat AATHUDNONESTOP = -1.0f;

@interface AATHUD()

@property (strong, nonatomic, nullable) UIView *containerView;

@property (nonatomic, strong) UIVisualEffectView *hudView;
@property (nonatomic, strong) UIView *indefiniteAnimatedView;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, readonly) UIWindow *frontWindow;
@property (assign, nonatomic) CGSize minimumSize;
@property (assign, nonatomic) CGFloat cornerRadius;

@end
@implementation AATHUD


+(void)showLoading{
    [[self sharedView] showInfo:nil hasLoading:YES dismissAfter:AATHUDNONESTOP];
}

+(void)showLoadingAndDismissAfter:(NSTimeInterval)duration{
    [[self sharedView] showInfo:nil hasLoading:YES dismissAfter:duration];
}

+(void)showInfo:(NSString *)infoString{
    [self showInfo:infoString showLoading:NO andDismissAfter:AATHUDNONESTOP];
}

+(void)showInfo:(NSString *)infoString showLoading:(BOOL)showLoading{
    [self showInfo:infoString showLoading:showLoading andDismissAfter:AATHUDNONESTOP];
}

+(void)showInfo:(NSString *)infoString andDismissAfter:(NSTimeInterval)duration{
    [self showInfo:infoString showLoading:NO andDismissAfter:duration];
}

// ---------------------------
+(void)showInfo:(NSString *)infoString showLoading:(BOOL)showLoading andDismissAfter:(NSTimeInterval)duration{
    [[self sharedView] showInfo:infoString hasLoading:showLoading dismissAfter:duration];
}

+(void)dismiss{
    [[AATHUD sharedView] dismissWithDelay:0 complete:nil];
}



-(void)showInfo:(NSString *)info hasLoading:(BOOL)showLoading dismissAfter:(NSTimeInterval)duration{
    __weak AATHUD *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong AATHUD *strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        strongSelf.statusLabel.hidden = info.length == 0;
        strongSelf.statusLabel.text = info;
        
        // 确保hud显示
        [strongSelf updateViewHierarchy];
        
        // 更新位置
        [strongSelf updateHUDFrame:showLoading];
//        if (!strongSelf.hudView.effect) {
         strongSelf.hudView.transform = strongSelf.hudView.transform = CGAffineTransformScale(strongSelf.hudView.transform, 1/1.1f, 1/1.1f);
//        }
        
        [UIView animateWithDuration:0.15
                              delay:0
                            options:(UIViewAnimationOptions) (UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             strongSelf.hudView.transform = CGAffineTransformIdentity;
                             // 更新HUD显示效果
                             [strongSelf fadeInEffects];
                         } completion:^(BOOL finished) {
                             
                             if (duration - AATHUDNONESTOP < 0.001) {
                                 return;
                             }
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 [strongSelf dismissWithDelay:0 complete:nil];
                             });
                         }];
        
        // 将indicator加进HUD
        [strongSelf.hudView.contentView addSubview:strongSelf.indefiniteAnimatedView];
        
        if([strongSelf.indefiniteAnimatedView respondsToSelector:@selector(startAnimating)]) {
            if (showLoading) {
                [(id)strongSelf.indefiniteAnimatedView startAnimating];
            } else {
                [(id)strongSelf.indefiniteAnimatedView stopAnimating];
            }
        }
        
    }];
}

- (void)dismissWithDelay:(NSTimeInterval)delay complete:(void(^)(void))completion{
    __weak AATHUD *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong AATHUD *strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        [UIView animateWithDuration:0.15 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            strongSelf.hudView.transform = CGAffineTransformScale(strongSelf.hudView.transform, 1/1.1f, 1/1.1f);
            [strongSelf fadeOutEffects];
            
        } completion:^(BOOL finished) {
            [strongSelf cancelIndefiniteAnimatedViewAnimation];
            [strongSelf.hudView removeFromSuperview];
            [strongSelf removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    }];
}



- (UIVisualEffectView*)hudView {
    
    if(!_hudView) {
        _hudView = [UIVisualEffectView new];
        _hudView.layer.masksToBounds = YES;
        _hudView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    }
    
    if(!_hudView.superview) {
        [self addSubview:_hudView];
    }
    
    // Update styling
    _hudView.layer.cornerRadius = self.cornerRadius;
    
    return _hudView;
}


- (UILabel*)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.adjustsFontSizeToFitWidth = YES;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _statusLabel.numberOfLines = 0;
    }
    if(!_statusLabel.superview) {
        [self.hudView.contentView addSubview:_statusLabel];
    }
    
    // Update styling
    _statusLabel.textColor = self.foregroundColorForStyle;
    _statusLabel.font = self.font;
    
    return _statusLabel;
}


- (UIColor*)foregroundColorForStyle {
    if(self.defaultStyle == AATHUDStyleLight) {
        return [UIColor blackColor];
    } else if(self.defaultStyle == AATHUDStyleDark) {
        return [UIColor whiteColor];
    }
    return [UIColor whiteColor];
}

- (UIColor*)backgroundColorForStyle {
    if(self.defaultStyle == AATHUDStyleLight) {
        return [UIColor whiteColor];
    } else if(self.defaultStyle == AATHUDStyleDark) {
        return [UIColor blackColor];
    } else {
        return self.backgroundColor;
    }
}

-(UIView *)indefiniteAnimatedView{
    
    if (self.defaultAnimationType == AATHUDAnimationTypeFlat) {
        
    } else {
        if(_indefiniteAnimatedView && ![_indefiniteAnimatedView isKindOfClass:[UIActivityIndicatorView class]]){
            [_indefiniteAnimatedView removeFromSuperview];
            _indefiniteAnimatedView = nil;
        }
        
        if(!_indefiniteAnimatedView){
            _indefiniteAnimatedView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }
        // Update styling
        UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView*)_indefiniteAnimatedView;
        activityIndicatorView.color = self.foregroundColorForStyle;
    }
    return _indefiniteAnimatedView;
}

+ (AATHUD*)sharedView {
    static dispatch_once_t once;
    
    static AATHUD *sharedView;
    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return sharedView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
        
        _cornerRadius = 14.0f;
        _defaultStyle = AATHUDStyleDark;
        _defaultAnimationType = AATHUDAnimationTypeNative;
        _minimumSize = CGSizeZero;
        _font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    }
    return self;
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

- (void)fadeInEffects {
    UIBlurEffectStyle blurEffectStyle = self.defaultStyle == AATHUDStyleDark ? UIBlurEffectStyleDark : UIBlurEffectStyleLight;
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:blurEffectStyle];
    self.hudView.effect = blurEffect;
    self.hudView.backgroundColor = [self.backgroundColorForStyle colorWithAlphaComponent:0.6f];
    self.statusLabel.alpha = 1.0f;
    self.indefiniteAnimatedView.alpha = 1.0f;
}


- (void)fadeOutEffects {
    // Remove background color
    self.hudView.effect = nil;
    self.hudView.backgroundColor = [UIColor clearColor];
    self.statusLabel.alpha = 0.0f;
    self.indefiniteAnimatedView.alpha = 0.0f;
}


- (void)cancelIndefiniteAnimatedViewAnimation {
    // Stop animation
    if([self.indefiniteAnimatedView respondsToSelector:@selector(stopAnimating)]) {
        [(id)self.indefiniteAnimatedView stopAnimating];
    }
    // Remove from view
    [self.indefiniteAnimatedView removeFromSuperview];
}


- (void)updateHUDFrame:(BOOL)showLoading{
    
    // 文字位置
    CGRect labelRect = CGRectZero;
    CGFloat labelHeight = 0.0f;
    CGFloat labelWidth = 0.0f;
    
    if(self.statusLabel.text) {
        CGSize constraintSize = CGSizeMake(200.0f, 300.0f);
        labelRect = [self.statusLabel.text boundingRectWithSize:constraintSize
                                                        options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin)
                                                     attributes:@{NSFontAttributeName: self.statusLabel.font}
                                                        context:NULL];
        labelHeight = ceilf(CGRectGetHeight(labelRect));
        labelWidth = ceilf(CGRectGetWidth(labelRect));
    }
    
    
    CGFloat hudWidth;
    CGFloat hudHeight;
    
    // loading位置
    CGFloat contentWidth = CGRectGetWidth(self.indefiniteAnimatedView.frame);
    CGFloat contentHeight =CGRectGetHeight(self.indefiniteAnimatedView.frame);
    if (showLoading && self.statusLabel.text) {
        hudWidth = AATHUDHorizontalSpacing + MAX(labelWidth, contentWidth) + AATHUDHorizontalSpacing;
        hudHeight = AATHUDVerticalSpacing + contentHeight + AATHUDLabelSpacing + labelHeight + AATHUDVerticalSpacing;
    } else {
        hudWidth = AATHUDHorizontalSpacing + MAX(labelWidth, contentWidth) + AATHUDHorizontalSpacing;
        hudHeight = AATHUDVerticalSpacing + labelHeight + (showLoading ? contentWidth : 0) + AATHUDVerticalSpacing;
    }
    
    // Update values on subviews
    self.hudView.bounds = CGRectMake(0.0f, 0.0f, MAX(self.minimumSize.width, hudWidth), MAX(self.minimumSize.height, hudHeight));
    self.hudView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // Animate value update
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CGFloat centerY = (showLoading ? AATHUDVerticalSpacing  + CGRectGetHeight(self.indefiniteAnimatedView.frame) * 0.5 : 0);
    self.indefiniteAnimatedView.center = CGPointMake(CGRectGetMidX(self.hudView.bounds), centerY);
    
    // Label
    self.statusLabel.frame = labelRect;
    
    centerY =   AATHUDVerticalSpacing +
                (showLoading ? CGRectGetHeight(self.indefiniteAnimatedView.frame) + AATHUDLabelSpacing : 0)+
                CGRectGetMidY(labelRect);
    
    self.statusLabel.center = CGPointMake(CGRectGetMidX(self.hudView.bounds), centerY);
    
    [CATransaction commit];

}

-(void)updateViewHierarchy{
    if (!self.superview) {
        [self.frontWindow addSubview:self];
    } else {
        [self.superview bringSubviewToFront:self];
    }
}

#pragma mark 警告框

+(void)alert:(NSString *)info message:(NSString *)msg{
    [self alert:info message:msg confirm:nil cancle:nil];
}

+(void)alert:(NSString *)info message:(NSString *)msg confirm:(void(^)(void))comfirm{
    [self alert:info message:msg confirm:comfirm cancle:nil];
}

+(void)alert:(NSString *)info message:(NSString *)msg confirm:(void(^)(void))comfirm cancle:(void(^)(void))cancle{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:info message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *comfirmAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if (comfirm) {
            comfirm();
//        }
    }];
    UIAlertAction *comfirmCa = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancle();
    }];
    
    [alertVC addAction:comfirmAc];
    if (cancle) {
        [alertVC addAction:comfirmCa];
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}


@end
