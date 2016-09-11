//
//  ShareActionView.m
//  CheckIn
//
//  Created by kule on 16/1/13.
//  Copyright © 2016年 zhiye. All rights reserved.
//


#import "ShareActionView.h"
#define SHAREBUTTONWIDTH 60

@implementation ShareActionButtonView

- (instancetype)initWithFrame:(CGRect)frame WithImageName:(NSString *)iconImageName WithTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *iconImageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
        iconImageview.image = [UIImage imageNamed:iconImageName];
        [self addSubview:iconImageview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageview.frame) + 5, self.frame.size.width, 15)];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor lightGrayColor];
        [self addSubview:label];
    }
    return self;
}

@end

#import "AppDelegate.h"
@interface ShareActionView ()

@property (nonatomic, strong)UIButton * QQButton;

@end
#define RGBCOLOR(RED,GREEN,BLUE,ALPHA) [UIColor colorWithRed:RED/255.0 green:GREEN/255.0 blue:BLUE/255.0 alpha:ALPHA]

@implementation ShareActionView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame WithSourceArray:(NSArray *)array WithIconArray:(NSArray *)iconArray WithIconString:(NSString *)String
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createShareAcitonViewWithFrame:frame WithSourceArray:array WithIconArray:iconArray WithIconString:String];
    }
    return self;
}
-(void)createShareAcitonViewWithFrame:(CGRect)frame WithSourceArray:(NSArray *)arr WithIconArray:(NSArray *)iconArray WithIconString:(NSString *)String
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    titleLabel.text = String;
    titleLabel.backgroundColor = RGBCOLOR(0, 0, 0,0.01);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    NSInteger count = arr.count;
    NSInteger page = 0;
    page = count/6;
    if ( count%6 != 0) {
        page = page + 1;
    }
    NSInteger row = 1;
    if (count > 3) {
        row = 2;
    }
    CGFloat nH = 30 + 80 *row;
    CGRect nFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, nH);
    //    self.height = 30 + 80 * row;
    self.frame = nFrame;
    UIScrollView *bgScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, self.frame.size.width, self.frame.size.height)];
    bgScrollerView.backgroundColor = RGBCOLOR(0, 0, 0,0.02);
    bgScrollerView.pagingEnabled = YES;
    bgScrollerView.delegate = self;
    bgScrollerView.bounces = NO;
    
    
    bgScrollerView.contentSize = CGSizeMake(self.frame.size.width * page, self.frame.size.height);
    [self addSubview:bgScrollerView];
    
    
    
    float horizeSpace = 0.0f;
    if (count > 3) {
        horizeSpace = (self.frame.size.width - SHAREBUTTONWIDTH *3)/4.0;
    }else
        horizeSpace = (self.frame.size.width - SHAREBUTTONWIDTH *count)/(count + 1);
    float verticalSpace = 10;
    
    for (NSInteger p = 0; p < page; p ++) {
        UIView *multView = [[UIView alloc]initWithFrame:CGRectMake(bgScrollerView.frame.size.width *p, 0, bgScrollerView.frame.size.width, bgScrollerView.frame.size.height)];
        NSLog(@"%@",NSStringFromCGRect(multView.frame));
        multView.backgroundColor = RGBCOLOR(0, 0, 0,0);
        [bgScrollerView addSubview:multView];
        for (NSInteger i = p*6; i < arr.count; i ++) {
            if (i < (p+1)*6) {
                NSInteger column = (i%6)%3;
                NSInteger r = (i%6)/3;
                ShareActionButtonView *buttonView = [[ShareActionButtonView alloc]initWithFrame:CGRectMake(horizeSpace + (horizeSpace + SHAREBUTTONWIDTH)*column, 5+ (verticalSpace + 70)*r, 60, 70) WithImageName:iconArray[i] WithTitle:arr[i]];
                [buttonView addTarget:self action:@selector(shareToMultPlat:) forControlEvents:UIControlEventTouchUpInside];
                buttonView.tag = i;
                NSLog(@"%@",NSStringFromCGRect(buttonView.frame));
                buttonView.backgroundColor = RGBCOLOR(0, 0, 0,0);
                [multView addSubview:buttonView];
                
            }
        }
        
    }
    
}

-(id)initWithFrame:(CGRect)frame WithSourceArray:(NSArray *)array WithInconArray:(NSArray *)inconAray
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createShareAcitonViewWithFrame:frame WithSourceArray:array WithInconArray:inconAray];
    }
    return self;
}
-(void)createShareAcitonViewWithFrame:(CGRect)frame WithSourceArray:(NSArray *)array WithInconArray:(NSArray *)inconAray
{
    
    NSInteger count = array.count;
    NSInteger page = 0;
    page = count/6;
    if ( count%6 != 0) {
        page = page + 1;
    }
    NSInteger row = 1;
    if (count > 3) {
        row = 2;
    }
    CGFloat nH = 30 + 80 *row;
    CGRect nFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, nH);
    //    self.height = 30 + 80 * row;
    self.frame = nFrame;
    UIScrollView *bgScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bgScrollerView.backgroundColor = RGBCOLOR(0, 0, 0,0.5);
    bgScrollerView.pagingEnabled = YES;
    bgScrollerView.delegate = self;
    bgScrollerView.bounces = NO;
    bgScrollerView.contentSize = CGSizeMake(self.frame.size.width * page, self.frame.size.height);
    
    [self addSubview:bgScrollerView];
    
    
    float horizeSpace = 0.0f;
    if (count > 3) {
        horizeSpace = (self.frame.size.width - SHAREBUTTONWIDTH *2)/1.0;
    }
    float verticalSpace = 10;
    
    for (NSInteger p = 0; p < page; p ++) {
        UIView *multView = [[UIView alloc]initWithFrame:CGRectMake(bgScrollerView.frame.size.width *p, 0, bgScrollerView.frame.size.width, bgScrollerView.frame.size.height)];
        multView.backgroundColor = RGBCOLOR(0, 0, 0,0);
        [bgScrollerView addSubview:multView];
        for (NSInteger i = p*1; i < array.count; i ++) {
            if (i < (p+1)*1) {
                
                NSInteger r = (i%1)/1;
                ShareActionButtonView *buttonView = [[ShareActionButtonView alloc]initWithFrame:CGRectMake(bgScrollerView.frame.size.width/2-30, 5+ (verticalSpace + 70)*r, 60, 70) WithImageName:inconAray[i] WithTitle:array[i]];
                [buttonView addTarget:self action:@selector(shareToMultPlat:) forControlEvents:UIControlEventTouchUpInside];
                buttonView.tag = 5;
                
                buttonView.backgroundColor =RGBCOLOR(0, 0, 0,0);
                [multView addSubview:buttonView];
                
            }
        }
        
    }
    
}

- (void)shareToMultPlat:(UIButton *)btn{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(shareToPlatWithIndex:)]) {
        [self actionViewDissmiss];
        [self.delegate shareToPlatWithIndex:btn.tag];
    }
}

- (void)actionViewShow{
    
    
    AppDelegate *delegare = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [_bgview setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [delegare.window addSubview:_bgview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgviewClick:)];
    tap.numberOfTapsRequired = 1;
    _bgview.userInteractionEnabled = YES;
    [_bgview addGestureRecognizer:tap];
    
    [delegare.window addSubview:self];
    
    
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.frame.size.height , self.frame.size.width, self.frame.size.height);
    }];
}
- (void)tapBgviewClick:(UITapGestureRecognizer *)tap{
    [self actionViewDissmiss];
}
- (void)actionViewDissmiss{
    AppDelegate  *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.358 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height , self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [_bgview removeFromSuperview];
    }];
    
}
@end
