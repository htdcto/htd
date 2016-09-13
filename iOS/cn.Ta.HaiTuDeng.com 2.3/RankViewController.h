//
//  RankViewController.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/9/6.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutsideViewController.h"

@interface RankViewController : UITableViewController

@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *rank;

@property (nonatomic,weak) OutsideViewController *ovc;
@end
