/*
 * This file is part of the AATWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Fabrice Aneche
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "AATWebImageCompat.h"

typedef NS_ENUM(NSInteger, AATImageFormat) {
    AATImageFormatUndefined = -1,
    AATImageFormatJPEG = 0,
    AATImageFormatPNG,
    AATImageFormatGIF,
    AATImageFormatTIFF,
    AATImageFormatWebP
};

@interface NSData (ImageContentType)

/**
 *  Return image format
 *
 *  @param data the input image data
 *
 *  @return the image format as `AATImageFormat` (enum)
 */
+ (AATImageFormat)aat_imageFormatForImageData:(nullable NSData *)data;

@end
