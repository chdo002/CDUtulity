/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "NSImage+WebCache.h"

#if AAT_MAC

@implementation NSImage (WebCache)

- (CGImageRef)aat_CGImage {
    NSRect imageRect = NSMakeRect(0, 0, self.size.width, self.size.height);
    CGImageRef cgImage = [self CGImageForProposedRect:&imageRect context:NULL hints:nil];
    return cgImage;
}

- (NSArray<NSImage *> *)aat_images {
    return nil;
}

- (BOOL)aat_isGIF {
    return NO;
}

@end

#endif

