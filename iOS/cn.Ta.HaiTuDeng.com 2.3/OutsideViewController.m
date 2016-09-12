//
//  OutsideViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/9/7.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "OutsideViewController.h"
#import "RankViewController.h"
#import "cn.Ta.HaiTuDeng.com-Bridging-Header.h"
#import "Charts.h"
@interface OutsideViewController ()
@property (strong,nonatomic) RankViewController *rvc;

@property (nonatomic,strong) PieChartView *ourPieChartView;
@property (nonatomic,strong) BubbleChartView *ourBubbleChartView;
@property (nonatomic,strong) PieChartView *otherPieChartView;
@property (nonatomic,strong) BubbleChartView *otherBubbleChartView;


@property (nonatomic,strong)ChartView *cv;
@end

@implementation OutsideViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.rvc = [[RankViewController alloc]init];
    self.rvc.view.frame  = CGRectMake(50, 100,[UIScreen mainScreen].bounds.size.width, 200);
    self.cv = [[ChartView alloc]init];
    [self.view addSubview:self.rvc.view];
    [self drawourPieChart];
    [self drawOurBubbleChart];
    [self drawOtherPieChart];
    [self drawOtherBubbleChart];
}

-(void)drawourPieChart
{
    if(_ourPieChartView)
    {
        [_ourPieChartView removeFromSuperview];
    }
    
    NSNumber *Ucount = [NSNumber numberWithInteger:5];
    NSNumber *Tcount = [NSNumber numberWithInteger:10];
    NSArray *dataSource = [[NSArray alloc]initWithObjects:Ucount,Tcount,nil];
    self.ourPieChartView = [self.cv drawPieChart:dataSource];
    
    [self.view addSubview:(self.ourPieChartView)];
    [self.ourPieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150,150));
        make.top.equalTo(self.rvc.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
    }];

}

-(void)drawOurBubbleChart
{
    NSString *u = @"5";
    NSString *t = @"10";
    NSArray *U = [[NSArray alloc]initWithObjects:u, nil];
    NSArray *T = [[NSArray alloc]initWithObjects:t, nil];
    NSArray *dataSource = [[NSArray alloc]initWithObjects:U,T ,nil];
    
    
    self.ourBubbleChartView.backgroundColor = [[UIColor alloc] colorWithAlphaComponent:0];
    self.ourBubbleChartView = [self.cv drawBubbleChart:dataSource];
    [self.view addSubview:(self.ourBubbleChartView)];
    [self.ourBubbleChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo((CGSizeMake(150, 150)));
        make.top.equalTo(self.ourPieChartView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
    }];
}

-(void)drawOtherPieChart;
{
    if(_otherPieChartView)
    {
        [_otherPieChartView removeFromSuperview];
    }
    
    NSNumber *Ucount = [NSNumber numberWithInteger:5];
    NSNumber *Tcount = [NSNumber numberWithInteger:10];
    NSArray *dataSource = [[NSArray alloc]initWithObjects:Ucount,Tcount,nil];
    self.otherPieChartView = [self.cv drawPieChart:dataSource];
    
    [self.view addSubview:(self.otherPieChartView)];
    [self.otherPieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150,150));
        make.top.equalTo(self.rvc.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];

}

-(void)drawOtherBubbleChart
{
    NSString *u = @"5";
    NSString *t = @"10";
    NSArray *U = [[NSArray alloc]initWithObjects:u, nil];
    NSArray *T = [[NSArray alloc]initWithObjects:t, nil];
    NSArray *dataSource = [[NSArray alloc]initWithObjects:U,T ,nil];
    
    
    self.otherBubbleChartView.backgroundColor = [[UIColor alloc] colorWithAlphaComponent:0];
    self.otherBubbleChartView = [self.cv drawBubbleChart:dataSource];
    [self.view addSubview:(self.otherBubbleChartView)];
    [self.otherBubbleChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo((CGSizeMake(150, 150)));
        make.top.equalTo(self.otherPieChartView.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
}
@end
