//
//  ShareActionView.h
//  CheckIn
//
//  Created by kule on 16/1/13.
//  Copyright © 2016年 zhiye. All rights reserved.
//

//状态界面的弹出框
#import <UIKit/UIKit.h>

@protocol ShareActionViewDelegate <NSObject>

- (void)shareToPlatWithIndex:(NSInteger)index;


@end

@interface ShareActionButtonView: UIButton
@end

@interface ShareActionView : UIView<UIScrollViewDelegate>

@property (nonatomic,assign)id<ShareActionViewDelegate>delegate;
@property (nonatomic,strong)UIView *bgview;

- (id)initWithFrame:(CGRect)frame
    WithSourceArray:(NSArray *)array
      WithIconArray:(NSArray *)iconArray
     WithIconString:(NSString *)String;

//只有上传
-(id)initWithFrame:(CGRect)frame WithSourceArray:(NSArray *)array WithInconArray:(NSArray *)inconAray;

- (void)actionViewShow;
- (void)actionViewDissmiss;
@end
