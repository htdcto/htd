//
//  AppDelegate+UMeng.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/29.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "AppDelegate+UMeng.h"


@implementation AppDelegate (UMeng)

-(void)setupUMeng
{
    
    UMConfigInstance.appKey = @"57c3cf98e0f55a657c003f00";
    //正式上线前需要将渠道更改
    UMConfigInstance.channelId = @"内侧用户";
    [MobClick startWithConfigure:UMConfigInstance];
    
#if DEBUG
    //打开调试模式
    [MobClick setLogEnabled:YES];
#else
    [MobClick setLogEnabled:NO];
#endif
    
    
    
}

@end
