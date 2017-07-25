//
//  LDColumnarChart.h
//  LDChart
//
//  Created by gozap on 2017/7/12.
//  Copyright © 2017年 me.fin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDColumnarChart : UIView
@property (nonatomic,strong) NSArray *valueArray;
@property (nonatomic,strong) NSArray *valueOneArray;
@property (nonatomic, strong) NSArray *monthArray;
/**
 滑动线颜色
 */
@property(nonatomic,strong)UIColor* lineColor;
@end
