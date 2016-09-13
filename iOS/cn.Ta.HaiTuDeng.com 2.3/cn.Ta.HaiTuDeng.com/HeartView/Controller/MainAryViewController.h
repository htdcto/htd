//
//  MainAryViewController.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/7/20.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"
#import "MainViewController.h"
#import "Message.h"
//首页
@interface MainAryViewController : UIViewController



@property BOOL isActive;
@property NSInteger messageCount;

//请求数据
-(void)loadData;
-(void)setBackImage;
-(void)updateHeartMessage;
@end
