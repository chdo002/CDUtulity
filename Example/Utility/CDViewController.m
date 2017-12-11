//
//  CDViewController.m
//  Utility
//
//  Created by chdo002 on 12/08/2017.
//  Copyright (c) 2017 chdo002. All rights reserved.
//

#import "CDViewController.h"
#import <Utility/Utility.h>

@interface CDViewController ()
{
    NSString *path;
}
@end

@implementation CDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"123.png"];
    NSData *data = UIImagePNGRepresentation([self.view snapShot]);
    [data writeToFile:path atomically:YES];
}


- (IBAction)show:(UIButton *)sender {
    
    [AATHUD showInfo:@"121231212312123121231212312123" showLoading:YES];
}

- (IBAction)loading:(id)sender {
    [AATHUD showLoading];
}
- (IBAction)noloadingInfo:(id)sender {
    [AATHUD showInfo:@"safsdfsfsfsadf搜爱家佛is金佛山第我吉安师范"];
}

- (IBAction)dismiss:(id)sender {
    [AATHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

@end
