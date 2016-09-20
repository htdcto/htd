//
//  DB.h
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/9.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DB : NSObject
{
    sqlite3 *db;
}

+(instancetype)shareInit;
-(void)openOrCreateDB;
-(void)updateDBAfterLoginSuccess:(NSString *)Uname response:(void(^)(void))response;
-(void)execSql:(NSString *)sql;
-(NSArray *)upTimestamp:(NSDate *)dayOfSearching;
-(NSMutableArray *)caculateTheCountOfTimestampFromServer:(NSDate *)searchingMonday;
-(void)createDBPath;
-(void)closeDB;

@end
