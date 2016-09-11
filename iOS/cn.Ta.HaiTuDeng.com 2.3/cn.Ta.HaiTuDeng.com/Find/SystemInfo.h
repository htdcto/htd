//
//  SystemInfo.h
//  php
//
//  Created by 李东旭 on 16/3/10.
//  Copyright © 2016年 李东旭. All rights reserved.
//

// 适配屏幕 (必须在iOS6下使用)
#define screenH  [UIScreen mainScreen].bounds.size.height / 667
#define screenW  [UIScreen mainScreen].bounds.size.width / 375

// 获取当前屏幕高度, 宽度
#define screenNowH [UIScreen mainScreen].bounds.size.height
#define screenNowW [UIScreen mainScreen].bounds.size.width

// 颜色RGB
#define colorRGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
