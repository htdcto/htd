//
//  RankViewCell.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/9/7.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *fristImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UILabel *fristName;
@property (weak, nonatomic) IBOutlet UILabel *secondeName;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@end
