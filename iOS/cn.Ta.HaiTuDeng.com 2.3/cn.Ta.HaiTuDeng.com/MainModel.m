//
//  MainModel.m
//  InFa
//
//  Created by piupiupiu on 16/8/15.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    //if([key isEqualToString:@"description"]){
       // self.descriptionStr = value;
    //}
    
}
//kvc取值操作  取值误操作
-(instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}


@end
