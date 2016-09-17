//
//  Constant.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/25.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "Constant.h"

@implementation Constant

//点心后的通知对方的cmd命令
NSString *const UpdateLocalDBAndServer = @"UpdateLocalDBAndServer";

//更改背景图片后的cmd命令
NSString *const UpdateBackImage = @"UpdateBackImage";

//更改状态图片后的cmd命令
NSString *const UpdateStatusImage = @"UpdateStatusImage";



//登录时寄存环信监听代理回调的数据
//得到好友请求的名字和提示
NSString *extern_name = nil;
NSString *extern_alert = nil;

//得到好友同意的名字
NSString *extern_agreename = nil;

//得到好友拒绝的名字
NSString *extern_declinename = nil;

BOOL alreadyBind = NO;

NSInteger mavcCount = 0;

BOOL updateStatus = NO;


@end
