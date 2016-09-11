//
//  ViewController.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/7/20.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
-(void)getLoginServer:(NSString *)name pass:(NSString *)pass success:(void(^)(BOOL success))success;
-(void)didReceiveMemoryWarning;
-(NSInteger)getLoginIM:(NSString *)name pass:(NSString *)pass;
-(void)Login:(NSString *)name pass:(NSString *)pass;
@end
