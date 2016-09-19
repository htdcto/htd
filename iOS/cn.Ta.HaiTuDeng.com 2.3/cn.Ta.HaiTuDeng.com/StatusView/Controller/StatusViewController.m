//
//  StatusViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by piupiupiu on 16/7/20.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "StatusViewController.h"
#import "Helper.h"
#import "Charts.h"
#import "cn.Ta.HaiTuDeng.com-Bridging-Header.h"
#import "Message.h"
#import "UIImageView+AFNetworking.h"

@interface StatusViewController ()<UIImagePickerControllerDelegate,ShareActionViewDelegate,UINavigationControllerDelegate>
{
}
@property (nonatomic,strong)NSDictionary *Diction;
@property (nonatomic,strong)ShareActionView *actionView;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)Helper *helper;
@property (nonatomic,strong)PieChartView *pieChartView;
@property (nonatomic,strong)ChartView *cv;
@property (nonatomic,strong)UPImageViewController *upvc;
@property  NSInteger Ucount;
@property  NSInteger Tcount;


@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _upvc = [[UPImageViewController alloc]init];
    
    //m
    __weak typeof(self) weakSelf = self;
    _upvc.completion = ^{
        [weakSelf backImageDown:^{
            
        }];
    };
    //
//    _upvc.svc = self;
    self.view.backgroundColor = [UIColor whiteColor];
    _BJImage.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(235/255.0f) blue:(227/255.0f) alpha:0.5];
    _BJImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [_BJImage addGestureRecognizer:singleTap];
    self.cv = [[ChartView alloc]init];

    if(self.needBackImage) {
        [self backImageDown:^{
            [self backImage];
            
        }];
        self.needBackImage = NO;
    }else{
        [self backImageDown:^{}];
    }
}

-(void)setPieChartView
{
    if(_pieChartView)
    {
        [_pieChartView removeFromSuperview];
    }
    
    NSNumber *Ucount = [NSNumber numberWithInteger:_Ucount];
    NSNumber *Tcount = [NSNumber numberWithInteger:_Tcount];
    NSArray *dayCountForAll = [[NSArray alloc]initWithObjects:Ucount,Tcount,nil];
    self.pieChartView = [self.cv drawPieChart:dayCountForAll];

    [self.view addSubview:(self.pieChartView)];
    [self.pieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150,150));
        make.center.mas_equalTo(self.view);
    }];
}


    
    //**************************背景
    //****************我的背景图片********************
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isActive = YES;
    [_BJImage setImage:_image];
    
    if (self.needBackImage) {
        [self backImage];
        self.needBackImage = NO;
    }
    //友盟页面统计
    [MobClick beginLogPageView:@"状态页面"];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isActive = NO;
    self.statusUpadate = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setStatusUpdate" object:nil];
    //结束友盟页面统计
    [MobClick endLogPageView:@"状态页面"];
}

-(void)dealloc
{
    [[NSUserDefaults standardUserDefaults]setBool:self.statusUpadate forKey:@"statusUpdateLastTime"];
}

-(void)backImageDown:(void(^)(void))needBack
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Uname = [userDefaults objectForKey:@"name"];
    NSString *Tname = [userDefaults objectForKey:@"Ttel"];
    NSDictionary *dic = @{@"Utel":Uname,@"Ttel":Tname};
    
        [LDXNetWork GetThePHPWithURL:address(@"/ingimagedown.php") par:dic success:^(id responseObject) {
            
            if ([responseObject[@"success"]isEqualToString:@"1"]) {
                NSString *tel = responseObject[@"Utel"];
                NSString *Time = responseObject[@"Time"];
                NSString *Url = responseObject [@"Url"];
                NSString *Mood = responseObject[@"Mood"] ;
                _Ucount =[responseObject[@"Ucount"] integerValue];
                _Tcount = [responseObject[@"Tcount"] integerValue];
                if(tel !=nil)
                {
                //仅有当两个用户第一次使用，都没有发状态的情况，服务器返回数据除了双方点击次数
                _Diction = @{@"tel":tel,@"Time":Time,@"URL":Url,@"Mood":Mood};
                [self setPieChartView];
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:Url]];
//                _image = [UIImage imageWithData:data];
//                [_BJImage setImage:_image];
                    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:Url]];
                    [_BJImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *  response, UIImage * image) {
                        _image = image;
                        needBack();
                    } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
                    }];
                }
            }
        } error:^(NSError *error) {
            NSLog(@"error");
            
        }];

}
-(void)backImage
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Uname = [userDefaults objectForKey:@"name"];
    NSString *tel = _Diction[@"tel"];
    if(tel != Uname)
    {
    NSString *tel = [_Diction objectForKey:@"tel"];
    NSDictionary *dic = @{@"Ttel":tel};
   [LDXNetWork GetThePHPWithURL:address(@"/ingimagedelete.php") par:dic success:^(id responseObject){
                 if ([responseObject[@"success"]isEqualToString:@"1"]){
                     Message *mes= [[Message alloc]init];
                     [mes createCmdMessage:UpdateStatusImage];
                     //_image = nil;
                 }
             }error:^(NSError *error){
             }];
    }
}
-(void)onClickImage
{
    [self.actionView actionViewShow];
}
- (ShareActionView *)actionView{
    NSString * time = _Diction[@"Time"];
    NSDate * date=[NSDate date];
    long  now = (long)[date timeIntervalSince1970];
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * timeget  =  [formatter dateFromString:time];
    long  gettime = (long)[timeget timeIntervalSince1970];
    long ct =now-gettime-8*60*60;
    NSString * display=[[NSString alloc]init];
    if(ct<60)
    {
        
        NSString * string = [@(ct) stringValue];
        NSString * show=@"秒之前";
        display = [string stringByAppendingString:show];
        
    }else
    {
        if (ct>=60&&ct<60*60) {
            long res=ct/60;
            NSString * string = [@(res) stringValue];
            NSString * show=@"分钟之前";
            display = [string stringByAppendingString:show];
        }
        else
        {
            if (ct>=60*60&&ct<60*60*24) {
                long res=ct/(60*60);
                NSString * string = [@(res) stringValue];
                NSString * show=@"小时之前";
                display = [string stringByAppendingString:show];
                
            }
            else
            {
                if (ct>=60*60*24&&ct<60*60*24*30) {
                    long res=ct/(60*60*24);
                    NSString * string = [@(res) stringValue];
                    NSString * show=@"天之前";
                    display = [string stringByAppendingString:show];
                }
                else
                {
                    if (ct>=60*60*24*30&&ct<60*60*24*365) {
                        long res=ct/(60*60*24*30);
                        NSString * string = [@(res) stringValue];
                        NSString * show=@"个月之前";
                        display = [string stringByAppendingString:show];
                    }
                    else
                    {
                        if (ct>=60*60*24*365) {
                            long res=ct/(60*60*24*365);
                            NSString * string = [@(res) stringValue];
                            NSString * show=@"年之前";
                            display = [string stringByAppendingString:show];
                        }
                    }
                }
            }
        }
    }
    NSString *StrTag = _Diction[@"Mood"];
    NSString *StrImage = [[NSString alloc]init];
    if ([StrTag isEqualToString: @"1"]) {
        StrImage = @"表情1.png";
    }else{
        if ([StrTag isEqualToString: @"2"]) {
            StrImage = @"表情2.png";
        }else{
            if ([StrTag isEqualToString: @"3"]) {
                StrImage = @"表情3.png";
            }else{
                if ([StrTag isEqualToString: @"4"]) {
                    StrImage = @"表情4.png";
                }
            }
        }
        
    }
    
    if (_image == nil)
    {
        if (!_actionView)
        {
            _actionView = [[ShareActionView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-110,[UIScreen mainScreen].bounds.size.width, 0) WithSourceArray:@[@"上传"] WithInconArray:@[@"UP"]];
            _actionView.delegate = self;
        }
    }
    else
    {
        _actionView = [[ShareActionView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height , [UIScreen mainScreen].bounds.size.width, 0) WithSourceArray:@[@"表情",@"上传我的状态",] WithIconArray:@[StrImage,@"UP",] WithIconString:display];
        
        _actionView.delegate = self;
        
    }
    return _actionView;
    
}
- (void)shareToPlatWithIndex:(NSInteger)index{
    NSLog(@"index = %ld",index);
    if (index == 5||index ==1) {
        [self.navigationController showViewController:_upvc sender:nil];
        
        
    }
    else {
        NSLog(@"你点谁呢～！");
    }
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
