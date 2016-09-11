//
//  DB.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/9.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "DB.h"

@interface DB()<HelperDelegate>
@property (nonatomic,strong)NSDate*date;
@property (nonatomic,strong)NSString *DBpath;
@end
@implementation DB


+(instancetype)shareInit
{
    static dispatch_once_t onceToken;
    static DB *_db = nil;
    dispatch_once(&onceToken, ^{
        _db = [[DB alloc]init];
    });
    return _db;
}

-(void)updateDBAfterLoginSuccess:(NSString *)Uname successful:(void(^)(void))response
{
    
    sqlite3_stmt *tdbps;
    sqlite3_stmt *udbps;
    NSString *Ttimepoint;
    NSString *Utimepoint;
    NSString *sqlSearchTtimepoint = @"select time from Ttime  order by time desc limit 1";
    NSString *sqlSearchUtimepoint = @"select time from Utime  order by time desc limit 1";
    const char *TtimepointqueryStatement = [sqlSearchTtimepoint UTF8String];
    const char *UtimepointqueryStatement = [sqlSearchUtimepoint UTF8String];
    
    sqlite3_prepare_v2 (db, TtimepointqueryStatement, -1, &tdbps, NULL);
    sqlite3_step(tdbps);
    if(sqlite3_column_text(tdbps,0) == NULL)
    {
        Ttimepoint = @"0";
        NSLog(@"-----------------------%@",Ttimepoint);
    }
    else{
        Ttimepoint = [[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(tdbps,0)];
        NSLog(@"____________________%@",Ttimepoint);
    }
    
    
    sqlite3_prepare_v2 (db, UtimepointqueryStatement, -1, &udbps, NULL);
    sqlite3_step (udbps);
    if (sqlite3_column_text(udbps, 0) == NULL)
    {
        Utimepoint = @"0";
        NSLog(@"-----------------------%@",Utimepoint);
    }
    else{
        Utimepoint = [[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(udbps, 0)];
        NSLog(@"__________________%@",Utimepoint);
    }
    sqlite3_finalize (udbps);
    sqlite3_finalize (tdbps);
    
    NSDictionary *dic = @{@"Utel":Uname,@"Utime":Utimepoint,@"Ttime":Ttimepoint};
    [LDXNetWork GetThePHPWithURL:address(@"/timedown.php") par:dic success:^(id responseObject) {
        NSArray *Utime = responseObject[@"Utime"];
        NSArray *Ttime = responseObject[@"Ttime"];
        
        if(![Utime[0] isEqualToString:@"0"])
        {
            for(int i=0; i<Utime.count; i++)
            {
                NSString *insertStatement = [NSString stringWithFormat:@"insert into UTIME (time) values ('%@')",Utime[i]];
                
                // NSString *insertStatement = [NSString stringWithFormat:@"insert into UTIME(time) values('%@') where '%@' >=(select time from UTIME order by time desc limit 1 )",Utime[i],Utime[i]];
                
                
                [self execSql:insertStatement];
            }
        }
        
        if(![Ttime[0] isEqualToString:@"0"])
        {
            for(int i=0; i<Ttime.count; i++)
            {
                NSString *insertStatement = [NSString stringWithFormat:@"insert into TTIME (time) values ('%@')",Ttime[i]];
                [self execSql:insertStatement];
            }
        }
        
        if (response)
        {
            response();
        }
        
    } error:^(NSError *error) {
        NSLog(@"登录失败的原因:%@",error);
    }];
    
}

-(void)openOrCreateDB
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Uname = [userDefaults objectForKey:@"name"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *Udocuments = [NSString stringWithFormat:@"%@/%@", documents,Uname];
    NSString *U_DBname = [NSString stringWithFormat:@"%@-%@",Uname,DBNAME];
    _DBpath = [Udocuments stringByAppendingPathComponent:U_DBname];
    NSLog(@"登录时创建或者打开数据库：%@",_DBpath);
    
    if(sqlite3_open([_DBpath UTF8String], &db) ==SQLITE_OK)
    {
        NSString *sqlCreateTable_UTIME = @"CREATE TABLE IF NOT EXISTS UTIME(ID INTEGER PRIMARY KEY AUTOINCREMENT,time varchar(30))";
        NSString *sqlCreateTable_TTIME =@"CREATE TABLE IF NOT EXISTS TTIME(ID INTEGER PRIMARY KEY AUTOINCREMENT,time varchar(30))";
        [self execSql:sqlCreateTable_UTIME];
        [self execSql:sqlCreateTable_TTIME];
        
    }
    else
    {
        NSLog(@"打开数据库失败");
    }
}


-(void)execSql:(NSString *)sql
{
    char *err;
    if(sqlite3_exec(db,[sql UTF8String],NULL,NULL,&err) !=SQLITE_OK)
    {
        sqlite3_close(db);
        NSLog(@"操作数据库失败");
    }
}



-(NSArray *)upTimestamp:(NSInteger)key //刷新左侧具体时间表格子
{
    
    sqlite3_stmt *getu;
    NSString * result;
    NSMutableArray * times=[[NSMutableArray alloc]init];
    int i;
    //1是当天，加几就是前几天
    
    NSDate * date=[NSDate date];
    
    long  now = (long)[date timeIntervalSince1970];
    now = now + 8*60*60;
    long trun=now/(24*60*60);
    long trun1=trun- key;
    long trun2=trun1+1;
    long timepoint=trun1*24*60*60-8*60*60;
    long getdate=trun1*24*60*60-8*60*60;
    long timepoint1=trun2*24*60*60-8*60*60;
    NSDate * t  = [NSDate dateWithTimeIntervalSince1970:timepoint];
    NSDate * t1  = [NSDate dateWithTimeIntervalSince1970:timepoint1];
    NSDate * getdateing=[NSDate dateWithTimeIntervalSince1970:getdate];
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * sls =  [formatter stringFromDate :t];
    NSString * sls2 =  [formatter stringFromDate :t1];
    //NSDateFormatter * formatter1 = [[NSDateFormatter alloc ] init];
    //[formatter1 setDateFormat:@"YY年MM月dd日"];
    //NSString * getdateed =  [formatter1 stringFromDate :getdateing];
    NSString *uStatement = [NSString stringWithFormat:@"select time from TTIME where time < '%@' and time >= '%@'",sls2,sls];
    const char * getUTimeStamp = [uStatement UTF8String];
    sqlite3_prepare_v2(db, getUTimeStamp, -1, &getu, NULL);
    NSDate * resed=[[NSDate alloc ] init];//
    while((i = sqlite3_step(getu)) == SQLITE_ROW)
    {
        
        result = [[NSString alloc]initWithUTF8String: (char*) sqlite3_column_text (getu, 0)];
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        resed =  [formatter dateFromString:result];
        NSDateFormatter * formatter1 = [[NSDateFormatter alloc ] init];
        [formatter1 setDateFormat:@"HH:mm:ss"];
        NSString * reseded =  [formatter1 stringFromDate :resed];
        [times addObject:reseded];
    }
    NSArray *labelData = [[NSArray alloc]initWithObjects:getdateing,times,nil];
    return labelData;
    
}

-(NSMutableArray *)caculateTheCountOfTimestampFromServer:(NSInteger)k :(NSInteger)startIndex
{
    
    NSInteger DB_startIndex = startIndex;
    NSString * SDB_startIndex=[NSString stringWithFormat:@"%ld",(long)DB_startIndex];
    NSMutableArray *weekCountForAll = [[NSMutableArray alloc]init];
    //时间处理
    NSDate *USDate = [NSDate date];
    _date=[NSDate date];
    long now = (long)[_date timeIntervalSince1970];
    now = now+60*60*8;
    _date = [NSDate dateWithTimeIntervalSince1970:now];
    NSLog(@"当前时间%@",_date);
    //数据库参数
    sqlite3_stmt *getu;
    sqlite3_stmt *gett;
    int i;
    NSString * result;
    NSMutableArray * uResult = [[NSMutableArray alloc]init];
    NSMutableArray * tResult = [[NSMutableArray alloc]init];
    //时间轴参数
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger weekday = [gregorianCalendar component:NSCalendarUnitWeekday fromDate:USDate]-1;
    if(weekday==0)
    {weekday=7;}
    NSLog(@"今天是周%ld",weekday);
    NSInteger key=0;
    weekday=weekday+k*7;
    NSInteger mykey=weekday;
    long trun=now/(24*60*60);
    
    long trun1=trun-mykey+1;
    long trun2=trun1+7;
    long timepoint=(trun1*24*60*60-8*60*60);
    long timepoint2=(trun2*24*60*60-8*60*60);
    NSDate * t  = [NSDate dateWithTimeIntervalSince1970:timepoint];
    NSDate * t2  = [NSDate dateWithTimeIntervalSince1970:timepoint2];
    
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * sls =  [formatter stringFromDate :t];
    NSString * sls2 =  [formatter stringFromDate :t2];
    NSLog(@"(((((((sls%@((((((((sls2%@",sls,sls2);
    
    NSString *uStatement = [NSString stringWithFormat:@"select time from UTIME where time < '%@' and time >= '%@'",sls2,sls];
    NSString *tStatement = [NSString stringWithFormat:@"select time from TTIME where time < '%@' and time >= '%@'",sls2,sls];
    const char * getUTimeStamp = [uStatement UTF8String];
    const char * getTTimeStamp = [tStatement UTF8String];
    sqlite3_prepare_v2(db, getUTimeStamp, -1, &getu, NULL);
    sqlite3_prepare_v2(db, getTTimeStamp, -1, &gett, NULL);
    while((i = sqlite3_step(getu)) == SQLITE_ROW)
    {
        result = [[NSString alloc]initWithUTF8String: (char*) sqlite3_column_text (getu, 0)];
        [uResult addObject:result];
    }
    
    while((i = sqlite3_step(gett)) == SQLITE_ROW)
    {
        result = [[NSString alloc]initWithUTF8String: (char*) sqlite3_column_text (gett, 0)];
        [tResult addObject:result];
    }
    
    NSMutableArray* longtime =[[NSMutableArray alloc]init];
    NSMutableArray* longtimet =[[NSMutableArray alloc]init];
    
    NSString *p = [[NSString alloc]init];
    NSString *pt = [[NSString alloc]init];
    if (mykey<7)
    {
        key=mykey;
    }
    else
    {key=8-DB_startIndex;}
    for(int i=0;i<key;i++)
    {
        int dmax=0;
        int dmaxt=0;
        for(int j=0;j<[uResult count];j++)
        {
            NSString * ls= [uResult objectAtIndex:j];
            NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSDate * sls =  [formatter dateFromString:ls];
            long longls = (long)[sls timeIntervalSince1970];
            longls=longls+(8*60*60);
            if(longls/(24*60*60)==((timepoint+8*60*60)/(24*60*60))+i)
            {
                dmax ++;
            }
        }
        
        
        for(int j=0;j<[tResult count];j++)
        {
            NSString * ls= [tResult objectAtIndex:j];
            NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSDate * sls =  [formatter dateFromString:ls];
            long longls = (long)[sls timeIntervalSince1970];
            longls=longls+(8*60*60);
            if(longls/(24*60*60)==((timepoint+8*60*60)/(24*60*60))+i)
            {
                dmaxt ++;
            }
        }
        pt=[NSString stringWithFormat:@"%d",dmaxt];
        p=[NSString stringWithFormat:@"%d",dmax];
        [longtime addObject: p];//我的折线
        [longtimet addObject:pt];//他的折线
    }
    
    NSMutableArray * arrayX=[[NSMutableArray alloc] init];
    for (long  i= 0 ;i <7;i++)
    {
        long fin=(timepoint+8*60*60)+i*86400-(8*60*60);
        NSDate * datenow = [[NSDate alloc] initWithTimeIntervalSince1970:fin];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate: datenow];
        [arrayX addObject:strDate];
    }
    [weekCountForAll addObject:longtime];
    [weekCountForAll addObject:longtimet];
    [weekCountForAll addObject:arrayX];
    [weekCountForAll addObject:SDB_startIndex];
    
    
    return weekCountForAll;
}

-(void)insertHeartTimeInUtime:(NSString *)Utime
{
    NSString *sql = [NSString stringWithFormat:@"insert into UTIME (time) values ('%@')",Utime];
    [self execSql:sql];
}

-(void)insertHeartTimeInTtime:(NSString *)Ttime
{
    NSString *sql = [NSString stringWithFormat:@"insert into Ttime (time) valuew ('%@')",Ttime];
    [self execSql:sql];
}

@end
