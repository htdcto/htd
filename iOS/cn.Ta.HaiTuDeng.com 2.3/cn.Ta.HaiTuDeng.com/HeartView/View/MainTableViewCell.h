//
//  MainTableViewCell.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/7/21.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MainTableViewCell : UITableViewCell

//-(void)loadDataFromModel:(HearModel *)model;

@property (strong, nonatomic) IBOutlet UILabel *Time_Label;
@property (strong, nonatomic) IBOutlet UIImageView *Time_Image;

@end
