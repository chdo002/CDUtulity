//
//  NSArray+Description.m
//  Pods-Utility_Example
//
//  Created by chdo on 2017/12/15.
//

#import "NSArray+Description.h"

@implementation NSArray (Description)
- (NSString *)descriptionWithLocale
{
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"(\n"];
    for (id obj in self) {
        if (obj) {
            [strM appendFormat:@"\t\t%@,\n", obj];
        }
    }
    [strM appendString:@")"];
    
    return strM;
}
@end
