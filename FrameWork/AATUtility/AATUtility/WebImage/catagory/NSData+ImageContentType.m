/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Fabrice Aneche
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "NSData+ImageContentType.h"


@implementation NSData (ImageContentType)

+ (AATImageFormat)aat_imageFormatForImageData:(nullable NSData *)data {
    if (!data) {
        return AATImageFormatUndefined;
    }
    
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return AATImageFormatJPEG;
        case 0x89:
            return AATImageFormatPNG;
        case 0x47:
            return AATImageFormatGIF;
        case 0x49:
        case 0x4D:
            return AATImageFormatTIFF;
        case 0x52:
            // R as RIFF for WEBP
            if (data.length < 12) {
                return AATImageFormatUndefined;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return AATImageFormatWebP;
            }
    }
    return AATImageFormatUndefined;
}

@end
