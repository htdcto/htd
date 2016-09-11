//
//  AppDelegate+Ta.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/15.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Ta)
- (void)taApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
               appkey:(NSString *)appkey
         apnsCertName:(NSString *)apnsCertName
          otherConfig:(NSDictionary *)otherConfig;

@end
