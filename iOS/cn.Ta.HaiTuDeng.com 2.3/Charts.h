//
//  ChartView.h
//  IOSlineChart
//
//  Created by Apple on 16/5/10.
//  Copyright © 2016年 zhangleishan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cn.Ta.HaiTuDeng.com-Bridging-Header.h"
@interface ChartView : NSObject
-(LineChartView *)drawLineChart:(NSArray *)weekCountForAll;
-(PieChartView *)drawPieChart:(NSArray *)dayCountForAll;
@end
