//
//  RegisterView.h
//  php
//
//  Created by 李东旭 on 16/3/10.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegisterView;

@protocol RigsterViewDelegate <NSObject>

- (void)clickedRegisterView:(RegisterView *)registerView name:(NSString *)name pwd:(NSString *)pwd sex:(NSString *)sex image:(UIImage *)image;

@end

@interface RegisterView : UIView

@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UITextField *nameTextF;
@property (nonatomic, strong) UITextField *passTextF;
@property (nonatomic, strong) UIImage *smallImage;
@property (nonatomic, strong) NSString *sex;

@property (nonatomic, weak) id<RigsterViewDelegate> delegate;


// 返回按钮
@property (nonatomic, strong) UIButton *backButton;

// 用户头像
@property (nonatomic, strong) UIButton *headerImageButton;

//性别选择
@property (nonatomic, strong) UIButton *manChoose;
@property (nonatomic, strong) UIButton *womanChoose;

@end
