//
//  MainViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/15.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "MainViewController.h"
#import "MainAryViewController.h"
#import "Helper.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface MainViewController ()
{
    MainAryViewController *_maVC;
    StatusViewController *_statusVC;
    InformationViewController *_informationVC;
    TomViewController *_meVC;
    
    
}




@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMavcUnread) name:@"setMavcUnread" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setStatusUpdate) name:@"setStatusUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setExpertUnread) name:@"setExpertUnread" object:nil];
    self.title = NSLocalizedString(@"首页", @"Main");
    [self setSubview];
    self.selectedIndex = 0;
    
    [self setExpertUnread];
    
    [self createConversation];
    
    _maVC.messageCount = mavcCount + [[NSUserDefaults standardUserDefaults]integerForKey:@"messageCountLastTime"];
    mavcCount=0;
    [self setMavcUnread];
    
    _statusVC.statusUpadate = updateStatus || [[NSUserDefaults standardUserDefaults]boolForKey:@"statusUpdateLastTime"];
    updateStatus = NO;
    [self setStatusUpdate];

    
    [Helper shareHelper].mavc = _maVC;
    [Helper shareHelper].svc = _statusVC;
    [Helper shareHelper].meVC = _meVC;
    
    
    
    // Do any additional setup after loading the view.
    
}
- (void)viewWillLayoutSubviews{
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = 40;
    tabFrame.origin.y = self.view.frame.size.height - 40;
    self.tabBar.frame = tabFrame;
    
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 0) {
        self.title = NSLocalizedString(@"首页", @"Main");
        self.navigationItem.rightBarButtonItem = nil;
    }else if (item.tag == 1){
        self.title = NSLocalizedString(@"更新状态", @"Status");
        self.navigationItem.rightBarButtonItem =nil;
    }else if (item.tag == 2){
        self.title = NSLocalizedString(@"情侣资讯", @"Information");
        self.navigationItem.rightBarButtonItem = nil;
    }else if(item.tag == 3){
        self.title = NSLocalizedString(@"Tom 办公室", @"Tom Office");
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

-(void)setSubview
{
    
    _maVC = [[MainAryViewController alloc]initWithNibName:nil bundle:nil];
    _maVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"首页",@"Main") image:nil tag:0];
    UIOffset hight = UIOffsetMake(0, -10);
    [_maVC.tabBarItem setTitlePositionAdjustment:hight];
      [self unSelectedTapTabBarItems:_maVC.tabBarItem];
    [self selectedTapTabBarItems:_maVC.tabBarItem];
    
    _statusVC = [[StatusViewController alloc]initWithNibName:nil bundle:nil];
    _statusVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"更新状态", @"Status") image:nil tag:1];
    UIOffset hight1 = UIOffsetMake(0, -10);
    [_statusVC.tabBarItem setTitlePositionAdjustment:hight1];
    [self unSelectedTapTabBarItems:_statusVC.tabBarItem];
    [self selectedTapTabBarItems:_statusVC.tabBarItem];
    
    _informationVC = [[InformationViewController alloc]initWithNibName:nil bundle:nil];
    _informationVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"情侣资讯",@"Information") image:nil tag:2];
    UIOffset hight2 = UIOffsetMake(0, -10);
    [_informationVC.tabBarItem setTitlePositionAdjustment:hight2];
    [_informationVC.tabBarItem setBadgeValue:nil];
    [self unSelectedTapTabBarItems:_informationVC.tabBarItem];
    [self selectedTapTabBarItems:_informationVC.tabBarItem];
    
    _meVC = [[TomViewController alloc]initWithNibName:nil bundle:nil];
    _meVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:NSLocalizedString(@"Tom 办公室",@"Tom Office") image:nil tag:3];
    UIOffset hight3 = UIOffsetMake(0, -10);
    [_meVC.tabBarItem setTitlePositionAdjustment:hight3];
    [_meVC.tabBarItem setBadgeValue:nil];
    [self unSelectedTapTabBarItems:_meVC.tabBarItem];
    [self selectedTapTabBarItems:_meVC.tabBarItem];
    
    self.viewControllers = @[_maVC,_statusVC,_informationVC,_meVC];
    [self selectedTapTabBarItems:_maVC.tabBarItem];
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14],
                                        NSFontAttributeName,RGBACOLOR(0x00, 0xac, 0xff, 1),NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateSelected];
}

-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14], NSFontAttributeName,[UIColor grayColor],NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
}

//登录主见面后创建一个与另一伴的会话
-(void)createConversation
{
    NSString *another = [[NSUserDefaults standardUserDefaults]objectForKey:@"Ttel"];
    [[EMClient sharedClient].chatManager getConversation:another type:EMConversationTypeChat createIfNotExist:YES];
}


//统计未读消息
-(void)setMavcUnread
{
    if ( _maVC.messageCount== 0) {
        [_maVC.tabBarItem setBadgeValue:nil];
    }else{
        [_maVC.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%i",(int)_maVC.messageCount]];
    }
    [self setApplicationUnread];
}

-(void)setStatusUpdate
{
    if (!_statusVC.statusUpadate) {
        [_statusVC.tabBarItem setBadgeValue:nil];
    }else{
        [_statusVC.tabBarItem setBadgeValue:@"!"];
        _statusVC.needBackImage = YES;
    }
    [self setApplicationUnread];

}

-(void)setExpertUnread
{
    NSString *Expert = [[NSUserDefaults standardUserDefaults]objectForKey:@"expert"];
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:Expert type:EMConversationTypeChat createIfNotExist:NO];
    _meVC.messageCount = conversation.unreadMessagesCount;
    if(_meVC){
        if (_meVC.messageCount > 0) {
            [_meVC.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%i",(int)_meVC.messageCount]];
        }else{
            [_meVC.tabBarItem setBadgeValue:nil];
        }
    }
    [self setApplicationUnread];
}

-(void)setApplicationUnread
{
    NSInteger unreadCount = _maVC.messageCount+_meVC.messageCount+_statusVC.statusUpadate;
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playSoundAndVibration{
        NSTimeInterval timeInterval = [[NSDate date]
                                       timeIntervalSinceDate:self.lastPlaySoundDate];
        if (timeInterval < kDefaultPlaySoundInterval) {
            //如果距离上次响铃和震动时间太短, 则跳过响铃
            NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
            return;
        }
        
        //保存最后一次响铃时间
        self.lastPlaySoundDate = [NSDate date];
        
        // 收到消息时，播放音频
        [[EMCDDeviceManager sharedInstance] playNewMessageSound];
        // 收到消息时，震动
        [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient]pushOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.fireDate = [NSDate date];//触发通知的时间
    if(options.displayStyle == EMPushDisplayStyleMessageSummary){
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
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
