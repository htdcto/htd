//
//  Helper.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/4.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BDViewController.h"
//#import "ViewController.h"
#import "ChatViewController.h"

@protocol HelperDelegate <NSObject>
-(void)didReceiveAgreeFromFriendNotice:(NSString *)name;
-(void)didReceiveDeclineFromFriendNotice:(NSString *)name;

@end
@interface Helper : NSObject<EMClientDelegate, EMContactManagerDelegate,EMChatManagerDelegate>
@property (nonatomic, assign) id<HelperDelegate> delegate;


@property (nonatomic,weak) MainAryViewController *mavc;
@property (nonatomic,weak) StatusViewController *svc;
@property (nonatomic, weak) TomViewController *meVC;
@property (nonatomic,weak) BDViewController *bdVC;
@property (nonatomic, weak) MainViewController *mainVC;

+ (instancetype)shareHelper;
@end
