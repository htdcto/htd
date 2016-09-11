//
//  BDViewController.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/4.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDViewController : UIViewController

-(void)addFriendNotice:(NSString *)name alert:(NSString *)alertMessage;
-(void)didReceiveAgreeFromFriendNotice:(NSString *)name;
-(void)didReceiveDeclineFromFriendNotice:(NSString *)name;

@property (weak, nonatomic) IBOutlet UITextField *BDTextField;
@property (nonatomic,strong)UIAlertController *alertController;
@end
