//
//  NSDictionary+Description.m
//  Pods-Utility_Example
//
//  Created by chdo on 2017/12/15.
//

#import "NSDictionary+Description.h"

@implementation NSDictionary (Description)
- (NSString *)descriptionWithLocale
{
    
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"{\n"];
    
    for (id obj in [self allKeys]) {
        if (obj) {
            [strM appendFormat:@"\t\t%@,", obj];
            if (self[obj]) {
                [strM appendFormat:@"%@\n", self[obj]];
            } else {
                [strM appendString:@"为拿到对应value"];
            }
        }
    }
    
    [strM appendString:@"}"];
    
    return strM;
}

@end
