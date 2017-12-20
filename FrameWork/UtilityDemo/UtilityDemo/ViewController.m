//
//  ViewController.m
//  UtilityDemo
//
//  Created by chdo on 2017/12/19.
//  Copyright © 2017年 aat. All rights reserved.
//

#import "ViewController.h"
#import <AATUtility/UIImageView+WebCache.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *one;
@property (weak, nonatomic) IBOutlet UIImageView *two;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.one aat_setImageWithURL:[NSURL URLWithString:@""]];
    
}


-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
