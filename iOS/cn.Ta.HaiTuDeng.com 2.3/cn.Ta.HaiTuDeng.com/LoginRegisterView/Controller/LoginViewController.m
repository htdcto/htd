//
//  ViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/7/20.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "LoginViewController.h"
#import "EMSDK.h"
#import "EMError.h"
#import "DB.h"
#import "MainViewController.h"
#import "Constant.h"
#import "Helper.h"

@interface LoginViewController ()<LoginRegisterDelegate>
@property (nonatomic,strong)LoginView * longinR;
@property BOOL alreadyBind;
@property (strong,nonatomic) BDViewController *bdViewController;
@end

@implementation LoginViewController

//由于自动登录IM服务器无法调用本地回调函数didAutoLoginWithError()，所以无法验证自动登录是否成功。因此统一假设自动登录成功，并直接访问本地服务器登录。----------------------------------------xzl
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"Ta.login", @"login");
    self.longinR = [[LoginView alloc]initWithFrame:self.view.frame];
    self.longinR.delegate = self;
    [self.view addSubview:self.longinR];
    [Helper shareHelper].bdVC = _bdViewController;

}
#pragma mark - 登录注册页面的代理
//根据不同的后台给的字段 代表的意思 以及值进行不同处理.
//如果IM框架返回1成功登录，则调用该方法做服务器端登录。若IM框架返回0，则不执行服务器端登录，直接向客户端返回登录失败。
//----------------------------------------xzl

-(void)getLoginServer:(NSString *)name pass:(NSString *)pass success:(void(^)(BOOL success))success
{            //后台规定登录用户名的字段必须是name 密码是pass,
            //本地服务器网络请求
        NSDictionary *dic = @{@"Utel":name,@"pass":pass};
    
    NSThread *thread = [NSThread currentThread];
    BOOL s = [thread isMainThread];
    NSLog(@"----==================-----------------%d",s);

    [LDXNetWork GetThePHPWithURL:address(@"/login.php") par:dic success:^(id responseObject) {

        
        if ([responseObject[@"success"]isEqualToString:@"1"]) {
                //没有绑定，服务器没有返回Tt
            if([responseObject[@"Ttel"] isEqualToString:@"-1"]){
               
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:name forKey:@"name"];
                [userDefaults setObject:pass forKey:@"password"];
                _bdViewController =[[BDViewController alloc]init];
                UINavigationController *nav = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
                [nav pushViewController:_bdViewController animated:YES];
                _alreadyBind = NO;
                success(NO);
                }
                
                else
                {
                    NSString *Ttel = responseObject[@"Ttel"];
                    NSString *BdTime = responseObject[@"BdTime"];
                    NSString *Expert = responseObject[@"expert"];
                    
                    NSThread *thread = [NSThread currentThread];
                    BOOL s = [thread isMainThread];
                    NSLog(@"---------------------------%d",s);
                    

                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:name forKey:@"name"];
                    [userDefaults setObject:pass forKey:@"password"];
                    [userDefaults setObject:Ttel forKey:@"Ttel"];
                    [userDefaults setObject:BdTime forKey:@"BdTime"];
                    [userDefaults setObject:Expert forKey:@"expert"];
                    NSLog(@".............%@",BdTime);
                    
                    _alreadyBind = YES;
                    
                    //自有帐号登录友盟
                    [MobClick profileSignInWithPUID:name];
                    
                    //操作本地数据库
                    DB *db = [DB shareInit];
                    [db openOrCreateDB];
                    [db updateDBAfterLoginSuccess:name response:^{
                        JustLogin = NO;
                    }];
                    success(YES);

                }

            }
            else{
                success(NO);
                [self showTheAlertView:self andAfterDissmiss:1.0 title:@"账号或密码错误" message:@""];
            }
        } error:^(NSError *error) {
            success(NO);
#if DEBUG
        [self showTheAlertView:self andAfterDissmiss:2.0 title:@"无服务器连接" message:@""];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINCHANGE object:@YES];

#else
        [self showTheAlertView:self andAfterDissmiss:2.0 title:@"服务器故障，请稍候再试" message:@""];
#endif
            
        }];
}

//登录IM框架，如果成功返回1，如果失败返回0----------------------------------------xzl
-(NSInteger)getLoginIM:(NSString *)name pass:(NSString *)pass
{
    NSInteger status = -1;//0表示帐号密码错误，1表示正确登录，－1表示网络连接错误。
    
        EMError *error = [[EMClient sharedClient] loginWithUsername:name password:pass];
        if(!error)
        {

            [[EMClient sharedClient].options setIsAutoLogin:NO];
        status = 1;
        }
        else
        {
            switch (error.code)
            {
                case EMErrorNetworkUnavailable:
                    [self showTheAlertView:self andAfterDissmiss:1.0 title:(NSLocalizedString(@"网络连接失败,请检查网络", @"No network connection!")) message:@""];
                    break;
                case EMErrorServerNotReachable:
                    [self showTheAlertView:self andAfterDissmiss:1.0 title:(NSLocalizedString(@"连接服务器失败", @"Connect to the server failed!")) message:@""];
                    break;
                case EMErrorUserAuthenticationFailed:
                    [self showTheAlertView:self andAfterDissmiss:1.0 title:(error.errorDescription) message:@""];
                    break;
                case EMErrorServerTimeout:
                    [self showTheAlertView:self andAfterDissmiss:1.0 title:(NSLocalizedString(@"连接超时", @"Connect to the server timed out!")) message:@""];
                    break;
                default:
                    [self showTheAlertView:self andAfterDissmiss:1.0 title:(NSLocalizedString(@"登录失败", @"Login failure")) message:@""];
                    status = 0;
                    break;

            }
        }
                return status;
}


//先检测IM框架是否登录，如果登录成功返回1作服务器端登录，否则返回0报错。----------------------------------xzl
-(void)Login:(NSString *)name pass:(NSString *)pass
{

    if ([name isEqualToString:@""] || [pass isEqualToString:@""]) {
        
        [self showTheAlertView:self andAfterDissmiss:1.0 title:@"请输入帐号跟密码" message:@""];
        return;
    }
    NSInteger loginIM;
    loginIM = [self getLoginIM:name pass:pass];
    switch (loginIM) {
        case(1):
        {
            [self getLoginServer:name pass:pass success:^(BOOL success) {
                if (success) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINCHANGE object:@YES];
    
                    }
            }];
        }
            break;
        case (-1):
        {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINCHANGE object:@YES];
        }
    }
}



-(void)getRegisterName:(NSString *)name pass:(NSString *)pass image:(UIImage *)image
{
    
    NSDictionary *dic = @{@"Utel":name,@"Upass":pass};
    [LDXNetWork PostThePHPWithURL:address(@"/register.php") par:dic image:image uploadName:@"headerimageFile" success:^(id response) {
        NSString *success = response[@"success"];
        
        if ([success isEqualToString:@"1"]) {
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"注册成功" message:@""];
            [self.longinR goToLoginView];
        }
        else if([success isEqualToString:@"-1"]){
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"账号已经被注册" message:@""];
        }
        else
        {
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"注册失败" message:@""];
        }
        
    } error:^(NSError *error) {
        NSLog(@"错误的原因:%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
