//
//  RegisterView.h
//  php
//
//  Created by 李东旭 on 16/3/10.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIView

@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UITextField *nameTextF;
@property (nonatomic, strong) UITextField *passTextF;



// 返回按钮
@property (nonatomic, strong) UIButton *backButton;

// 用户头像
@property (nonatomic, strong) UIButton *headerImageButton;

//性别选择
@property (nonatomic, strong) UIButton *manChoose;
@property (nonatomic, strong) UIButton *womanChoose;

@end
