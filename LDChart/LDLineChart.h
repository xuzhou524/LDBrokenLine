//
//  LDLineChart.h
//  LDChart
//
//  Created by huangfeng on 2017/4/12.
//  Copyright © 2017年 me.fin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDLineChart : UIView<UIGestureRecognizerDelegate>

/**
 渐变开始颜色
 */
@property(nonatomic,strong)UIColor* gradientStartColor;

/**
 渐变结束颜色
 */
@property(nonatomic,strong)UIColor* gradientEndColor;

/**
 滑动线颜色
 */
@property(nonatomic,strong)UIColor* lineColor;


/**
 数据
 */
@property(nonatomic,strong)NSArray<NSNumber *> * data;

/**
 X 横轴显示的字符串
 */
@property(nonatomic,strong) NSArray<NSString *> *XLabels;
@property(nonatomic,strong) NSString *(^textOfYAxis)(NSInteger index, NSNumber * data);
@end
