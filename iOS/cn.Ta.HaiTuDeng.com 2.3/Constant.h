//
//  Constant.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/25.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constant : NSObject

extern NSString *const UpdateLocalDBAndServer;
extern NSString *const UpdateBackImage;
extern NSString *const UpdateStatusImage;

extern UIImage *image;

extern Boolean JustLogin;

extern NSString *extern_name;
extern NSString *extern_alert;

extern NSString *extern_agreename;

extern NSString *extern_declinename;

//各个页面的回调信息数
//首页点心计数
extern NSInteger mavcCount;

//状态更新提醒
extern BOOL updateStatus;

@end
