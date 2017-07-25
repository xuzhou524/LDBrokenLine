//
//  LDRadialGradientLayer.h
//  LDChart
//
//  Created by huangfeng on 2017/4/19.
//  Copyright © 2017年 me.fin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDRadialGradientLayer : CALayer

/**
 传递一个 RGBA 为一组的数字数组，每4个代表一个颜色 例如 [1,1,1,1, 1,0,0,1];
 */
@property(nonatomic,strong)NSArray<NSNumber *> *gradientColors;
@end
