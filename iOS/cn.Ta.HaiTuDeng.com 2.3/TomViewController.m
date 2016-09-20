//
//  MEViewController.m
//  SwipeGestureRecognizer
//
//  Created by piupiupiu on 16/7/14.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "TomViewController.h"
#import "InformationViewController.h"
#import "StatusViewController.h"
#import "MainAryViewController.h"
#import "LoginViewController.h"
#import "EMError.h"
#import "EMSDK.h"
#import "OutsideViewController.h"
#import "DB.h"

@interface TomViewController ()<EMChatManagerDelegate>

@property (strong, nonatomic) UIView *footerView;


@end

@implementation TomViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isActive = YES;
    //友盟页面统计
    [MobClick beginLogPageView:@"个人页面"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isActive = NO;
    //结束友盟页面统计
    [MobClick endLogPageView:@"个人页面"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Tom 办公室", @"Tom Office");
    self.view.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = self.footerView;
}


- (void)tuchu {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[EMClient sharedClient] isLoggedIn]) {
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (error != nil){
            NSLog(@"退出错误的原因:%@",error);
            [self showTheAlertView:self andAfterDissmiss:2.0 title:(NSLocalizedString(@"退出失败，请检查网络", @"logout failed")) message:@""];
            return;
        }else{
            //移除UserDefaults中存储的用户信息
            [userDefaults removeObjectForKey:@"name"];
            [userDefaults removeObjectForKey:@"password"];
            [userDefaults removeObjectForKey:@"Ttel"];
            [userDefaults removeObjectForKey:@"BDTime"];
            [userDefaults removeObjectForKey:@"expert"];
            [userDefaults synchronize];
            DB *db = [DB shareInit];
            [db closeDB];
            
            //登出友盟
            [MobClick profileSignOff];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINCHANGE object:@NO];
        }
    }
}

#pragma mark - Table view datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    } else {
        [cell.contentView.subviews enumerateObjectsUsingBlock:^(UIView * subView, NSUInteger idx, BOOL *stop) {
            [subView removeFromSuperview];
        }];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"约见达人", @"automatic login");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = NSLocalizedString(@"礼品盒子", @"Apns Settings");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 3)
        {
            cell.textLabel.text = NSLocalizedString(@"个人推荐", @"Black List");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 4)
        {
            cell.textLabel.text = NSLocalizedString(@"情感走势", @"Debug");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - getter

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
        _footerView.backgroundColor = [UIColor clearColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, _footerView.frame.size.width - 10, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_footerView addSubview:line];
        
        UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, _footerView.frame.size.width - 20, 45)];
        [logoutButton setBackgroundColor:RGBACOLOR(0xfe, 0x64, 0x50, 1)];
        NSString *username = [[EMClient sharedClient] currentUsername];
        NSString *logoutButtonTitle = [[NSString alloc] initWithFormat:NSLocalizedString(@"和Tom解约(%@)", @"和Tom解约(%@)"), username];
        [logoutButton setTitle:logoutButtonTitle forState:UIControlStateNormal];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(tuchu) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:logoutButton];
    }
    
    return _footerView;
}
- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == EMConversationTypeChat) {
        model.title = nil;
        model.avatarURLPath = nil;
    }
    return model;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        NSString *Expert = [[NSUserDefaults standardUserDefaults]objectForKey:@"expert"];
        EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:Expert type:EMConversationTypeChat createIfNotExist:YES];;
        if (conversation) {
            
            ChatViewController *chatController = [[ChatViewController alloc]
                                                  initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
            chatController.title = nil;
            [self.navigationController pushViewController:chatController animated:YES];
        }
    }
    if (indexPath.row ==2) {
        OutsideViewController *outsideController = [[OutsideViewController alloc]init];
        [self.navigationController pushViewController:outsideController animated:YES];
    }
    
    
}
- (void)didRemovedFromServer
{
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
