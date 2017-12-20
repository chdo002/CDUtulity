/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "AATWebImageCompat.h"

#if AAT_MAC

#import <Cocoa/Cocoa.h>

@interface NSImage (WebCache)

- (CGImageRef)aat_CGImage;
- (NSArray<NSImage *> *)aat_images;
- (BOOL)aat_isGIF;

@end

#endif
