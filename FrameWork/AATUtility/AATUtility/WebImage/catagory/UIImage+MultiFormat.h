/*
 * This file is part of the AATWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "AATWebImageCompat.h"
#import "NSData+ImageContentType.h"

@interface UIImage (MultiFormat)

+ (nullable UIImage *)aat_imageWithData:(nullable NSData *)data;
- (nullable NSData *)aat_imageData;
- (nullable NSData *)aat_imageDataAsFormat:(AATImageFormat)imageFormat;

@end
