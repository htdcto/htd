//
//  MainViewController.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/15.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITabBarController

-(void)setMavcUnread;
-(void)setStatusUpdate;
-(void)setExpertUnread;

- (void)playSoundAndVibration;
- (void)showNotificationWithMessage:(EMMessage *)message;
@end
