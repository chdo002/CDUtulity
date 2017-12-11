//
//  LogViewController.m
//  Utility_Example
//
//  Created by chdo on 2017/12/11.
//  Copyright © 2017年 chdo002. All rights reserved.
//

#import "LogViewController.h"
#import <Utility/Utility.h>

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)sendLogs:(id)sender {
    [CRMLogObj sendLogFile:@[@"1107661983@qq.com"] CcRecipients:nil];
}
- (IBAction)log:(id)sender {
    
    NSMutableString *strg = [NSMutableString string];
    for (int i = 0; i < 10; i++) {
        int num = (int)arc4random() % 15;
        [strg appendFormat:@"%d",num];
    }
    CRMLog(strg);
    
}
@end
