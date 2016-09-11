//
//  ChartView.m
//  IOSlineChart
//
//  Created by Apple on 16/5/10.
//  Copyright © 2016年 zhangleishan. All rights reserved.
//
//一天的折线图
//123

//123


#import "ChartView.h"
#import "UUChart.h"
#import "LDXNetWork.h"
#import "ViewController.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.8]
#define OneColor UIColorFromRGB(0x036EB8)
#define TwoColor UIColorFromRGB(0XD7036A)
#define YeJiColor UIColorFromRGB(0XD7063A)


@interface ChartView ()<UUChartDataSource>{
    UUChart *chartView;
    int max;  //最大值
    int min;  //最小值
 
    NSMutableArray *X;  //横坐标
    NSMutableArray *Y;  //纵坐标

    UISwitch *switchs; //开关
    BOOL isShowValue;  //显示数值
    }
@property(nonatomic,strong) NSMutableArray *arrayX;//时间轴
@property (nonatomic,strong)NSDate * date;//当前时间

@end

@implementation ChartView

-(instancetype)initWithFrame:(CGRect)frame :(NSArray *)weekCountForAll
{
    if (self=[super initWithFrame:frame]) {
         }
    [self setDate:weekCountForAll];
    return self;
    
}
-(void)OK:(UISwitch *)sender{
    
    
    if (sender.on) {
        
        isShowValue = sender.on;
        
    }else{
        isShowValue = sender.on;
        
    }
    
    [chartView removeFromSuperview];
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height) withSource:self withStyle:UUChartLineStyle];

    [chartView showInView:self];
    
    
    
}

-(void)setDate:(NSArray *)weekCountForAll
{
    NSMutableArray *array1Y=[[NSMutableArray alloc]init];
    array1Y=weekCountForAll[0];
    if(array1Y==nil)
    {array1Y=[NSMutableArray arrayWithObjects:@0,nil];}
    NSMutableArray *array2Y=[[NSMutableArray alloc]init];
    array2Y=weekCountForAll[1];
    if(array2Y==nil)
    {array2Y=[NSMutableArray arrayWithObjects:@0,nil];}
    
    _arrayX = weekCountForAll[2];
    //NSArray *array2Y= [NSArray arrayWithObjects:@"3",@"2",nil];;//取出纪录用户每日点击量数组max

    NSMutableArray *finalY=[NSMutableArray arrayWithCapacity:0];
    [finalY addObject:array1Y];
    [finalY addObject:array2Y];
    
    [self JsX:self.arrayX];
    [self JsY:finalY];
    [chartView removeFromSuperview];
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height) withSource:self withStyle:UUChartLineStyle];//这里可调图的位置和大小
    chartView.backgroundColor =[UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(242/255.0f) alpha:0];

    [chartView showInView:self];
    
}






-(void)JsX:(NSMutableArray *)ary{
    X = [NSMutableArray arrayWithArray:ary];
}
-(void)JsY:(NSMutableArray *)ary{
    NSArray * old1 = [ary objectAtIndex:0];
    NSArray *old2=[ary objectAtIndex:1];
    old1=[old1 arrayByAddingObjectsFromArray:old2];
    max = [[old1 valueForKeyPath:@"@max.intValue"] intValue];
    min = [[old1 valueForKeyPath:@"@min.intValue"] intValue];
    Y = [NSMutableArray arrayWithArray:ary];

}

#pragma mark------直线图和柱状图共用的代码
- (NSMutableArray *)UUChart_xLableArray:(UUChart *)chart{  //横坐标数据
    return X;
}
- (NSMutableArray *)UUChart_yValueArray:(UUChart *)chart{  //纵坐标数据
    return Y;
}

//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[OneColor,TwoColor];  //返回颜色数组，不同的线返回不同的数组
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    return CGRangeMake(max, min);
}

#pragma mark 折线图专享功能

//标记数值区域颜色加深
- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart{
    
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return NO;
}

//判断是否显示数值
-(BOOL)UUChartShowValues:(UUChart *)chart{
    //return isShowValue;
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
