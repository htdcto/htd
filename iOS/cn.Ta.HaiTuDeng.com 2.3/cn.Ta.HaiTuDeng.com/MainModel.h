//
//  MainModel.h
//  InFa
//
//  Created by piupiupiu on 16/8/15.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainModel : NSObject

/*
 {
 "cat_logo" = "<null>";
 "cat_title" = "\U6570\U7801";
 catid = 44;
 contentid = 14455;
 description = "\U6211\U4eec\U4e3a\U4f60\U6d4b\U8bc4\U4e86\U4ee5\U4e0b\U4e03\U6b3e\U66f4\U597d\U73a9\U7684 AR \U5e94\U7528\Uff0c\U5305\U542b\U5854\U9632\U3001\U8d5b\U8f66\U3001\U5929\U6587\U89c2\U6d4b\U3001\U8fd0\U52a8\U3001\U79d1\U666e\U56fe\U9274......\U4e2a\U4e2a\U90fd\U80fd\U8ba9\U4f60\U5728\U73b0\U5b9e\U548c\U865a\U62df\U4e4b\U95f4\U5bfb\U5f97\U4e50\U8da3\U3002";
 "english_title" = digital;
 "home_contentid" = 14456;
 modelid = 1;
 published = "2016.08.15";
 subtitle = "";
 tags = "\U624b\U673a\U6e38\U620f";
 thumb = "";
 title = "Pok\U00e9mon GO \U4e0d\U662f\U7b2c\U4e00\U4e2a AR \U624b\U673a\U6e38\U620f\Uff0c\U4e5f\U8fdc\U4e0d\U662f\U6548\U679c\U6700\U597d\U7684 ";
 url = "http://www.ellemen.com/gear/digital/20160815-14455.shtml";
 },

 
 */


//标题
@property (nonatomic,copy)NSString *Title;
//内容
@property (nonatomic,copy)NSString *Introduction;
//时间
@property (nonatomic,copy)NSString *Uptime;
//图片
@property (nonatomic,copy)NSString *Imageurl;
//小标题
//@property (nonatomic,copy)NSString *Uptime;
//设置网址
@property (nonatomic,copy)NSString *Id;
//达人推荐标识
@property(nonatomic,copy)NSString *Sign;

@end
