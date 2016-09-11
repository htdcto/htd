//
//  BDViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/4.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "BDViewController.h"
#import "Constant.h"

@interface BDViewController ()
@property (nonatomic,strong)NSString * Uname;
@property (nonatomic,strong)NSUserDefaults *userDefaults;
@end
@implementation BDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Ta.regist", @"login");
    _userDefaults = [NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = [UIColor whiteColor];
    [self checkInformationFromIM];


    // Do any additional setup after loading the view from its nib.
}

-(void)checkInformationFromIM
{
    if(extern_name !=nil && extern_alert !=nil)
    {
        [self addFriendNotice:extern_name alert:extern_alert];
        extern_name = nil;
        extern_alert = nil;
    }
    if(extern_agreename != nil)
    {
        [self didReceiveAgreeFromFriendNotice:extern_agreename];
        extern_agreename = nil;
    }
    if(extern_declinename != nil)
    {
        [self didReceiveDeclineFromFriendNotice:extern_declinename];
        extern_declinename = nil;
    }
    
}

//登录本地服务器检测待绑定帐号是否注册，如果注册是否已经被绑定，如果没有被绑定则向IM框架发送添加好友通知。
//注意：此时没有加入客户端本地校验不能跟自己绑定。
- (IBAction)SQBtn:(id)sender {

    _Uname = [_userDefaults objectForKey:@"name"];
    NSString *Ttel = _BDTextField.text;
    NSLog(@"%@,%@",_Uname,Ttel);
    NSDictionary *dic = @{@"Ttel":Ttel};
    if(_Uname == Ttel)
    {
        [self showTheAlertView:self andAfterDissmiss:1.0 title:@"不能和自己绑定" message:@""];
    }
    else{

      //[LDXNetWork GetThePHPWithURL:LOGIN par:dic success:^(id responseObject)
       [LDXNetWork GetThePHPWithURL:address(@"/bindcheck.php") par:dic success:^(id responseObject) {
           NSString *i = [responseObject objectForKey:@"success"];
           int a = [i intValue];
           switch (a) {
               case (1):
                   [self addFriend:Ttel];
                   NSLog(@"2222");
                   break;
               case (0):
               {[self showTheAlertView:self andAfterDissmiss:1.0 title:@"对方未注册" message:@""];
               }
                   break;
               case (-1):
               {
                   [self showTheAlertView:self andAfterDissmiss:1.0 title:@"对方已绑定" message:@""];
               }
           }
           
       }error:^(NSError *error) {
           
       }];
    }
    
}

-(void)addFriend:(NSString *)Ttel
{
    NSString *Ttel1 = Ttel;
    EMError *error = [[EMClient sharedClient].contactManager addContact:Ttel1 message:@""];
    if (!error) {
        [self showTheAlertView:self andAfterDissmiss:1.0 title:@"申请发送成功，等待对方回复" message:@""];
    }
}


- (IBAction)QHBtn:(id)sender {
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"退出成功");
    }
    //移除UserDefaults中存储的用户信息
    [_userDefaults removeObjectForKey:@"name"];
    [_userDefaults removeObjectForKey:@"password"];
    [_userDefaults removeObjectForKey:@"Ttel"];
    [_userDefaults synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma callback Notice
//得到回调函数代理的值（对的名字）生成弹出框
-(void)addFriendNotice:(NSString *)name alert:(NSString *)alertMessage
{
    NSString *Tname = name;

    NSLog(@"%@弹出提示框",name);
    //绑定提示框
    _alertController = [UIAlertController alertControllerWithTitle:alertMessage message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //添加确定按钮
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self agreeFriendInvitationFrom:Tname];
    }];
    [_alertController addAction:yesAction];
    
    
    
    //添加拒绝按钮
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self declineFriendInvitationFrom:Tname];
    }];
    [_alertController addAction:noAction];
    [self presentViewController:_alertController animated:YES completion:nil];
}

-(void)didReceiveAgreeFromFriendNotice:(NSString *)name
{
    NSString *Ttel = name;
    NSString *alertTitle = @"已同意与您绑定！";
    NSString *alert = [Ttel stringByAppendingString:alertTitle];
    [self showTheAlertView:self andAfterDissmiss:2.0 title:alert message:@""];
    //绑定的时间
    NSDate *date = [NSDate date];
    [_userDefaults setObject:date forKey:@"BDTime"];
    
    [_userDefaults setObject:Ttel forKey:@"Ttel"];
    
    NSString *Utel = [_userDefaults objectForKey:@"name"];
    NSDictionary *dic = @{@"Utel":Utel,@"Ttel":Ttel};
    [LDXNetWork GetThePHPWithURL:address(@"/bind.php") par:dic success:^(id responseObject) {
        if([responseObject[@"success"]isEqualToString:@"1"])
        {
            NSString *Expert = responseObject[@"expert"];
            [_userDefaults setObject:Expert forKey:@"expert"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGINCHANGE object:@YES];
        
        }
        else
        {
            [self showTheAlertView:self andAfterDissmiss:1.0 title:@"绑定失败" message:@""];

        
        }
    }error:^(NSError *error) {
        [self showTheAlertView:self andAfterDissmiss:1.0 title:@"网络错误" message:@""];
    }];
}
-(void)agreeFriendInvitationFrom:(NSString *)name
{
    NSString *Ttel = name;
    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:name];
    if (!error) {
    [self showTheAlertView:self andAfterDissmiss:1.0 title:@"同意成功" message:@""];
        [_userDefaults setObject:Ttel forKey:@"Ttel"];
        //绑定的时间
        NSDate *date = [NSDate date];
        [_userDefaults setObject:date forKey:@"BDTime"];

        NSString *Utel = [_userDefaults objectForKey:@"name"];
        NSDictionary *dic = @{@"Utel":Utel,@"Ttel":Ttel};
        [LDXNetWork GetThePHPWithURL:address(@"/bind.php") par:dic success:^(id responseObject) {
            if([responseObject[@"success"]isEqualToString:@"1"])
            {
               [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGINCHANGE object:@YES];
                
            }
            else
            {
                [self showTheAlertView:self andAfterDissmiss:1.0 title:@"绑定失败" message:@""];
                
                
            }
        }error:^(NSError *error) {
            [self showTheAlertView:self andAfterDissmiss:1.0 title:@"网络错误" message:@""];
        }];
        
    }
    else{
    [self showTheAlertView:self andAfterDissmiss:1.0 title:@"操作失败，请稍候重试" message:@""];
    }
}

-(void)didReceiveDeclineFromFriendNotice:(NSString *)name
{
    NSString *alerTitle = @"已经拒绝您的绑定申请！";
    NSString *alert = [name stringByAppendingString:alerTitle];
    [self showTheAlertView:self andAfterDissmiss:2.0 title:alert message:@""];
    
}

-(void)declineFriendInvitationFrom:(NSString *)name
{
    EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:name];
    if (!error) {
        [self showTheAlertView:self andAfterDissmiss:1.0 title:@"拒绝成功" message:@""];
    }
    else
    {
        [self showTheAlertView:self andAfterDissmiss:1.0 title:@"操作失败，请稍候重试" message:@""];
    }
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
