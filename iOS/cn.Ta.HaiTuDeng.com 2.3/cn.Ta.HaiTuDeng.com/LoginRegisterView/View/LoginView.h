//
//  LoginRegisterView.h
//  php
//
//  Created by 李东旭 on 16/3/9.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginRegisterDelegate <NSObject>

@optional
// 调用这个代理协议获取登录的用户名, 密码
- (void)Login:(NSString *)name
        pass:(NSString *)pass;

// 调用这个代理协议获取注册用的一些信息
- (void)getRegisterName:(NSString *)name
                   pass:(NSString *)pass
              
                  image:(UIImage *)image;

@end
//创建一个本地数据库的成员变量
@interface LoginView : UIView
@property (nonatomic, strong) UITextField *nameTextF;
@property (nonatomic, strong) UITextField *passWordF;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton * registerButton;

// 登录页面背景图片
@property (nonatomic, strong) UIImage *backImage;

#warning
// 如果要获取登录信息和注册信息, 请签订代理(实现协议方法)
@property (nonatomic, assign) id<LoginRegisterDelegate> delegate;
- (void)goToLoginView;
@end
