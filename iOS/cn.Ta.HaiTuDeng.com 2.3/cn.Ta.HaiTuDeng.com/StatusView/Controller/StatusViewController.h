//
//  StatusViewController.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/7/20.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *BJImage;


@property BOOL isActive;
@property BOOL statusUpadate;
@property BOOL needBackImage;
-(void)backImageDown:(void(^)(void))needBack;
-(void)setPieChartView;
-(void)backImage;
@end
