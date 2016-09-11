//
//  OutsideViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/9/7.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "OutsideViewController.h"
#import "RankViewController.h"
@interface OutsideViewController ()
@property (strong,nonatomic) RankViewController *rvc;


@end

@implementation OutsideViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.rvc = [[RankViewController alloc]init];
    self.rvc.view.frame  = CGRectMake(50, 100, 200, 400);
    [self.view addSubview:self.rvc.view];
}


@end
