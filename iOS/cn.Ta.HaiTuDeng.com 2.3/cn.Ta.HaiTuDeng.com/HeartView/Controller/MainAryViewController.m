//
//  MainAryViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/7/20.
//  Copyright © 2016年 haitudeng. All rights reserved.
//  心界面


#import "MainAryViewController.h"
#import "DB.h"
#import "Helper.h"
#import "Constant.h"
#import "cn.Ta.HaiTuDeng.com-Bridging-Header.h"
#import "Charts.h"

@interface MainAryViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate>

@property (strong,nonatomic) ChartView *chartView;
@property (strong,nonatomic) BubbleChartView *linechart;
@property (nonatomic,strong) BubbleChartView *bubbleChart;
@property (nonatomic,strong) NSString* locationString;
@property (nonatomic,strong) NSString * filepath;//tamax.plist,装对方数据
@property (nonatomic,strong) NSTimer* timer;// 定义倒计时实现定时器
@property (nonatomic,strong) NSDate * date;//当前时间
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *label;//当日点击时间列表
@property (nonatomic,assign) UIModalTransitionStyle UIModalTransitionStyleFlipHorizontal;

@property (strong,nonatomic) NSString *user;
@property (strong,nonatomic) Helper *helper;


@property (nonatomic,strong) NSDate *currentDate;
@property (nonatomic,strong) NSDate *searchingDate;
@property (nonatomic,strong) NSDate *BdTime;
@property (nonatomic,strong) NSDate *currentMonday;
@property (nonatomic,strong) NSDate *currentSunday;
@property (nonatomic,strong) NSDate *searchingMonday;
@property (nonatomic,strong) NSDate *searchingSunday;
@property NSInteger week;




//主视图界面UI
@property (nonatomic,strong) UILabel *CountDown;
@property (nonatomic,strong) UIButton *ClickBtn;
@property (nonatomic,strong) UIImageView *BJimge;
@property (nonatomic,strong) UIButton *imageBtn;
@property (nonatomic,strong) UILabel *TimeLabel;
@property (nonatomic,strong) UIView *TimeView;

@end


int i = 3;//计时器参数
int z =0;

//具体时间key值
@implementation MainAryViewController
static MainAryViewController *mavc;
#pragma mark - LifeCycle


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isActive = YES;
    //友盟页面统计
    [MobClick beginLogPageView:@"首页"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.messageCount = 0;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setMavcUnread" object:nil];
    self.isActive = NO;
    //结束友盟页面统计
    [MobClick endLogPageView:@"首页"];
}

-(void)dealloc
{
    [[NSUserDefaults standardUserDefaults]setInteger:self.messageCount forKey:@"messageCountLastTime"];
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    //允许点击剩余时长获取。
    //    i=20;
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(runTime) userInfo:nil repeats:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];    

    [self buildMainView];
    
    //今天的时间
    NSDate *USDate=[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: USDate];
    self.currentDate = [USDate  dateByAddingTimeInterval: interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSTimeZone *timeZone=[NSTimeZone timeZoneWithName:@"UTC"];
    formatter.timeZone = timeZone;
    NSString *date = [formatter stringFromDate:self.currentDate];
    self.currentDate = [formatter dateFromString:date];
    self.searchingDate = self.currentDate;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _user = [userDefaults objectForKey:@"name"];
    //取出绑定日期
    _BdTime = [userDefaults objectForKey:@"BdTime"];
    
    
    //算出今天周几
    NSCalendar *chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _week = [chineseCalendar component:NSCalendarUnitWeekday fromDate:USDate]-1;
    if(_week==0)
    {_week=7;}
    self.currentMonday = [NSDate dateWithTimeInterval:(_week-1)*(-24*60*60) sinceDate:self.currentDate];
    self.currentSunday = [NSDate dateWithTimeInterval:6*(24*60*60) sinceDate:self.currentMonday];
    
    self.searchingMonday = self.currentMonday;
    self.searchingSunday = self.currentSunday;

    _chartView = [[ChartView alloc]init];
    [self createTableView];
    [self loadChartView];
    [self loadData];
    
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *createPath = [NSString stringWithFormat:@"%@/%@", pathDocuments,_user];
    [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    _filepath = [createPath stringByAppendingPathComponent:@"timeu.plist"];
    NSLog(@"属性列表存放到沙盒的路径：%@",_filepath);
    _date=[NSDate date];
    [self setBackImage];
}

#pragma mark - UI

- (void)buildMainView{

    
    //背景图片
    _BJimge = [[UIImageView alloc]init];
    [self.view addSubview:_BJimge];
    
    //点心
    _ClickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ClickBtn addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _ClickBtn.imageView.image = [UIImage imageNamed:@"XInIcon"];
    [self.view addSubview:_ClickBtn];
    [_ClickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(90);
        make.left.equalTo(self.view.mas_left);
        make.centerY.equalTo(self.view.mas_centerY);
        
    }];
    
    [_BJimge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(_ClickBtn.mas_top).offset(-2);
    }];
    
    //照片
    _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_imageBtn];
    [_imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(90);
        make.right.equalTo(self.view.mas_right);
        make.centerY.equalTo(_ClickBtn.mas_centerY);
    }];
   
    //日期
    _TimeLabel = [[UILabel alloc]init];
    [self.view addSubview:_TimeLabel];
    [_TimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right);
        make.top.equalTo(_imageBtn.mas_bottom).offset(2);
        make.width.mas_equalTo(90);
    }];
    
    //倒计时
    _CountDown = [[UILabel alloc]init];
    [self.view addSubview:_CountDown];
    [_CountDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.equalTo(_ClickBtn.mas_right);
        make.right.equalTo(_imageBtn.mas_left);
        make.centerY.equalTo(_ClickBtn.mas_centerY);
    }];
    
    //点心纪录表父视图
    _TimeView = [[UIView alloc]init];
    [self.view addSubview:_TimeView];
    [_TimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right);
        make.top.equalTo(_TimeLabel.mas_bottom).offset(2);
        make.width.mas_equalTo(90);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
    }];
    MASAttachKeys(_TimeLabel,_imageBtn,_BJimge,_ClickBtn,_TimeView,_CountDown);
}
    //****************我的背景图片********************


-(void)setBackImage{
    NSString *url = [NSString stringWithFormat:@"%@/%@.jpg", address(@"/image/backimage"), _user];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [UIImage imageWithData:data];
    _BJimge.userInteractionEnabled = YES;
    if (image == nil) {
        [_BJimge setImage:[UIImage imageNamed:@"backimage.png"]];
    }
    else{
        [_BJimge setImage:image];
    }
    }

    
     //****************我的背景图片********************

-(void)loadData{
    
    [_tableView removeFromSuperview];
    [_label removeFromSuperview];
    
    DB *db = [DB shareInit];
    [db openOrCreateDB];
   
    NSArray *upTimestamp = [db upTimestamp:self.searchingDate];
    self.dataArray = upTimestamp[1];
    self.dataString = upTimestamp[0];
  
    [self createTableView];
    
}

-(void)loadChartView
{
    [self.linechart removeFromSuperview];
    DB *db = [DB shareInit];
    [db openOrCreateDB];
    NSArray *weekCountForAll =[db caculateTheCountOfTimestampFromServer:self.searchingMonday];
    [self scrollViewUI:weekCountForAll];
}
//----------------------------列表---------------------------------

-(void)createTableView{
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    //PCH 预编译文件
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 95, [UIScreen mainScreen].bounds.size.height - 225, 86,166) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:0.5];
   self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.bounces = YES;
    
    
    _label =[[UILabel alloc]init];
    _label = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 95, [UIScreen mainScreen].bounds.size.height - 243, 86, 18)];
    
    _label.backgroundColor = [UIColor colorWithRed:(200/255.0f) green:(180/255.0f) blue:(180/255.0f) alpha:0.3];
    
  
    NSDateFormatter * formatter1 = [[NSDateFormatter alloc ] init];
    [formatter1 setDateFormat:@"YY年MM月dd日"];
    NSString * dateString =  [formatter1 stringFromDate :_dataString];

    if(self.searchingDate == self.BdTime){
           NSString *text = [@"💕" stringByAppendingFormat:@"%@", dateString];
        _label.text = text;
        
        _label.textColor = [UIColor blackColor  ];
        _label.font = [UIFont boldSystemFontOfSize:10.6f];
            _label.backgroundColor = [UIColor colorWithRed:(200/255.0f) green:(100/255.0f) blue:(80/255.0f) alpha:0.5];
    }else{
        _label.text = dateString;
    _label.textColor = [UIColor redColor];
    _label.font = [UIFont boldSystemFontOfSize:12.3f];}
  
    [self.view addSubview:_label];
    //cell如果不能铺满tableView 是不能滑动的 只能由弹簧效果进行弹动
    [self.view addSubview:_tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"BASE"];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tableSwipe:)];
    //设置轻扫的方向
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft; //默认向右
    [self.tableView addGestureRecognizer:swipeGestureLeft];
    
    UISwipeGestureRecognizer *swipeGestureRinght = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tableSwipe:)];
    //设置轻扫的方向
    swipeGestureRinght.direction = UISwipeGestureRecognizerDirectionRight; //默认向右
    [self.tableView addGestureRecognizer:swipeGestureRinght];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BASE"forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count<=0) {
        return cell;
    }
    
    cell.Time_Label.text = _dataArray[indexPath.row];
    
   
     NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
     [formatter setDateFormat:@"HH:mm:ss"];
    NSDate * q =  [formatter dateFromString: _dataArray[indexPath.row]];
   
    long w = (long)[q timeIntervalSince1970];
    long e=fmod((w+(8*60*60))/21600, 4);
  
    
    if(e==0||e==3)
    {
        cell.backgroundColor = [UIColor colorWithRed:(30/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:0.6];
        cell.Time_Label.textColor = [UIColor whiteColor];
       cell.Time_Label.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.f];
       
      
      
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithRed:(190/255.0f) green:(200/255.0f) blue:(300/255.0f) alpha:0.8];
        cell.Time_Label.textColor = [UIColor blackColor];
        cell.Time_Label.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
    
    }
   
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(void)tableSwipe:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if(self.searchingDate != self.currentDate)
        {
            self.searchingDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:self.searchingDate];
            [self loadData];
            if (self.searchingDate > self.searchingSunday) {
                
                self.searchingMonday = [NSDate dateWithTimeInterval:7*(24*60*60) sinceDate:self.searchingMonday];
                self.searchingSunday = [NSDate dateWithTimeInterval:7*(24*60*60) sinceDate:self.searchingSunday];
                [self loadChartView];
            }
        }
        //向右轻扫
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        
        if(self.searchingDate != self.BdTime)
        {
            self.searchingDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:self.searchingDate];
            [self loadData];
            if (self.searchingDate < self.searchingMonday) {
                
                self.searchingMonday = [NSDate dateWithTimeInterval:7*(-24*60*60) sinceDate:self.searchingMonday];
                self.searchingSunday = [NSDate dateWithTimeInterval:7*(-24*60*60) sinceDate:self.searchingSunday];
                [self loadChartView];
            }
        }
    }
}
//---------------------------列表---------------------------------
//******************设置对方背景图片******************

- (IBAction)imageBtn:(id)sender {
    
    _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // 从图库来源
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate  = self;
   [self presentViewController:picker animated:YES completion:nil];

    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 获取图片数据
    UIImage *ima = info[UIImagePickerControllerEditedImage];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"name"];
    NSDictionary *dic = @{@"Utel":name};
    
    //异步操作
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    [LDXNetWork PostThePHPWithURL:address(@"/backimageup.php") par:dic image:ima uploadName:@"uploadimageFile" success:^(id response) {
        NSString *success = response[@"success"];
        if ([success isEqualToString:@"1"]) {
            Message *mes = [[Message alloc]init];
            [mes createCmdMessage:UpdateBackImage];
        dispatch_async(dispatch_get_main_queue(), ^{
        [self showTheAlertView:self andAfterDissmiss:1.5 title:@"上传成功" message:@""];
        });
        }
        else if([success isEqualToString:@"-1"]){
            dispatch_async(dispatch_get_main_queue(),^{
            [self showTheAlertView:self andAfterDissmiss:1.5 title:@"账号已经被注册了" message:@""];
            });
            
        }
    } error:^(NSError *error) {
        NSLog(@"错误的原因:%@",error);
    }];
    });

    [picker dismissViewControllerAnimated:YES completion:nil];
}
//******************设置对方背景图片******************


- (IBAction)ClickBtn:(id)sender {
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:_filepath];
    NSArray * time = dict[@"time"];
    NSString * ls = [time objectAtIndex:([time count]-1)];
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * sls =  [formatter dateFromString:ls];
    NSDate * objdate = [NSDate dateWithTimeInterval:i sinceDate:sls];
   _date=[NSDate date];
    int key =[ objdate timeIntervalSinceDate:_date];//目标时间和当前时间差
   
    if(key>0)//当前时间小于目标时间
    {
        i=key;
        _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTime) userInfo:nil repeats:YES];//启动计时器
        _ClickBtn.userInteractionEnabled = NO;
        
        
    }
    else//当前时间大于目标时间说明过时了，重新以n值为key计时
    {
        i=3;
        _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTime) userInfo:nil repeats:YES];
        _ClickBtn.userInteractionEnabled = NO;
       // [self timeup];
    }

    //异步并发执行 1:（先访问服务器让服务器插入最新点击时间，得到确认后调用updateHeartMessage方法）2：通过环信向对方发送提醒通知对方执行相同操作。
    
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSDictionary *dic = @{@"Utel":_user};
        [LDXNetWork GetThePHPWithURL:address(@"/timeup.php") par:dic success:^(id responseObject) {
            if ([responseObject[@"success"] isEqualToString:@"1"]) {
                Message *mes = [[Message alloc]init]; // 发送透传消息
                [mes createCmdMessage:UpdateLocalDBAndServer];
                [self updateHeartMessage];
            }
        }error:^(NSError *error)
         {
             NSLog(@"网络故障");
         }];
    });

}



//抓取本地数据库最近时间戳与服务器比较获取最新点心时间并存入数据库。调用block回调等待动作执行完毕后刷新折线图。
-(void)updateHeartMessage
{

            DB *db = [DB shareInit];
            [db openOrCreateDB];
            __weak typeof(self) weakself = self;
            [db updateDBAfterLoginSuccess:_user response:^{
                [weakself loadChartView];
            }];
}


-(void)scrollViewUI:(NSArray *)weekCountForAll
{
    self.linechart.backgroundColor = [[UIColor alloc] colorWithAlphaComponent:0];
    self.linechart = [_chartView drawBubbleChart:weekCountForAll];
    [self.view addSubview:(self.linechart)];
    [self.linechart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo((CGSizeMake(self.view.bounds.size.width-80, 170)));
        make.center.mas_equalTo(CGPointMake(-50, 200));
    }];


    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(ChartSwipe:)];
    //设置轻扫的方向
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft; //默认向右
    [self.linechart addGestureRecognizer:swipeGestureLeft];
    
    UISwipeGestureRecognizer *swipeGestureRinght = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(ChartSwipe:)];
    //设置轻扫的方向
    swipeGestureRinght.direction = UISwipeGestureRecognizerDirectionRight; //默认向右
    [self.linechart addGestureRecognizer:swipeGestureRinght];
}


-(void)ChartSwipe:(id)sender
{
    
    UISwipeGestureRecognizer *swipe = sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        
        if(self.currentDate > self.searchingSunday)
        {
            self.searchingMonday = [NSDate dateWithTimeInterval:7*(24*60*60) sinceDate:self.searchingMonday];
            self.searchingSunday = [NSDate dateWithTimeInterval:7*(24*60*60) sinceDate:self.searchingSunday];
            [self loadChartView];
            self.searchingDate = self.searchingMonday;
            [self loadData];
        }
    }
    
    
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        
        if(self.BdTime < self.searchingMonday)
        {
            self.searchingMonday = [NSDate dateWithTimeInterval:7*(-24*60*60) sinceDate:self.searchingMonday];
            self.searchingSunday = [NSDate dateWithTimeInterval:7*(-24*60*60) sinceDate:self.searchingSunday];
            [self loadChartView];
            self.searchingDate = self.searchingSunday;
            [self loadData];
        }
    }
    
}

//计时器
-(void)runTime
{
    if (i<=0) {
        
        [_timer invalidate];
        _timer = nil;
        _CountDown.text = @"";
        //        [_timer setFireDate:[NSDate distantFuture]];//停止计时器
        _ClickBtn.userInteractionEnabled = YES;//打开按钮
        return;
    }
    NSString *h = [[NSString alloc]init];
    NSString *m = [[NSString alloc]init];
    NSString *s = [[NSString alloc]init];
    i--;
    int hours =i /3600;
    int minutes=fmod(i/60,60);
    int seconds=fmod(i,60);
    if (hours<10)
    {
        NSString * hour=[NSString stringWithFormat:@"%d",hours];
        h = [@"0" stringByAppendingString:hour];
        _CountDown.text = h;
    }
    else
    {
        h=[NSString stringWithFormat:@"%d",hours];
        _CountDown.text = h;
    }
    
    if (minutes<10)
    {
        NSString * minute=[NSString stringWithFormat:@"%d",minutes];
        m = [@"0" stringByAppendingString:minute];
        _CountDown.text = m;
    }
    else
    {
        m=[NSString stringWithFormat:@"%d",minutes];
        _CountDown.text = m;
    }
    if (seconds<10)
    {
        NSString * second=[NSString stringWithFormat:@"%d",seconds];
        s = [@"0" stringByAppendingString:second];
        _CountDown.text = s;
    }
    else
    {
        s=[NSString stringWithFormat:@"%d",seconds];
        _CountDown.text = s;
    }
    NSLog(@"%@",_CountDown.text);
    NSString *labletime=[NSString stringWithFormat:@"%@:%@:%@",h,m,s];
    _CountDown.text = labletime;
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
