//
//  YGRootViewController.m
//  ClearTheMine
//
//  Created by xiangyaguo on 15-6-22.
//  Copyright (c) 2015年 XYG. All rights reserved.
//

#import "YGRootViewController.h"
#import "YGBoardView.h"
@interface YGRootViewController ()

@end

@implementation YGRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    YGBoardView *board = [[YGBoardView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
    [self.view addSubview:board];
}

@end
