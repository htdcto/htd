//
//  RegisterView.m
//  php
//
//  Created by 李东旭 on 16/3/10.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import "RegisterView.h"
#import "Define.h"

@interface RegisterView () <UIImagePickerControllerDelegate>

@end
@implementation RegisterView

#pragma mark - property
- (UIButton *)backButton
{
    if (_backButton == nil) {
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.backgroundColor = [UIColor grayColor];
        [_backButton setTitle:@"<" forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:25.0f * screenH];
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(70 * screenH);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(30 * screenW);
            make.height.mas_equalTo(50 * screenH);
        }];
    }
    
    return _backButton;
}

- (UITextField *)nameTextF
{
    if (_nameTextF == nil) {
        self.nameTextF = [self textFieldFatory:_nameTextF name:@"请输入用户名"];
        [_nameTextF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(70 * screenH);
            make.left.mas_equalTo(40 * screenW);
            make.right.mas_equalTo(self).offset(-40 * screenW);
            make.height.mas_equalTo(50 * screenH);
        }];
    }
    return _nameTextF;
}

- (UITextField *)passTextF
{
    if (_passTextF == nil) {
        
        self.passTextF = [self textFieldFatory:_passTextF name:@"请输入密码"];
        _passTextF.secureTextEntry = YES;
        [_passTextF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameTextF.mas_bottom).offset(20);
            make.centerX.equalTo(self.nameTextF.mas_centerX);
            make.width.equalTo(self.nameTextF.mas_width);
            make.height.equalTo(self.nameTextF.mas_height);
        }];
    }
    
    return _passTextF;
}





- (UIButton *)registerButton
{
    if (_registerButton == nil) {
        self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_registerButton];
        _registerButton.backgroundColor = colorRGBA(8, 122, 252, 0.5);
        _registerButton.layer.cornerRadius = 15;
        [_registerButton setTitle:@"注  册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
        [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passTextF.mas_bottom).offset(30 * screenH);
            make.centerX.equalTo(self.passTextF.mas_centerX);
            make.height.equalTo(self.passTextF.mas_height);
            make.width.equalTo(self.passTextF.mas_width);
        }];
    }
    
    return _registerButton;
}
- (UIButton *)headerImageButton
{
    if (_headerImageButton == nil) {
        self.headerImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerImageButton setImage:[UIImage imageNamed:@"headerimage.png"] forState:UIControlStateNormal];
        [_headerImageButton addTarget:self action:@selector(selectUserImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_headerImageButton];
        [_headerImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.registerButton.mas_bottom).offset(60 * screenH);
            make.left.mas_equalTo(150 * screenW);
            make.right.mas_equalTo(self).offset(-150 * screenW);
            make.bottom.equalTo(self).offset(-270 * screenH);
        }];
    }
    
    return _headerImageButton;
    
}
- (UIButton *)manChoose
{
    if (_manChoose == nil) {
        self.manChoose = [UIButton buttonWithType:UIButtonTypeCustom];
        [_manChoose setImage:[UIImage imageNamed:@"Man.png"] forState:UIControlStateNormal];
        [_manChoose addTarget:self action:@selector(setMan) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_manChoose];
        [_manChoose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.registerButton.mas_bottom).offset(60 * screenH);
            make.left.mas_equalTo(29 * screenW);
            make.right.equalTo(self.headerImageButton.mas_left).offset(-29 * screenW);
            make.bottom.equalTo(self).offset(-60 * screenH);
        }];
    }
    
    return _manChoose;
}

- (UIButton *)womanChoose
{
    if (_womanChoose == nil) {
        _womanChoose = [UIButton buttonWithType:UIButtonTypeCustom];
        [_womanChoose setImage:[UIImage imageNamed:@"WoMan.png"] forState:UIControlStateNormal];
        [_womanChoose addTarget:self action:@selector(setWoman) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_womanChoose];
        [_womanChoose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.registerButton.mas_bottom).offset(60 * screenH);
            make.left.equalTo(self.headerImageButton.mas_right).offset(29 * screenW);
            make.right.mas_equalTo(-29 * screenW);
            make.bottom.equalTo(self).offset(-60 * screenH);
        }];
    }
    
    return _womanChoose;
}

// 因为本页面textField都差不多, 把公共代码提取出来
- (UITextField *)textFieldFatory:(UITextField *)textField name:(NSString *)placeholder
{
    textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.backgroundColor = colorRGBA(244, 244, 244, 1);
   // textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 15;
    textField.returnKeyType = UIReturnKeyNext;
    [self addSubview:textField];
    return textField;
}

-(void)setWoman
{
    self.sex = @"0";
    _womanChoose.selected = YES;
    _manChoose.selected = NO;
}

-(void)setMan
{
    self.sex = @"1";
    _womanChoose.selected = NO;
    _manChoose.selected = YES;
}

#pragma mark - init
- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = colorRGBA(255, 255, 255, 1);
        
        // 初始化控件
        [self backButton];
        [self headerImageButton];
        [self manChoose];
        [self womanChoose];
        
    }
    
    return self;
}

#pragma mark - buttonAction
- (void)selectUserImage
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // 从图库来源
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    UIViewController *theViewController = [self theViewController];
    [theViewController presentViewController:picker animated:YES completion:nil];
}

- (void)backButtonAction
{
    // 清空注册登录控件里的数据(防止没注册传递回去)
    self.nameTextF.text = @"";
    self.passTextF.text = @"";
    [UIView animateWithDuration:1.0 animations:^{
        self.frame = CGRectMake(-375, 0, 0, 667);
        // 延迟2秒删除, 不然没有渐变消失的动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        });
    }];

}

#pragma mark - imagepickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{

    [picker dismissViewControllerAnimated:YES completion:^{
        
        // 获取图片数据
        UIImage *ima = info[UIImagePickerControllerEditedImage];
        
        
        //压缩
        if (ima) {
            ima = info[UIImagePickerControllerOriginalImage];
        }
        UIGraphicsBeginImageContext(CGSizeMake(120, 120));
        [ima drawInRect:CGRectMake(0, 0, 120, 120)];
        _smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *headerPath = [cachePath stringByAppendingPathComponent:@"headerImage"];
        NSData *headerData = UIImageJPEGRepresentation(_smallImage, 1.0);
        [headerData writeToFile:headerPath atomically:YES];
        // 给button按钮改变图片
        [self.headerImageButton setImage:_smallImage forState:UIControlStateNormal];
    }];
}

- (void)registerAction
{
    UIViewController *selfVC = [self theViewController];
    // 判断注册页面控件里是否都有值
    if ([_nameTextF.text isEqualToString:@""] || [_passTextF.text isEqualToString:@""]) {
        [selfVC showTheAlertView:selfVC andAfterDissmiss:1.5 title:@"请输入帐号或密码" message:@""];
        return;
    }
    
    if (self.smallImage == nil) {
        [selfVC showTheAlertView:selfVC andAfterDissmiss:1.5 title:@"请上传头像" message:@""];
        return;
    }
    
    if(self.sex == nil)
    {
        [selfVC showTheAlertView:selfVC andAfterDissmiss:1.5 title:@"请选择性别" message:@""];
        return;
    }
    
    // 返回注册的信息
    if ([self.delegate respondsToSelector:@selector(clickedRegisterView:name:pwd:sex:image:)]) {
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *headerPath = [cachePath stringByAppendingPathComponent:@"headerImage"];
        UIImage *headerImage = [UIImage imageWithContentsOfFile:headerPath];
        [self.delegate clickedRegisterView:self name:_nameTextF.text pwd:_passTextF.text sex:self.sex image:headerImage];
    }
}



@end
