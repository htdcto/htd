//
//  ChartView.m
//  IOSlineChart
//
//  Created by Apple on 16/5/10.
//  Copyright © 2016年 zhangleishan. All rights reserved.
//



#import "Charts.h"
#import "cn.Ta.HaiTuDeng.com-Bridging-Header.h"
#import "cn_Ta_HaiTuDeng_com-Swift.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.8]
#define OneColor UIColorFromRGB(0x036EB8)
#define TwoColor UIColorFromRGB(0XD7036A)
#define YeJiColor UIColorFromRGB(0XD7063A)


@interface ChartView ()<ChartViewDelegate>

//@property (nonatomic,strong)NSDate * date;//当前时间
@property (nonatomic,strong)LineChartView *LineChartView;
@property (nonatomic,strong)PieChartView *PieChartView;



@end

BOOL full;
@implementation ChartView

//折线图

-(LineChartData *)setDataForLine:(NSArray *)weekCountForAll
{
    
    
    NSMutableArray *arrayX=[[NSMutableArray alloc]init];
    arrayX = weekCountForAll[2];
    //ChartDefaultAxisValueFormatter *ss = [[ChartDefaultAxisValueFormatter alloc]init];
    
    
    NSMutableArray *arrayY1=[[NSMutableArray alloc]init];
    arrayY1=weekCountForAll[0];
    if(arrayY1==nil)
    {arrayY1=[NSMutableArray arrayWithObjects:@0,nil];}
    
    NSMutableArray *Y1 = [[NSMutableArray alloc]init];
    
    for(int i=0; i<arrayY1.count;i++) {
        double var = [arrayY1[i] doubleValue];
        ChartDataEntry *entry = [[ChartDataEntry alloc]initWithX:(double)i y:var];
        [Y1 addObject:entry];
        
    }
    
    NSMutableArray *arrayY2=[[NSMutableArray alloc]init];
    arrayY2=weekCountForAll[1];
    if(arrayY2==nil)
    {arrayY2=[NSMutableArray arrayWithObjects:@0,nil];}
    
    NSMutableArray *Y2 = [[NSMutableArray alloc]init];
    
    for(int i=0; i<arrayY2.count;i++) {
        double var = [arrayY2[i] doubleValue];
        ChartDataEntry *entry = [[ChartDataEntry alloc]initWithX:(double)i y:var];
        [Y2 addObject:entry];
        
    }
    
    LineChartDataSet *set1 = nil;
    //创建LineChartDataSet对象
    set1 = [[LineChartDataSet alloc] initWithValues:Y1 label:@"我"];
    [set1 setColor:[UIColor redColor]];//折线颜色
    set1.circleColors = @[[UIColor redColor]];//拐点颜色
    /*
     //设置折线的样式
     set1.lineWidth = 1.0/[UIScreen mainScreen].scale;//折线宽度
     set1.drawValuesEnabled = YES;//是否在拐点处显示数据
     set1.valueColors = @[[UIColor brownColor]];//折线拐点处显示数据的颜色
     set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
     //折线拐点样式
     set1.drawCirclesEnabled = NO;//是否绘制拐点
     set1.circleRadius = 5.0f;//拐点半径
     set1.circleColors = @[[UIColor redColor], [UIColor greenColor]];//拐点颜色
     //拐点中间的空心样式
     set1.drawCircleHoleEnabled = YES;//是否绘制中间的空心
     set1.circleHoleRadius = 2.0f;//空心的半径
     set1.circleHoleColor = [UIColor blackColor];//空心的颜色
     //折线的颜色填充样式
     //第一种填充样式:单色填充
     //        set1.drawFilledEnabled = YES;//是否填充颜色
     //        set1.fillColor = [UIColor redColor];//填充颜色
     //        set1.fillAlpha = 0.3;//填充颜色的透明度
     //第二种填充样式:渐变填充
     set1.drawFilledEnabled = YES;//是否填充颜色
     NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#FFFFFFFF"].CGColor,
     (id)[ChartColorTemplates colorFromString:@"#FF007FFF"].CGColor];
     CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
     set1.fillAlpha = 0.3f;//透明度
     set1.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f];//赋值填充颜色对象
     CGGradientRelease(gradientRef);//释放gradientRef
     */
    LineChartDataSet *set2 = nil;
    //创建LineChartDataSet对象
    set2 = [[LineChartDataSet alloc] initWithValues:Y2 label:@"Ta"];
    [set2 setColor:[UIColor blueColor]];//折线颜色
    set2.circleColors = @[[UIColor blueColor]];
    
    //将 LineChartDataSet 对象放入数组中
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    [dataSets addObject:set2];
    LineChartData *data = [[LineChartData alloc]initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];//文字字体
    [data setValueTextColor:[UIColor grayColor]];//文字颜色
    
    return data;
}

-(LineChartView *)drawLineChart:(NSArray *)weekCountForAll
{
    
    
    LineChartData *data =[[LineChartData alloc]init];
    data = [self setDataForLine:weekCountForAll];
    self.LineChartView = [[LineChartView alloc] init];
    
    
    ChartXAxis *xAxis = self.LineChartView.xAxis;
    xAxis.drawGridLinesEnabled = NO;//不绘制网格线
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
    xAxis._axisMinimum = 0;
    self.LineChartView.rightAxis.enabled = NO;//不绘制右边轴
    self.LineChartView.doubleTapToZoomEnabled =NO;
    [self.LineChartView setDragEnabled:NO];
    
    self.LineChartView.data = data;
    
    return self.LineChartView;
}

//折线图

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

//饼状图
-(PieChartData *)setDataForPie:(NSArray *)dayCountForAll
{
    NSString *Ucount = dayCountForAll[0];
    NSString *Tcount = dayCountForAll[1];
    double U = Ucount.doubleValue;
    double T = Tcount.doubleValue;
    NSMutableArray *yVals = [[NSMutableArray alloc]init];
    BarChartDataEntry *entry = [[BarChartDataEntry alloc]initWithX:1 y:U];
    [yVals addObject:entry];
    entry = [[BarChartDataEntry alloc]initWithX:2 y:T];
    [yVals addObject:entry];
    
    NSString *wo = @"我";
    NSString *ta = @"Ta";
    NSMutableArray *xVals = [[NSMutableArray alloc]init];
    [xVals addObject:wo];
    [xVals addObject:ta];
    
    PieChartDataSet *set = [[PieChartDataSet alloc]initWithValues:yVals label:@"更新状态数"];
    set.drawValuesEnabled = YES;
    
    NSMutableArray *colors = [[NSMutableArray alloc]init];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObject:[UIColor blueColor]];
    
    set.colors =colors;
    set.sliceSpace = 0;
    set.selectionShift = 8;
    set.xValuePosition = PieChartValuePositionInsideSlice;
    set.yValuePosition = PieChartValuePositionOutsideSlice;
    PieChartData *data = [[PieChartData alloc]initWithDataSet:set];
    /*
     NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
     formatter.numberStyle = NSNumberFormatterPercentStyle;
     formatter.maximumFractionDigits = 0;
     formatter.multiplier = @1.f;
     [data setValueFormatter:formatter];
     */
    [data setValueTextColor:[UIColor brownColor]];
    [data setValueFont:[UIFont systemFontOfSize:10]];
    return data;
    
}

-(PieChartView *)drawPieChart:(NSArray *)dayCountForAll
{
    PieChartData *data = [self setDataForPie:dayCountForAll];
    self.PieChartView = [[PieChartView alloc]init];
    self.PieChartView.data = data;
    self.PieChartView.backgroundColor = [UIColor whiteColor];
    return self.PieChartView;
    
}

@end
