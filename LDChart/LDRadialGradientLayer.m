//
//  LDRadialGradientLayer.m
//  LDChart
//
//  Created by huangfeng on 2017/4/19.
//  Copyright © 2017年 me.fin. All rights reserved.
//

#import "LDRadialGradientLayer.h"

@implementation LDRadialGradientLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor].CGColor;
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx{
    UIGraphicsPushContext(ctx);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat colors[self.gradientColors.count];
    for (int i = 0; i<self.gradientColors.count; i++) {
        colors[i] = [self.gradientColors[i] floatValue];
    }
    CGFloat locs[2] = {0,1};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locs, 2);
    
//    CGContextDrawRadialGradient (context, gradient, CGPointMake(15, 15),
//                                 0, CGPointMake(15, 15), 10,
//                                 kCGGradientDrawsBeforeStartLocation);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
//    CGContextSaveGState(context);
//    CGContextRestoreGState(context);
    UIGraphicsPopContext();
}
- (int)getArrayLen:(CGFloat *)arr{
    return sizeof(arr) / sizeof(arr[0]);
}
@end
