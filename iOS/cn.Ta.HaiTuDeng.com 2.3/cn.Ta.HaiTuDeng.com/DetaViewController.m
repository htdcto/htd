//
//  DetaViewController.m
//  FlowersMan
//
//  Created by 屠夫 on 16/3/11.
//  Copyright (c) 2016年 Soul. All rights reserved.
//

#import "DetaViewController.h"
#import "MainModel.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define XINAGQIng @"http://120.26.62.17/ta/ta/showinformation.php?Id=%@&Utel=%@"


@interface DetaViewController ()
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NSString *html;
@end

@implementation DetaViewController

- (void)viewDidLoad {
    

    
  
    [super viewDidLoad];
    [self creaUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"FlowerMan";
    
 
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
}


-(void)creaUI
{
    /*mj
   self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, +64,WIDTH, HEIGHT)];
    NSString *scrollPos = [_webView stringByEvaluatingJavaScriptFromString:@"scrollPos"];
    scrollPos = [scrollPos stringByAppendingString:@" Version/7.0 Safari/9537.53"];
    NSLog(@"cookie   %@",scrollPos);
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"scrollTop":scrollPos}];
     self.webView.scrollView.bounces = NO;
   */
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, +64,WIDTH, HEIGHT)];
    self.webView.scrollView.bounces = NO;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Utel = [userDefaults objectForKey:@"name"];

    NSString *url = [NSString stringWithFormat:XINAGQIng,self.contentid,Utel];
    
    NSURL *Url = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
  
    
    //发送请求给服务器
    [self.webView loadRequest:request];
    
        [self.view addSubview:self.webView];
   

   
    
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
