//
//  LDLineChart.m
//  LDChart
//
//  Created by huangfeng on 2017/4/12.
//  Copyright © 2017年 me.fin. All rights reserved.
//

#import "LDLineChart.h"
#import "LDChartControlLine.h"

//渐变背景色所占整个控件高度的比例，剩下的就是空白
#define gradientRatio 0.916



@interface LDLineChart()
@property(nonatomic,strong)LDChartControlLine * controlLine;
@property(nonatomic,strong)CAGradientLayer * chartBackgroundLayer;
@property(nonatomic,strong)CAShapeLayer * chartLineLayer;

@property(nonatomic,strong)NSMutableArray * YLabels;
@property(nonatomic,assign)double maxYValue;
@property(nonatomic,assign)double minYValue;
@end

@implementation LDLineChart

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    //设置渐变色背景
    self.backgroundColor = [UIColor clearColor];
    CAGradientLayer * gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    self.chartBackgroundLayer = [[CAGradientLayer alloc] init];
    
    self.chartBackgroundLayer.colors = @[
                             (__bridge id)[UIColor colorWithWhite:1 alpha:0.4].CGColor,
                             (__bridge id)[UIColor colorWithWhite:1 alpha:0.1].CGColor,
                             (__bridge id)[UIColor colorWithWhite:1 alpha:0.05].CGColor
                             ];
    self.chartBackgroundLayer.locations = @[@0.0 ,@0.95, @1.0];
    self.chartBackgroundLayer.startPoint = CGPointMake(0, 0);
    self.chartBackgroundLayer.endPoint = CGPointMake(0, 1);
    
    [self.layer addSublayer:self.chartBackgroundLayer];
    
    _YLabels = [NSMutableArray new];
    
}
-(void)setData:(NSArray<NSNumber *> *)data{
    if(data.count <= 0) return;
    _data = data;

    _maxYValue = [_data.firstObject doubleValue];
    _minYValue = _maxYValue;
    
    for (NSNumber * num in _data) {
        double number = [num doubleValue];
        if(number > _maxYValue){
            _maxYValue = number;
        }
        else if(number < _minYValue){
            _minYValue = number;
        }
    }
    if(_YLabels.count > 0) [_YLabels removeAllObjects];
    double step = (_maxYValue - _minYValue ) / 4;
    for (int i = 0 ; i < 5; i++) {
        if(i == 4) {
            [_YLabels addObject:@(_maxYValue)];
        }
        else{
            [_YLabels addObject:@(i * step + _minYValue)];
        }
    }
}
- (CGFloat)chartWidth{
    return self.bounds.size.width - 70 - 35;
}
- (CGFloat)chartHeight{
    return self.bounds.size.height - 20 - 20 - self.bounds.size.height * (1 - gradientRatio);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    ((CAGradientLayer *)self.layer).colors = @[
                                               (__bridge id)_gradientStartColor.CGColor,
                                               (__bridge id)_gradientEndColor.CGColor,
                                               (__bridge id)[UIColor colorWithWhite:1 alpha:0].CGColor,
                                               (__bridge id)[UIColor colorWithWhite:1 alpha:0].CGColor,
                                               ];
    ((CAGradientLayer *)self.layer).locations = @[@0.0 ,@(gradientRatio),@(gradientRatio),@1.0];
    [self drawDottedLine];

    
    self.chartBackgroundLayer.frame = CGRectMake(70, 20, [self chartWidth], [self chartHeight]);
    
    if(!self.chartLineLayer){
        [self drawChartLine];
    }
    
    if(!self.controlLine){
        self.controlLine = [LDChartControlLine new];
        self.controlLine.frame = CGRectMake([self chartWidth] + 70 - 15/2.0, 20, 14, [self chartHeight] + 4);
        self.controlLine.userInteractionEnabled = YES;
        //self.controlLine.backgroundColor = [UIColor whiteColor];
        self.controlLine.dotGlowLayer.backgroundColor = _lineColor.CGColor;
        [self.controlLine.lineLayer setStrokeColor:_lineColor.CGColor];
        [self addSubview:self.controlLine];

        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [self.controlLine addGestureRecognizer:panGR];
        
        //默认显示最后一条
        self.controlLine.monthLabel.text = _XLabels.lastObject;
    }
}

-(void)pan:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:self.controlLine];
    NSLog(@"%f , %f , %f , %f",recognizer.view.center.x,translation.x,recognizer.view.center.x + translation.x,[self chartWidth]/(_XLabels.count - 1));
    if ((recognizer.view.center.x + translation.x) < 70 || (recognizer.view.center.x + translation.x) > [self chartWidth] + 70) {
        return;
    }
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y );
    [recognizer setTranslation:CGPointZero inView:self.controlLine];
    
    if (translation.x > 0) {
        NSInteger translationX = recognizer.view.center.x + translation.x - 70;
        NSInteger index = translationX / ([self chartWidth]/(_XLabels.count - 1));
        if (index < _XLabels.count) {
            NSLog(@"%ld , %@",(long)index,_XLabels[index]);
            self.controlLine.monthLabel.text = _XLabels[index];
        }
    }
    else if (translation.x < 0) {
        NSInteger translationX = recognizer.view.center.x - 70;
        NSInteger index = translationX /  ([self chartWidth]/(_XLabels.count - 1));
        if (index < _XLabels.count) {
            NSLog(@"%ld , %@",(long)index,_XLabels[index]);
            self.controlLine.monthLabel.text = _XLabels[index];
        }
    }
    
    
   
    
    //if (recognizer.state == UIGestureRecognizerStateEnded) {
    
    //    CGPoint velocity = [recognizer velocityInView:self.controlLine];
    //    CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
    //    CGFloat slideMult = magnitude / 200;
    //    NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
    //    float slideFactor = 0.1 * slideMult; // Increase for more of a slide
    //    CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),recognizer.view.center.y + (velocity.y * slideFactor));
    //    finalPoint.x = MIN(MAX(finalPoint.x, 0), self.controlLine.bounds.size.width);
    //    finalPoint.y = MIN(MAX(finalPoint.y, 0), self.controlLine.bounds.size.height);
        
    //    [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    //        recognizer.view.center = finalPoint;
    //    } completion:nil];
   // }
    
}


/**
 画折线图
 */
-(void)drawDottedLine{
    
    CGFloat height = [self chartHeight];
    CGFloat width = [self chartWidth];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFrame:CGRectMake(70, 0, width, height)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:[UIColor colorWithWhite:1 alpha:0.7].CGColor];
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:1.5], nil]];
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    for (int i = 0; i< 5; i++) {
        CGFloat h = 20 + i * height / 4 + 0.5;
        [path moveToPoint:CGPointMake(0, h)];
        
        [path addLineToPoint:CGPointMake(width, h)];
    }
    
    [shapeLayer setPath:path.CGPath];
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
}

- (void)drawChartLine{
    CGFloat height = [self chartHeight];
    CGFloat width = [self chartWidth];
    
    self.chartLineLayer = [CAShapeLayer layer];
    [self.chartLineLayer setFrame:self.chartBackgroundLayer.frame];
    [self.chartLineLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [self.chartLineLayer setStrokeColor:[UIColor colorWithWhite:1 alpha:1].CGColor];
    //  设置虚线宽度
    [self.chartLineLayer setLineWidth:1];
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    CGFloat step = [self chartWidth] / (self.data.count - 1);
    for (int i = 0; i < self.data.count; i++) {
        CGFloat y = height - height * ([self.data[i] doubleValue] - _minYValue) / (_maxYValue - _minYValue);
        if( i== 0){
            [bezierPath moveToPoint:CGPointMake(0, y)];
        }
        [bezierPath addLineToPoint:CGPointMake(i * step, y)];
    }
    [self.chartLineLayer setPath:bezierPath.CGPath];
    
    [self.layer addSublayer:self.chartLineLayer];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    [maskLayer setFrame:self.chartLineLayer.bounds];

    bezierPath = [UIBezierPath bezierPathWithCGPath:bezierPath.CGPath];
    [bezierPath addLineToPoint:CGPointMake(width, 0)];
    [bezierPath addLineToPoint:CGPointMake(width, height)];
    [bezierPath addLineToPoint:CGPointMake(0, height)];
    [bezierPath closePath];
    [maskLayer setPath:bezierPath.CGPath];

    [self.chartBackgroundLayer setMask:maskLayer];
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    NSMutableParagraphStyle * style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentRight;
    NSDictionary * attributes = @{
                                  NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSFontAttributeName: [UIFont systemFontOfSize:9],
                                  NSParagraphStyleAttributeName: style
                                  };
    
    float height = [self chartHeight];
    float width = [self chartWidth];
    
    float step = height / 4;
    for (int i = 0 ; i < self.YLabels.count ; i++) {
        NSNumber * num =  self.YLabels[i];
        NSString * str;
        if(self.textOfYAxis){
            str = self.textOfYAxis(i, num);
        }
        else{
            str = [NSString stringWithFormat:@"%.2f",[num doubleValue]];
        }
        
        [str drawInRect:CGRectMake(0, height - i * step - 5 + 20, 55 , 10) withAttributes:attributes];
    }
    
    
    if(self.XLabels.count <= 1) return;
    
    float averageWidth = width / (self.XLabels.count - 1);
    style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentCenter;
    attributes = @{
                   NSForegroundColorAttributeName: [UIColor colorWithWhite:0.6 alpha:1],
                   NSFontAttributeName: [UIFont systemFontOfSize:9],
                   NSParagraphStyleAttributeName: style
                   };
    for (int i = 0; i < self.XLabels.count; i++) {
        [self.XLabels[i] drawInRect:CGRectMake(70 + i * averageWidth - averageWidth/2, height + 50, averageWidth, 10) withAttributes:attributes];
    }
}

- (void)removeLayers{
    for (CALayer * layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
}

+ (Class)layerClass{
    return [CAGradientLayer class];
}
@end



