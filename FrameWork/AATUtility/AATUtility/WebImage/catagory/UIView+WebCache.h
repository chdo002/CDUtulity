/*
 * This file is part of the AATWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "AATWebImageCompat.h"

#if AAT_UIKIT || aat_MAC

#import "AATWebImageManager.h"

typedef void(^SDSetImageBlock)(UIImage * _Nullable image, NSData * _Nullable imageData);

@interface UIView (WebCache)

/**
 * Get the current image URL.
 *
 * Note that because of the limitations of categories this property can get out of sync
 * if you use setImage: directly.
 */
- (nullable NSURL *)aat_imageURL;

/**
 * Set the imageView `image` with an `url` and optionally a placeholder image.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see AATWebImageOptions for the possible values.
 * @param operationKey   A string to be used as the operation key. If nil, will use the class name
 * @param setImageBlock  Block used for custom set image code
 * @param progressBlock  A block called while image is downloading
 *                       @note the progress block is executed on a background queue
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrieved from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)aat_internalSetImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                           options:(AATWebImageOptions)options
                      operationKey:(nullable NSString *)operationKey
                     setImageBlock:(nullable SDSetImageBlock)setImageBlock
                          progress:(nullable AATWebImageDownloaderProgressBlock)progressBlock
                         completed:(nullable AATExternalCompletionBlock)completedBlock;

/**
 * Cancel the current download
 */
- (void)aat_cancelCurrentImageLoad;

#if AAT_UIKIT

#pragma mark - Activity indicator

/**
 *  Show activity UIActivityIndicatorView
 */
- (void)aat_setShowActivityIndicatorView:(BOOL)show;

/**
 *  set desired UIActivityIndicatorViewStyle
 *
 *  @param style The style of the UIActivityIndicatorView
 */
- (void)aat_setIndicatorStyle:(UIActivityIndicatorViewStyle)style;

- (BOOL)aat_showActivityIndicatorView;
- (void)aat_addActivityIndicator;
- (void)aat_removeActivityIndicator;

#endif

@end

#endif
