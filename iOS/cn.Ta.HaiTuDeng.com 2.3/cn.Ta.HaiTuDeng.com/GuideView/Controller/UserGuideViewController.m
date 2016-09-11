//
//  UserGuideViewController.m
//  logDemo
//
//  Created by piupiupiu on 16/6/19.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

//引导页
#import "UserGuideViewController.h"
#import "LoginViewController.h"
@implementation UserGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    [self initGuide];   //加载新用户指导页面
}

- (void)initGuide
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width*4, 0)];
    [scrollView setPagingEnabled:YES];  //视图整页显示
   // [scrollView setBounces:NO]; //避免弹跳效果,避免把根视图露出来
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview setImage:[UIImage imageNamed:@"back.jpg"]];
    [scrollView addSubview:imageview];
    [imageview release];
    
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview1 setImage:[UIImage imageNamed:@"1.png"]];
    [scrollView addSubview:imageview1];
    [imageview1 release];
    
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width *2, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview2 setImage:[UIImage imageNamed:@"2.png"]];
    [scrollView addSubview:imageview2];
    [imageview2 release];
    
    
    UIImageView *imageview3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width *3, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview3 setImage:[UIImage imageNamed:@"3.png"]];
    imageview3.userInteractionEnabled = YES;    //打开imageview3的用户交互;否则下面的button无法响应
    [scrollView addSubview:imageview3];
    [imageview3 release];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//在imageview3上加载一个透明的button
    [button setTitle:nil forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    [button setFrame:CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height-50, 100, 50)];
    [button addTarget:self action:@selector(firstpressed) forControlEvents:UIControlEventTouchUpInside];
    [imageview3 addSubview:button];
    
    [self.view addSubview:scrollView];
    
}
- (void)firstpressed
 {
     LoginViewController *VC= [[LoginViewController alloc]init];
    [self presentViewController:VC animated:YES completion:nil]; //点击button跳转到根视图
}
@end
