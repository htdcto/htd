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
@property (nonatomic,strong) PieChartView *otherSelectedPieChartView;
@property (nonatomic,strong) BubbleChartView *otherSelectedBubbleChartView;
@property (nonatomic,strong) NSArray *rankArr;
@property (nonatomic,strong) NSDictionary *ourDic;
@property (nonatomic,strong) NSDictionary *otherSelectedDic;



@property (nonatomic,strong)ChartView *cv;
@end

@implementation OutsideViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.rvc = [[RankViewController alloc]init];
    self.rvc.ovc = self;
    self.rvc.view.frame  = CGRectMake(50, 100,[UIScreen mainScreen].bounds.size.width, 200);
    self.cv = [[ChartView alloc]init];
    [self.view addSubview:self.rvc.view];
    
    [self getDataSource:^{

        [self drawourPieChart];
        [self drawOurBubbleChart];
    }];

    //[self drawOtherPieChart];
    //[self drawOtherBubbleChart];
}

-(void)getDataSource:(void(^)(void))reponse
{
    [LDXNetWork GetThePHPWithURL:address(@"/rank.php") par:nil success:^(id responseObject) {
            if ([responseObject[@"success"]isEqualToString:@"1"]) {
                _rankArr = responseObject[@"rank"];
                self.rvc.rank = _rankArr;
                [self.rvc.tableView reloadData];
                
                NSString *Uname = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
                //判断数组中那一个字典是自己伴侣的数据，返回给ovc.
                for (NSDictionary *dic in _rankArr) {
                    if (Uname == dic[@"Mtel"] || Uname == dic[@"Wtel"]) {
                        _ourDic = dic;
                    }
                }
                
                reponse();
            }
            else
            {
                NSLog(@"服务器数据库错误");
            }
        }error:^(NSError *error) {
            NSLog(@"访问服务器错误");
    }];
    
}

-(void)drawourPieChart
{
    NSString *Mcount = _ourDic[@"Mstatus"];
    NSString *Wcount = _ourDic[@"Wstatus"];
    NSArray *dataSource = [[NSArray alloc]initWithObjects:Mcount,Wcount,nil];
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
    NSString *m = _ourDic[@"Mheart"];
    NSString *w = _ourDic[@"Wheart"];
    NSArray *M = [[NSArray alloc]initWithObjects:m, nil];
    NSArray *W = [[NSArray alloc]initWithObjects:w, nil];
    NSArray *dataSource = [[NSArray alloc]initWithObjects:M,W ,nil];
    
    
    self.ourBubbleChartView.backgroundColor = [[UIColor alloc] colorWithAlphaComponent:0];
    self.ourBubbleChartView = [self.cv drawBubbleChart:dataSource];
    [self.view addSubview:(self.ourBubbleChartView)];
    [self.ourBubbleChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo((CGSizeMake(150, 150)));
        make.top.equalTo(self.ourPieChartView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
    }];
}

-(void)drawOtherPieChart:(NSInteger)index
{
    if(_otherSelectedPieChartView)
    {
        [_otherSelectedPieChartView removeFromSuperview];
    }
    
    NSDictionary *otherDic = _rankArr[index];
    NSString *Mcount = otherDic[@"Mstatus"];
    NSString *Wcount = otherDic[@"Wstatus"];
    NSArray *dataSource = [[NSArray alloc]initWithObjects:Mcount,Wcount,nil];
    self.otherSelectedPieChartView = [self.cv drawPieChart:dataSource];
    
    [self.view addSubview:(self.otherSelectedPieChartView)];
    [self.otherSelectedPieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150,150));
        make.top.equalTo(self.rvc.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];

}

-(void)drawOtherBubbleChart:(NSInteger)index
{
    if(_otherSelectedBubbleChartView)
    {
        [_otherSelectedBubbleChartView removeFromSuperview];
    }
    NSDictionary *otherDic = _rankArr[index];
    NSString *m = otherDic[@"Mheart"];
    NSString *w = otherDic[@"Wheart"];
    NSArray *M = [[NSArray alloc]initWithObjects:m, nil];
    NSArray *W = [[NSArray alloc]initWithObjects:w, nil];
    NSArray *dataSource = [[NSArray alloc]initWithObjects:M,W ,nil];
    
    
    self.otherSelectedBubbleChartView.backgroundColor = [[UIColor alloc] colorWithAlphaComponent:0];
    self.otherSelectedBubbleChartView = [self.cv drawBubbleChart:dataSource];
    [self.view addSubview:(self.otherSelectedBubbleChartView)];
    [self.otherSelectedBubbleChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo((CGSizeMake(150, 150)));
        make.top.equalTo(self.otherSelectedPieChartView.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
}
@end
