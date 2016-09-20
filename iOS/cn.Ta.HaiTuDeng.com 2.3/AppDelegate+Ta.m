//
//  AppDelegate+Ta.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/15.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "AppDelegate+Ta.h"
#import "LoginViewController.h"
@interface AppDelegate ()
@end
@implementation AppDelegate (Ta)

-(void)taApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
              appkey:(NSString *)appkey
        apnsCertName:(NSString *)apnsCertName
         otherConfig:(NSDictionary *)otherConfig
{
    //登录注册状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:NOTIFICATION_LOGINCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINCHANGE object:@NO];
    [Helper shareHelper];
    [self isAuotoLogin];
}

-(void)isAuotoLogin
{
    self.loginViewController = [[LoginViewController alloc]init];
    //自动登录
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    NSString *pass = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (name && pass) {
        
        [self.loginViewController Login:name pass:pass];
        //存在用户名跟密码，实现自动登录
        
    }
    
}

-(void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    if(loginSuccess){//登录成功加载主窗口控制器
            if(self.mainController == nil){
                self.mainController = [[MainViewController alloc]init];
                self.navigationController = [[UINavigationController alloc]initWithRootViewController:self.mainController];
            }else{
                
                self.navigationController = self.mainController.navigationController;
            }
            [Helper shareHelper].mainVC = self.mainController;
        }
    else{//登录失败加载登录页面控制器
        if(self.mainController){
            [self.mainController.navigationController popToRootViewControllerAnimated:NO];
        }
        self.mainController = nil;
        [Helper shareHelper].mainVC = self.mainController;
        self.loginViewController = [[LoginViewController alloc]init];
        self.navigationController = [[UINavigationController alloc]initWithRootViewController:self.loginViewController];
    }
    [self.window setRootViewController:self.navigationController];
}





@end
