//
//  LDXNetWork.h
//  php
//
//  Created by 李东旭 on 16/3/11.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@interface LDXNetWork : NSObject

// 普通版GET网络请求(做登录验证使用)
+ (void)GetThePHPWithURL:(NSString *)str par:(NSDictionary *)dic success:(void(^)(id responseObject))response error:(void(^)(NSError *error))err;

// 做注册POST网路请求
+ (void)PostThePHPWithURL:(NSString *)str par:(NSDictionary *)dic image:(UIImage *)image uploadName:(NSString *)uploadName success:(void (^)(id response))response error:(void (^)(NSError *error))err;

@end
