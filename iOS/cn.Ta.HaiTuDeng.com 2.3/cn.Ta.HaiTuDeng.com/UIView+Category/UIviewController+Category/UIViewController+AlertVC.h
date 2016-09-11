//
//  UIViewController+AlertVC.h
//  php
//
//  Created by 李东旭 on 16/3/10.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AlertVC)

// 经过几秒后自动消失的AlertController
- (void)showTheAlertView:(UIViewController *)vc andAfterDissmiss:(NSInteger)time title:(NSString *)title message:(NSString *)message;

@end
