//
//  UIViewController+AlertVC.m
//  php
//
//  Created by 李东旭 on 16/3/10.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import "UIViewController+AlertVC.h"

@implementation UIViewController (AlertVC)

- (void)showTheAlertView:(UIViewController *)vc andAfterDissmiss:(NSInteger)time title:(NSString *)title message:(NSString *)message
{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [vc presentViewController:alertC animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertC dismissViewControllerAnimated:YES completion:nil];
            });
        }];

}

@end
