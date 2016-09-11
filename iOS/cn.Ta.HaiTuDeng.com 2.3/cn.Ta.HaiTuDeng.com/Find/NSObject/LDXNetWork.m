//
//  LDXNetWork.m
//  php
//
//  Created by 李东旭 on 16/3/11.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import "LDXNetWork.h"
#import "Define.h"

@implementation LDXNetWork

+ (void)GetThePHPWithURL:(NSString *)str par:(NSDictionary *)dic success:(void(^)(id responseObject))response error:(void(^)(NSError *error))err
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 返回二进制格式数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 要写http://
    // 把字段写在字典里和放在网址后面? name=lidongxu&pass=123 是一样的
    // name 和 pass 是php那面(也就是后台定义的字段要遵守)
    [manager GET:str parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 这里返回回来的数据不是JSON 是data, 但是不能直接转化成JSON, 而先得转化成字符串
        NSString *s = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        response(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        err(error);
    }];
}

+ (void)PostThePHPWithURL:(NSString *)str par:(NSDictionary *)dic image:(UIImage *)image uploadName:(NSString *)uploadName success:(void (^)(id))response error:(void (^)(NSError *))err
{
    // 3. POST表单上传图片
   
    AFHTTPSessionManager *man = [AFHTTPSessionManager manager];
    man.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 要写http://
    // 把字段写在字典里和放在网址后面? name=lidongxu&pass=123 是一样的
    // name 和 pass 是php那面(也就是后台定义的字段要遵守)
    
    [man POST:str parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data2 = UIImageJPEGRepresentation(image, 1);
        // uploadfile是后台定义的
        // image/jpeg 代表你上传的是图片
        [formData appendPartWithFileData:data2 name:uploadName fileName:@"imgfileStyle.png" mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        // 这里返回回来的数据不是JSON 是data, 但是不能直接转化成JSON, 而先得转化成字符串
        NSString *s = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", s);
        NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        response(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
  
}

@end
