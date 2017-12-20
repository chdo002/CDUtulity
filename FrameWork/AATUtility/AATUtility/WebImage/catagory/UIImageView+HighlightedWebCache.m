/*
 * This file is part of the AATWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+HighlightedWebCache.h"

#if AAT_UIKIT

#import "UIView+WebCacheOperation.h"
#import "UIView+WebCache.h"

@implementation UIImageView (HighlightedWebCache)

- (void)aat_setHighlightedImageWithURL:(nullable NSURL *)url {
    [self aat_setHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)aat_setHighlightedImageWithURL:(nullable NSURL *)url options:(AATWebImageOptions)options {
    [self aat_setHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)aat_setHighlightedImageWithURL:(nullable NSURL *)url completed:(nullable AATExternalCompletionBlock)completedBlock {
    [self aat_setHighlightedImageWithURL:url options:0 progress:nil completed:completedBlock];
}

- (void)aat_setHighlightedImageWithURL:(nullable NSURL *)url options:(AATWebImageOptions)options completed:(nullable AATExternalCompletionBlock)completedBlock {
    [self aat_setHighlightedImageWithURL:url options:options progress:nil completed:completedBlock];
}

- (void)aat_setHighlightedImageWithURL:(nullable NSURL *)url
                              options:(AATWebImageOptions)options
                             progress:(nullable AATWebImageDownloaderProgressBlock)progressBlock
                            completed:(nullable AATExternalCompletionBlock)completedBlock {
    __weak typeof(self)weakSelf = self;
    [self aat_internalSetImageWithURL:url
                    placeholderImage:nil
                             options:options
                        operationKey:@"UIImageViewImageOperationHighlighted"
                       setImageBlock:^(UIImage *image, NSData *imageData) {
                           weakSelf.highlightedImage = image;
                       }
                            progress:progressBlock
                           completed:completedBlock];
}

@end

#endif
