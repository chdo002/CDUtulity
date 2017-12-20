/*
 * This file is part of the AATWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIButton+WebCache.h"

#if AAT_UIKIT

#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
#import "UIView+WebCache.h"

static char imageURLStorageKey;

typedef NSMutableDictionary<NSString *, NSURL *> SDStateImageURLDictionary;

static inline NSString * imageURLKeyForState(UIControlState state) {
    return [NSString stringWithFormat:@"image_%lu", (unsigned long)state];
}

static inline NSString * backgroundImageURLKeyForState(UIControlState state) {
    return [NSString stringWithFormat:@"backgroundImage_%lu", (unsigned long)state];
}

@implementation UIButton (WebCache)

#pragma mark - Image

- (nullable NSURL *)aat_currentImageURL {
    NSURL *url = self.imageURLStorage[imageURLKeyForState(self.state)];

    if (!url) {
        url = self.imageURLStorage[imageURLKeyForState(UIControlStateNormal)];
    }

    return url;
}

- (nullable NSURL *)aat_imageURLForState:(UIControlState)state {
    return self.imageURLStorage[imageURLKeyForState(state)];
}

- (void)aat_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state {
    [self aat_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)aat_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder {
    [self aat_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)aat_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder options:(AATWebImageOptions)options {
    [self aat_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)aat_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state completed:(nullable AATExternalCompletionBlock)completedBlock {
    [self aat_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)aat_setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder completed:(nullable AATExternalCompletionBlock)completedBlock {
    [self aat_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)aat_setImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
          placeholderImage:(nullable UIImage *)placeholder
                   options:(AATWebImageOptions)options
                 completed:(nullable AATExternalCompletionBlock)completedBlock {
    if (!url) {
        [self.imageURLStorage removeObjectForKey:imageURLKeyForState(state)];
    } else {
        self.imageURLStorage[imageURLKeyForState(state)] = url;
    }
    
    __weak typeof(self)weakSelf = self;
    [self aat_internalSetImageWithURL:url
                    placeholderImage:placeholder
                             options:options
                        operationKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]
                       setImageBlock:^(UIImage *image, NSData *imageData) {
                           [weakSelf setImage:image forState:state];
                       }
                            progress:nil
                           completed:completedBlock];
}

#pragma mark - Background image

- (nullable NSURL *)aat_currentBackgroundImageURL {
    NSURL *url = self.imageURLStorage[backgroundImageURLKeyForState(self.state)];
    
    if (!url) {
        url = self.imageURLStorage[backgroundImageURLKeyForState(UIControlStateNormal)];
    }
    
    return url;
}

- (nullable NSURL *)aat_backgroundImageURLForState:(UIControlState)state {
    return self.imageURLStorage[backgroundImageURLKeyForState(state)];
}

- (void)aat_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state {
    [self aat_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)aat_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder {
    [self aat_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)aat_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder options:(AATWebImageOptions)options {
    [self aat_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)aat_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state completed:(nullable AATExternalCompletionBlock)completedBlock {
    [self aat_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)aat_setBackgroundImageWithURL:(nullable NSURL *)url forState:(UIControlState)state placeholderImage:(nullable UIImage *)placeholder completed:(nullable AATExternalCompletionBlock)completedBlock {
    [self aat_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)aat_setBackgroundImageWithURL:(nullable NSURL *)url
                            forState:(UIControlState)state
                    placeholderImage:(nullable UIImage *)placeholder
                             options:(AATWebImageOptions)options
                           completed:(nullable AATExternalCompletionBlock)completedBlock {
    if (!url) {
        [self.imageURLStorage removeObjectForKey:backgroundImageURLKeyForState(state)];
    } else {
        self.imageURLStorage[backgroundImageURLKeyForState(state)] = url;
    }
    
    __weak typeof(self)weakSelf = self;
    [self aat_internalSetImageWithURL:url
                    placeholderImage:placeholder
                             options:options
                        operationKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]
                       setImageBlock:^(UIImage *image, NSData *imageData) {
                           [weakSelf setBackgroundImage:image forState:state];
                       }
                            progress:nil
                           completed:completedBlock];
}

- (void)aat_setImageLoadOperation:(id<AATWebImageOperation>)operation forState:(UIControlState)state {
    [self aat_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)aat_cancelImageLoadForState:(UIControlState)state {
    [self aat_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)aat_setBackgroundImageLoadOperation:(id<AATWebImageOperation>)operation forState:(UIControlState)state {
    [self aat_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (void)aat_cancelBackgroundImageLoadForState:(UIControlState)state {
    [self aat_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (SDStateImageURLDictionary *)imageURLStorage {
    SDStateImageURLDictionary *storage = objc_getAssociatedObject(self, &imageURLStorageKey);
    if (!storage) {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &imageURLStorageKey, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return storage;
}

@end

#endif
