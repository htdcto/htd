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
#import "RegisterView.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()<LoginRegisterDelegate,RigsterViewDelegate>
@property (nonatomic,strong)LoginView * longinR;
@property (nonatomic,strong)RegisterView *regist;
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
    __weak typeof(self) weakSelf = self;
    [LDXNetWork GetThePHPWithURL:address(@"/login.php") par:dic success:^(id responseObject) {

        NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
        if ([responseObject[@"success"]isEqualToString:@"1"]) {
                //没有绑定，服务器没有返回Tt
            
            [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"name"];
            [[NSUserDefaults standardUserDefaults]setObject:pass forKey:@"password"];
            if([responseObject[@"Ttel"] isEqualToString:@"-1"]){
                
                _bdViewController =[[BDViewController alloc]init];
                _bdViewController.bindSuccess = ^{
                    [weakSelf Login:name pass:pass];
                };
                UINavigationController *nav = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
                [nav pushViewController:_bdViewController animated:YES];
                _alreadyBind = NO;
                success(NO);
                }
                
                else
                {
                    NSString *Ttel = responseObject[@"Ttel"];
                    NSString *BdTimeString = responseObject[@"BdTime"];
                    NSString *Expert = responseObject[@"expert"];
                    
                    NSThread *thread = [NSThread currentThread];
                    BOOL s = [thread isMainThread];
                    NSLog(@"---------------------------%d",s);
                    

                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:Ttel forKey:@"Ttel"];
                    
                    NSTimeZone *timeZone=[NSTimeZone timeZoneWithName:@"UTC"];
                    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
                    [formatter setDateFormat:@"YYYY-MM-dd"];
                    [formatter setTimeZone:timeZone];
                    NSDate *BdTime = [formatter dateFromString:BdTimeString];

                    [userDefaults setObject:BdTime forKey:@"BdTime"];
                    [userDefaults setObject:Expert forKey:@"expert"];
                    NSLog(@".............%@",BdTime);
                    
                    _alreadyBind = YES;
                    
                    //自有帐号登录友盟
                    [MobClick profileSignInWithPUID:name];
                    
                    //操作本地数据库
                    DB *db = [DB shareInit];
                    [db createDBPath];
                    [db openOrCreateDB];
                    [db updateDBAfterLoginSuccess:name response:^{
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"loadData" object:nil];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"loadChartView" object:nil];
                    }];
                    success(YES);
                }
            }
            else{
                success(NO);
                [self showTheAlertView:self andAfterDissmiss:1.0 title:(NSLocalizedString(@"账号或密码错误", @"uncorrect account or password")) message:@""];
            }
        } error:^(NSError *error) {
            success(NO);
        [self showTheAlertView:self andAfterDissmiss:2.0 title:(NSLocalizedString(@"连接服务器失败", @"Connect to the server failed!")) message:@""];
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
                    [self showTheAlertView:self andAfterDissmiss:1.0 title:(NSLocalizedString(@"账号或密码错误", @"uncorrect account or password")) message:@""];
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

    [self showHudInView:self.view hint:NSLocalizedString(@"正在登录", @"Is Login...")];

    //异步登录帐号
    __weak typeof (self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger loginIM;
        loginIM = [weakself getLoginIM:name pass:pass];
        switch (loginIM) {
            case(1):
            {
                [weakself getLoginServer:name pass:pass success:^(BOOL success) {
                    if (success) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINCHANGE object:@YES];
                    }
                }];
            }
                break;
        }
        [weakself hideHud];
    });
 }


-(void)clickedRegisterView:(RegisterView *)registerView name:(NSString *)name pwd:(NSString *)pwd sex:(NSString *)sex image:(UIImage *)image
{
    NSDictionary *dic = @{@"Utel":name,@"Upass":pwd,@"Sex":sex};
    [LDXNetWork PostThePHPWithURL:address(@"/register.php") par:dic image:image uploadName:@"headerimageFile" success:^(id response) {
        
        NSString *headerPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"headerImage"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:headerPath]) {
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:headerPath error:&error];
            if (error) {
                NSLog(@"%s-----%@",__func__,error);
            }
        }
        NSString *success = response[@"success"];
        
        if ([success isEqualToString:@"1"]) {
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"注册成功" message:@""];
            [self.regist removeFromSuperview];
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
#pragma mark - LoginViewDelegate

- (void)goRegisterView{

    self.regist = [[RegisterView alloc] initWithFrame:CGRectMake(0, screenNowH, self.view.frame.size.width, self.view.frame.size.height)];
    self.regist.delegate = self;
    // 注册页面注册按钮点击方法
    
    // 注册页面其实是盖在登录页面上的
    [self.longinR addSubview:_regist];
    [UIView animateWithDuration:1.0 animations:^{
        _regist.frame = self.view.frame;
    }];
}

@end
