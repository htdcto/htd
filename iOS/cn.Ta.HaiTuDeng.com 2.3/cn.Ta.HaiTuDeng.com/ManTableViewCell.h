//
//  ManTableViewCell.h
//  FlowersMan
//
//  Created by 屠夫 on 16/3/10.
//  Copyright (c) 2016年 Soul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"
@interface ManTableViewCell : UITableViewCell
-(void)loadDataFromModel:(MainModel *)model;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *biaoLable;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *neiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signe;

@end
