//
//  LDColumnarChart.m
//  LDChart
//
//  Created by gozap on 2017/7/12.
//  Copyright © 2017年 me.fin. All rights reserved.
//

#import "LDColumnarChart.h"
#import "LDChartControlLine.h"

#define XWSCREENW [UIScreen mainScreen].bounds.size.width

@interface LDColumnarChart()
@property(nonatomic,strong)LDChartControlLine * controlLine;
@end

@implementation LDColumnarChart{
    CGFloat titleHeight;
}

- (void)drawRect:(CGRect)rect {
    
    [self slidingControlLine];
    
    //获取数据最大值
    float max = [[_valueArray valueForKeyPath:@"@max.floatValue"] floatValue];
    //画x轴
    for (int i = 0; i< 11 ; i++) {
        UIBezierPath *Polyline = [UIBezierPath bezierPath];
        //设置起点
        [Polyline moveToPoint:CGPointMake(70, rect.size.height-i*rect.size.height/12-30)];
        //设置终点
        [Polyline addLineToPoint:CGPointMake(self.bounds.size.width -35,rect.size.height-i*rect.size.height/12-30)];
        //设置颜色
        [[UIColor redColor] set];
        //设置宽度
        Polyline.lineWidth = 0.2;
        CGFloat dash[] = {5,1.5};
        [Polyline setLineDash:dash count:2 phase:0];//!!!
        //添加到画布
        [Polyline stroke];
        
        //x轴坐标
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, rect.size.height-i*rect.size.height/12-30-10, 40, 20)];
        if (i==5) {
            label1.text = @"0";
        }else if (i > 5){
            label1.text = [NSString stringWithFormat:@"%.1f",max/5 * (i -5)];
        }else{
            label1.text = [NSString stringWithFormat:@"%.1f",max/5 * (i-5)];
        }
        label1.textAlignment = NSTextAlignmentRight;
        label1.font = [UIFont systemFontOfSize:9];
        
        [self addSubview:label1];
    }
    //计算坐标比例
    float value = (rect.size.height-5*rect.size.height/12-30-(rect.size.height/24))/max ;
    
    if(self.monthArray.count <= 1) return;
    float height = [self chartHeight];
    float width = [self chartWidth];
    NSMutableParagraphStyle * style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentRight;
    NSDictionary * attributes = @{
                                  NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSFontAttributeName: [UIFont systemFontOfSize:9],
                                  NSParagraphStyleAttributeName: style
                                  };
    float averageWidth = width / (self.monthArray.count);
    style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentCenter;
    attributes = @{
                   NSForegroundColorAttributeName: [UIColor colorWithWhite:0.6 alpha:1],
                   NSFontAttributeName: [UIFont systemFontOfSize:9],
                   NSParagraphStyleAttributeName: style
                   };
    for (int i = 0; i < self.monthArray.count; i++) {
        [self.monthArray[i] drawInRect:CGRectMake(78 + i * averageWidth - averageWidth/2, height + 50, averageWidth, 10) withAttributes:attributes];
        //柱状图值
//        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(78 + i * averageWidth - averageWidth/2, rect.size.height-5*rect.size.height/12-30-12-[[_valueArray objectAtIndex:i] floatValue]*value, averageWidth, 10)];
//        label.text = [NSString stringWithFormat:@"%@",[_valueArray objectAtIndex:i]];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont systemFontOfSize:10];
//        [self addSubview:label];
    }
    
    //循环创建柱状图
    for (int i = 0; i<_valueArray.count; i++) {
        UIBezierPath *Polyline = [UIBezierPath bezierPath];
        //设置起点
        [Polyline moveToPoint:CGPointMake(80 + i * averageWidth , rect.size.height-5*rect.size.height/12-30)];
        //设置终点
        [Polyline addLineToPoint:CGPointMake(80 + i * averageWidth ,rect.size.height-5*rect.size.height/12-30-[[_valueArray objectAtIndex:i] floatValue]*value)];
        //设置颜色
        [[UIColor clearColor] set];
        //设置宽度
        Polyline.lineWidth = 20;
        //添加到画布
        [Polyline stroke];
        //添加CAShapeLayer
        CAShapeLayer *shapeLine = [[CAShapeLayer alloc]init];
        //设置颜色
        shapeLine.strokeColor = [UIColor colorWithRed:70/255.0 green:90/255.0 blue:200/255.0 alpha:0.8].CGColor;
        //设置宽度
        shapeLine.lineWidth = 20.0;
        //把CAShapeLayer添加到当前视图CAShapeLayer
        [self.layer addSublayer:shapeLine];
        //把Polyline的路径赋予shapeLine
        shapeLine.path = Polyline.CGPath;
        //开始添加动画
        [CATransaction begin];
        //创建一个strokeEnd路径的动画
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        //动画时间
        pathAnimation.duration = 2.0;
        //添加动画样式
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //动画起点
        pathAnimation.fromValue = @0.0f;
        //动画停止位置
        pathAnimation.toValue   = @1.0f;
        //把动画添加到CAShapeLayer
        [shapeLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        //动画终点
        shapeLine.strokeEnd = 1.0;
        //结束动画
        [CATransaction commit];
    }
    
    //循环创建柱状图
    for (int i = 0; i<_valueOneArray.count; i++) {
        UIBezierPath *Polyline = [UIBezierPath bezierPath];
        //设置起点
        [Polyline moveToPoint:CGPointMake(80 + i * averageWidth , rect.size.height-5*rect.size.height/12-30)];
        //设置终点
        [Polyline addLineToPoint:CGPointMake(80 + i * averageWidth ,rect.size.height-5*rect.size.height/12-30+[[_valueOneArray objectAtIndex:i] floatValue]*value)];
        //设置颜色
        [[UIColor clearColor] set];
        //设置宽度
        Polyline.lineWidth = 20;
        //添加到画布
        [Polyline stroke];
        //添加CAShapeLayer
        CAShapeLayer *shapeLine = [[CAShapeLayer alloc]init];
        //设置颜色
        shapeLine.strokeColor = [UIColor colorWithRed:246/255.0 green:80/255.0 blue:100/255.0 alpha:0.8].CGColor;
        //设置宽度
        shapeLine.lineWidth = 20.0;
        //把CAShapeLayer添加到当前视图CAShapeLayer
        [self.layer addSublayer:shapeLine];
        //把Polyline的路径赋予shapeLine
        shapeLine.path = Polyline.CGPath;
        //开始添加动画
        [CATransaction begin];
        //创建一个strokeEnd路径的动画
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        //动画时间
        pathAnimation.duration = 2.0;
        //添加动画样式
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //动画起点
        pathAnimation.fromValue = @0.0f;
        //动画停止位置
        pathAnimation.toValue   = @1.0f;
        //把动画添加到CAShapeLayer
        [shapeLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        //动画终点
        shapeLine.strokeEnd = 1.0;
        //结束动画
        [CATransaction commit];
    }
}

-(void)slidingControlLine{
    if(!self.controlLine){
        self.controlLine = [LDChartControlLine new];
        self.controlLine.frame = CGRectMake([self chartWidth]+33, 10, 14, [self chartHeight] + 23);
        self.controlLine.userInteractionEnabled = YES;
        self.controlLine.backgroundColor = [UIColor clearColor];
        self.controlLine.dotGlowLayer.backgroundColor = _lineColor.CGColor;
        [self.controlLine.lineLayer setStrokeColor:_lineColor.CGColor];
        [self addSubview:self.controlLine];
        
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [self.controlLine addGestureRecognizer:panGR];
        
        //默认显示最后一条
        self.controlLine.monthLabel.text = _monthArray.lastObject;
    }
}

-(void)pan:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:self.controlLine];
    NSLog(@"%f , %f , %f , %f",recognizer.view.center.x,translation.x,recognizer.view.center.x + translation.x,([self chartWidth]+33 - 70)/(_monthArray.count - 1));
    if ((recognizer.view.center.x + translation.x) < 70 || (recognizer.view.center.x + translation.x) > [self chartWidth]+40) {
        return;
    }
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y );
    [recognizer setTranslation:CGPointZero inView:self.controlLine];
    
    if (translation.x > 0) {
        NSInteger translationX = recognizer.view.center.x + translation.x - 44;
        NSInteger index = translationX / (([self chartWidth]+33 - 70)/(_monthArray.count - 1));
        if (index < _monthArray.count) {
            NSLog(@"%ld , %@",(long)index,_monthArray[index]);
            self.controlLine.monthLabel.text = _monthArray[index];
        }
    }
    else if (translation.x < 0) {
        NSInteger translationX = recognizer.view.center.x - 44;
        NSInteger index = translationX /  (([self chartWidth]+33 - 70)/(_monthArray.count - 1));
        if (index < _monthArray.count) {
            NSLog(@"%ld , %@",(long)index,_monthArray[index]);
            self.controlLine.monthLabel.text = _monthArray[index];
        }
    }
}

- (CGFloat)chartWidth{
    return self.bounds.size.width - 70 -5;
}
- (CGFloat)chartHeight{
    return self.bounds.size.height - 20 - 20 - self.bounds.size.height * (1 - 0.916);
}
@end
