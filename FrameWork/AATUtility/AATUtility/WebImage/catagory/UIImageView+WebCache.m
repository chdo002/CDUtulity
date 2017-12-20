/*
 * This file is part of the AATWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"

#if AAT_UIKIT || AAT_MAC

#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
#import "UIView+WebCache.h"

@implementation UIImageView (WebCache)

- (void)aat_setImageWithURL:(nullable NSURL *)url {
    [self aat_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)aat_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder {
    [self aat_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)aat_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(AATWebImageOptions)options {
    [self aat_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)aat_setImageWithURL:(nullable NSURL *)url completed:(nullable AATExternalCompletionBlock)completedBlock {
    [self aat_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)aat_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder completed:(nullable AATExternalCompletionBlock)completedBlock {
    [self aat_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)aat_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(AATWebImageOptions)options completed:(nullable AATExternalCompletionBlock)completedBlock {
    [self aat_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)aat_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(AATWebImageOptions)options
                  progress:(nullable AATWebImageDownloaderProgressBlock)progressBlock
                 completed:(nullable AATExternalCompletionBlock)completedBlock {
    [self aat_internalSetImageWithURL:url
                    placeholderImage:placeholder
                             options:options
                        operationKey:nil
                       setImageBlock:nil
                            progress:progressBlock
                           completed:completedBlock];
}

- (void)aat_setImageWithPreviousCachedImageWithURL:(nullable NSURL *)url
                                 placeholderImage:(nullable UIImage *)placeholder
                                          options:(AATWebImageOptions)options
                                         progress:(nullable AATWebImageDownloaderProgressBlock)progressBlock
                                        completed:(nullable AATExternalCompletionBlock)completedBlock {
    NSString *key = [[AATWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[AATImageCache sharedImageCache] imageFromCacheForKey:key];
    
    [self aat_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];    
}

#if AAT_UIKIT

#pragma mark - Animation of multiple images

- (void)aat_setAnimationImagesWithURLs:(nonnull NSArray<NSURL *> *)arrayOfURLs {
    [self aat_cancelCurrentAnimationImagesLoad];
    __weak __typeof(self)wself = self;

    NSMutableArray<id<AATWebImageOperation>> *operationsArray = [[NSMutableArray alloc] init];

    [arrayOfURLs enumerateObjectsUsingBlock:^(NSURL *logoImageURL, NSUInteger idx, BOOL * _Nonnull stop) {
        id <AATWebImageOperation> operation = [AATWebImageManager.sharedManager loadImageWithURL:logoImageURL options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, AATImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_async_safe(^{
                __strong UIImageView *sself = wself;
                [sself stopAnimating];
                if (sself && image) {
                    NSMutableArray<UIImage *> *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages) {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    
                    // We know what index objects should be at when they are returned so
                    // we will put the object at the index, filling any empty indexes
                    // with the image that was returned too "early". These images will
                    // be overwritten. (does not require additional sorting datastructure)
                    while ([currentImages count] < idx) {
                        [currentImages addObject:image];
                    }
                    
                    currentImages[idx] = image;

                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        }];
        [operationsArray addObject:operation];
    }];

    [self aat_setImageLoadOperation:[operationsArray copy] forKey:@"UIImageViewAnimationImages"];
}

- (void)aat_cancelCurrentAnimationImagesLoad {
    [self aat_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}
#endif

@end

#endif
