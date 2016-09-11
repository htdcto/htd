//
//  LoginRegisterView.m
//  php
//
//  Created by 李东旭 on 16/3/9.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import "LoginView.h"
#import "Define.h"
#import "EMSDK.h"
#import "EMError.h"

@interface LoginView ()<EMClientDelegate>

@property (nonatomic, strong) UIImageView *nameImageV;
@property (nonatomic, strong) UIImageView *passImageV;

@property (nonatomic, strong) UIView *nameDown;
@property (nonatomic, strong) UIView *passDown;

// 盖在背景图片上的一层灰色的view
@property (nonatomic, strong) UIView *effectView;
@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) RegisterView *regist;

@end

@implementation LoginView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - 懒加载初始化控件
/*
- (UIImageView *)backImageView
{
    if (_backImageView == nil) {
        self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back.jpg"]];
        _backImageView.frame = self.frame;
        self.effectView  = [[UIView alloc] initWithFrame:self.frame];
        _effectView.backgroundColor = colorRGBA(229, 229, 299, 0.7);
        [self addSubview:_backImageView];
        [self addSubview:_effectView];
        
        return _backImageView;
    }
    
    return _backImageView;
}
*/

- (UIView *)nameDown
{
    if (_nameDown == nil) {
        self.nameDown = [[UIView alloc] init];
        [self addSubview:_nameDown];
        _nameDown.layer.cornerRadius = 15.0f;
        _nameDown.backgroundColor = colorRGBA(244, 244, 244, 1);
        [_nameDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40 * screenW);
            make.top.mas_equalTo(150 * screenH);
            make.right.equalTo(self).offset(-40 * screenW);
            make.height.mas_equalTo(50 * screenH);
        }];
        
        return _nameDown;
    }
    
    return _nameDown;
}


- (UIImageView *)nameImageV
{
    if (_nameImageV == nil) {
        _nameImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login.png"]];
        [self.nameDown addSubview:_nameImageV];
        [_nameImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(30 * screenW);
            make.height.mas_equalTo(30 * screenH);
        }];
        
        return _nameImageV;
    }
    
    return _nameImageV;
}


- (UITextField *)nameTextF
{
    if (_nameTextF == nil) {
        self.nameTextF = [[UITextField alloc] init];
        _nameTextF.placeholder = @"请输入用户名";
        [self.nameDown addSubview:_nameTextF];
        [_nameTextF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameImageV.mas_centerY);
            make.height.equalTo(_nameImageV.mas_height);
            make.left.equalTo(_nameImageV.mas_right).offset(20);
            make.right.equalTo(_nameDown).offset(-40);
        }];
        
        return _nameTextF;
    }
    
    return _nameTextF;
}

- (UIView *)passDown
{
    if (_passDown == nil) {
        self.passDown = [[UIView alloc] init];
        [self addSubview:_passDown];
        _passDown.layer.cornerRadius = 15.0f;
        _passDown.backgroundColor = colorRGBA(244, 244, 244, 1);
        [_passDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameDown.mas_bottom).offset(30);
            make.centerX.equalTo(_nameDown.mas_centerX);
            make.width.equalTo(_nameDown.mas_width);
            make.height.equalTo(_nameDown.mas_height);
        }];
        
        return _passDown;
    }
    
    return _passDown;
}


- (UIImageView *)passImageV
{
    if (_passImageV == nil) {
        self.passImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pass.png"]];
        [self.passDown addSubview:_passImageV];
        [_passImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(30 * screenW);
            make.height.mas_equalTo(30 * screenH);
        }];
        return _passImageV;
    }
    
    return _passImageV;
}


- (UITextField *)passWordF
{
    if (_passWordF == nil) {
        self.passWordF = [[UITextField alloc] init];
        _passWordF.placeholder = @"请输入密码";
        _passWordF.secureTextEntry = YES;
        [self.passDown addSubview:_passWordF];
        [_passWordF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.passImageV.mas_centerY);
            make.height.equalTo(_passImageV.mas_height);
            make.left.equalTo(_passImageV.mas_right).offset(20);
            make.right.equalTo(_passDown).offset(-40);
        }];
        
        return _passWordF;
    }
    
    return _passWordF;
}

- (UIButton *)loginButton
{
    if (_loginButton == nil) {
        self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.cornerRadius = 15;
        _loginButton.backgroundColor = colorRGBA(8, 122, 252, 0.5);
        [_loginButton setTitle:@"登  录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loginButton];
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passDown.mas_bottom).offset(50 * screenH);
            make.left.mas_equalTo(50 * screenW);
            make.right.equalTo(self).offset(-50);
            make.height.mas_equalTo(50 * screenH);
        }];
        
        return _loginButton;
    }
    
    return _loginButton;
}

- (UIButton *)registerButton
{
    if (_registerButton == nil) {
        self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setTitle:@"注  册" forState:UIControlStateNormal];
        _registerButton.layer.masksToBounds = YES;
        _registerButton.layer.cornerRadius = 15;
        _registerButton.backgroundColor = colorRGBA(8, 122, 252, 0.5);
        [_registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_registerButton];
        [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginButton.mas_bottom).offset(30);
            make.left.mas_equalTo(50 * screenW);
            make.right.equalTo(self).offset(-50);
            make.height.mas_equalTo(50 * screenH);
        }];
        
        return _registerButton;
    }
    
    return _registerButton;
}
/*
- (void)setBackImage:(UIImage *)backImage
{
    [self.backImageView setImage:backImage];
}
*/
#pragma mark - init方法
// 防止外部调用init方法不走我们初始化控件
- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 添加背景图片
       // [self backImageView];
       [self addNotification];
      
        // 初始化各控件
        [self nameTextF];
        [self passWordF];
        [self registerButton];

    }
    
    return self;
}

// 注册键盘通知
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - UIKeyBoardNotification

- (void)keyboardWillShow
{
    // 键盘弹出时, 顶部控件向上移动(不要被键盘挡住)
    [_nameDown mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(40 * screenW);
        make.top.mas_equalTo(70 * screenH);
        make.right.equalTo(self).offset(-40 * screenW);
        make.height.mas_equalTo(50 * screenH);
        
    }];
}

- (void)keyboardWillHide
{
    // 更新约束 (让控件下移, 恢复原来位置)
    [_nameDown mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(40 * screenW);
        make.top.mas_equalTo(150 * screenH);
        make.right.equalTo(self).offset(-40 * screenW);
        make.height.mas_equalTo(50 * screenH);
        
    }];
}

#pragma mark - touch Began

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 结束当前页面编辑状态
    [self endEditing:YES];
}

#pragma mark - registerbuttonAction
- (void)registerButtonAction:(UIButton *)sender
{
    self.regist = [[RegisterView alloc] initWithFrame:CGRectMake(0, screenNowH, self.frame.size.width, self.frame.size.height)];
    
    // 注册页面注册按钮点击方法
    [_regist.registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 注册页面其实是盖在登录页面上的
    [self addSubview:_regist];
    [UIView animateWithDuration:1.0 animations:^{
        _regist.frame = self.frame;
    }];
}


#pragma mark - ButtonAction
- (void)loginButtonAction
{
    // 判断登录页面的控件里有没有值
    if ([_nameTextF.text isEqualToString:@""] || [_passWordF.text isEqualToString:@""]) {
        
        UIViewController *vc = [self theViewController];
        [vc showTheAlertView:vc andAfterDissmiss:1.5 title:@"请输入用户名密码" message:@""];
        
        return;
    }
    // 给外部调用的地方, 利用代理协议把登录信息传递到viewController代理人那里
    [self.delegate Login:_nameTextF.text pass:_passWordF.text];
    
}


- (void)registerAction
{
    // 判断注册页面控件里是否都有值
    if ([_regist.nameTextF.text isEqualToString:@""] || [_regist.passTextF.text isEqualToString:@""] ) {
        UIViewController *theVC = [self theViewController];
        [theVC showTheAlertView:theVC andAfterDissmiss:1.5 title:@"请输入帐号或密码" message:@""];
        return;
    }
    
    // 返回注册的信息
    [self.delegate getRegisterName:_regist.nameTextF.text pass:_regist.passTextF.text image:self.regist.headerImageButton.imageView.image];
}

// 返回到登录页面
- (void)goToLoginView
{
    // 返回值到登录页面
    self.nameTextF.text = self.regist.nameTextF.text;
    self.passWordF.text = self.regist.passTextF.text;
    [self.regist removeFromSuperview];
}



@end
