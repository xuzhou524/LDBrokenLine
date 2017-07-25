//
//  LDChartControlLine.h
//  LDChart
//
//  Created by huangfeng on 2017/4/14.
//  Copyright © 2017年 me.fin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDRadialGradientLayer.h"

@class LDChartControlTriangle;
@interface LDChartControlLine : UIView
@property(nonatomic,strong)CAShapeLayer * lineLayer;
@property(nonatomic,strong)CAShapeLayer * dotLayer;
@property(nonatomic,strong)LDRadialGradientLayer * dotGlowLayer;
@property(nonatomic,strong)CAShapeLayer * triangleLayer;

@property(nonatomic,strong)UILabel * monthLabel;
@end

