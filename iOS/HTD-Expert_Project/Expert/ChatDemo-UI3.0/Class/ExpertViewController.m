//
//  ExpertController.m
//  ChatDemo-UI3.0
//
//  Created by htd on 16/9/7.
//  Copyright © 2016年 htd. All rights reserved.
//

#import "ExpertViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define Url @"http://120.26.62.17/ta/ta/Expertinformation.php?Id=2&Utel=23"


@interface ExpertViewController ()

@property(nonatomic,strong)UIWebView *expertView;

@end

@implementation ExpertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWebView];
    // Do any additional setup after loading the view.
}

-(void)createWebView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.expertView = [[UIWebView alloc]initWithFrame:CGRectMake(0, +64,WIDTH, HEIGHT)];
    self.expertView.scrollView.bounces = NO;
    NSURL *url = [NSURL URLWithString:Url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.expertView loadRequest:request];
    [self.view addSubview:self.expertView];
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
