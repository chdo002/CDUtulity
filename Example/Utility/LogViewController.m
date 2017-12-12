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
    NSError *err = CRMSendLog(@[@"1107661983@qq.com"], nil);
    if (err) {
         [AATHUD showInfo:err.domain andDismissAfter:0.6];
        if (err.code == -1) {
            // 没有日志
        }
        if (err.code == -2) {
            // 没有邮箱账号
            [CRMLogManger openSettings];
        }
    }
}
- (IBAction)log:(id)sender {
    
    NSMutableString *strg = [NSMutableString string];
    for (int i = 0; i < 10; i++) {
        int num = (int)arc4random() % 15;
        [strg appendFormat:@"%d",num];
    }
    CRMLog(strg);
}
- (IBAction)local:(id)sender {
    CRMLogLocallize();
}
@end
