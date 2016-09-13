//
//  RankViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/9/6.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "RankViewController.h"
#import "RankViewCell.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RankViewController ()
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,strong)NSString *Mname;
@property(nonatomic,strong)NSString *Wname;
@property(nonatomic,strong)NSString *Coefficient;

@end

@implementation RankViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"RankViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rank.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RankViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    _dic = _rank[indexPath.row];
    _Mname = [_dic objectForKey:@"Mtel"];
    _Wname = [_dic objectForKey:@"Wtel"];
    _Coefficient = [_dic objectForKey:@"Coefficient"];

    cell.fristName.text = _Mname;
    cell.secondeName.text = _Wname;
    cell.rank.text = _Coefficient;
    cell.fristImage.image = [UIImage imageNamed:@"Man"];
    cell.secondImage.image = [UIImage imageNamed:@"WoMan"];
    
    cell.accessoryType = UITableViewCellSeparatorStyleSingleLine;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.ovc drawOtherPieChart:indexPath.row];
    [self.ovc drawOtherBubbleChart:indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


@end
