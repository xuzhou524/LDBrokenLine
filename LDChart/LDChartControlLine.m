//
//  LDChartControlLine.m
//  LDChart
//
//  Created by huangfeng on 2017/4/14.
//  Copyright © 2017年 me.fin. All rights reserved.
//

#import "LDChartControlLine.h"


@interface LDChartControlLine ()

@end

@implementation LDChartControlLine
- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.lineLayer = [CAShapeLayer new];
        self.dotGlowLayer = [LDRadialGradientLayer new];
        //self.triangleLayer = [CAShapeLayer new];
        self.monthLabel = [UILabel new];
        self.dotLayer = [CAShapeLayer new];
        self.radialdotGlowLayer = [CAShapeLayer new];
        [self.layer addSublayer:self.radialdotGlowLayer];
        [self.layer addSublayer:self.lineLayer];
        [self.layer addSublayer:self.dotGlowLayer];
        [self.layer addSublayer:self.dotLayer];
        [self addSubview:self.monthLabel];
        //[self.layer addSublayer:self.triangleLayer];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.lineLayer.frame = self.bounds;
    self.dotLayer.frame = self.bounds;
    self.radialdotGlowLayer.frame = self.bounds;

    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat lineWidth = 0.5;
    CGFloat lineX = (width - lineWidth) / 2;
    
    //[self.lineLayer setStrokeColor:[UIColor colorWithRed:246/255.0 green:49/255.0 blue:71/255.0 alpha:1.0].CGColor];
    [self.lineLayer setLineWidth:lineWidth];

    
    UIBezierPath * radialPath = [UIBezierPath bezierPath];
    [radialPath moveToPoint:CGPointMake(lineX, 0)];
    [radialPath addLineToPoint:CGPointMake(lineX, height)];
    [self.radialdotGlowLayer setPath:radialPath.CGPath];
    CGFloat radialDotDiameter  = 12;
    CGFloat radialDotX = (width - radialDotDiameter - lineWidth) / 2;
    CGFloat radialDotY = height - radialDotDiameter + 3;
    CGRect radialFrame = CGRectMake(radialDotX, radialDotY, radialDotDiameter, radialDotDiameter);
    radialPath = [UIBezierPath bezierPathWithOvalInRect:radialFrame];
    self.radialdotGlowLayer.path = radialPath.CGPath;
    [self.radialdotGlowLayer setFillColor:self.lineLayer.strokeColor];
    self.radialdotGlowLayer.opacity = 0.5;
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(lineX, 0)];
    [path addLineToPoint:CGPointMake(lineX, height)];
    [self.lineLayer setPath:path.CGPath];
    CGFloat dotDiameter  = 6;
    CGFloat dotX = (width - dotDiameter - lineWidth) / 2;
    CGFloat dotY = height - dotDiameter;
    CGRect frame = CGRectMake(dotX, dotY, dotDiameter, dotDiameter);
    path = [UIBezierPath bezierPathWithOvalInRect:frame];
    self.dotLayer.path = path.CGPath;
    [self.dotLayer setFillColor:self.lineLayer.strokeColor];
    
    self.dotGlowLayer.gradientColors = @[
                                         @0,@0,@1,@1,
                                         @1,@0,@0,@1,
                                         ];
    self.dotGlowLayer.frame = CGRectMake(-40, -23, 55, 18);
    //self.dotGlowLayer.backgroundColor = self.lineLayer.strokeColor;
    [self.dotGlowLayer setNeedsDisplay];
    
    //线的路径
    UIBezierPath *polygonPath = [UIBezierPath bezierPath];
    // 这些点的位置都是相对于所在视图的
    // 起点
    [polygonPath moveToPoint:CGPointMake(6.1, -5)];
    // 其他点
    [polygonPath addLineToPoint:CGPointMake(8.1, -5)];
    [polygonPath addLineToPoint:CGPointMake(7.1, -3)];
    [polygonPath closePath]; // 添加一个结尾点和起点相同
    
    self.triangleLayer = [CAShapeLayer layer];
    self.triangleLayer.lineWidth = 2;
    self.triangleLayer.strokeColor = self.lineLayer.strokeColor;
    self.triangleLayer.path = polygonPath.CGPath;
    self.triangleLayer.fillColor = self.lineLayer.strokeColor;
    [self.layer addSublayer:self.triangleLayer];
    
    _monthLabel.frame = CGRectMake(-40, -23, 55, 18);
    //_monthLabel.text = @"2017-07";
    _monthLabel.font = [UIFont systemFontOfSize:12];
    _monthLabel.textAlignment = NSTextAlignmentCenter;
    _monthLabel.textColor = [UIColor whiteColor];
    [self addSubview:_monthLabel];
    
}
@end

