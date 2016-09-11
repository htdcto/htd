//
//  ManTableViewCell.m
//  FlowersMan
//
//  Created by 屠夫 on 16/3/10.
//  Copyright (c) 2016年 Soul. All rights reserved.
//

#import "ManTableViewCell.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@implementation ManTableViewCell
-(void)loadDataFromModel:(MainModel *)model
{
        [self.iconImage setImageWithURL:[NSURL URLWithString:model.Imageurl]placeholderImage:[UIImage imageNamed:@"Snip20160317_2"]];
        // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越
    self.biaoLable.text = model.Title;
    self.timeLabel.text = model.Uptime;
    self.neiLabel.text = model.Introduction;
    
    if ([model.Sign isEqualToString:@"1"]) {
        self.signe.image = [UIImage imageNamed:@"expertInformation"];
    }
    else{
        self.signe.image = nil;
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
