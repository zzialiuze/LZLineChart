//
//  LZBaseLineChart.m
//  LZLineChart
//
//  Created by liuze1 on 2017/6/23.
//  Copyright © 2017年 liuze. All rights reserved.
//

#import "LZBaseLineChart.h"


@interface LZBaseLineChart (){
    
    NSDictionary * lzValueDic;
    NSArray * lzFillColors;
    UIColor * lzLineColor;
    CGFloat lzLineWidth;
    double lzMaxY;
    double lzMaxX;
    UIBezierPath * lzPath;
    CGFloat ySpan;
    CGFloat xSpan;
    UIView * roundView;
    UIView * lineView;
    NSMutableArray * heightArray;
    CAGradientLayer * gradientLayer;
}




@end

@implementation LZBaseLineChart

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
                     valueDic:(NSDictionary *)valueDic
                   fillColors:(NSArray *)fillColors
                    lineColor:(UIColor *)lineColor
                    lineWidth:(CGFloat)lineWidth
                         maxY:(NSInteger)maxY
                         maxX:(NSInteger)maxX {
    self = [super initWithFrame:frame];
    if (self) {
        lzValueDic = valueDic;
        lzFillColors = fillColors;
        lzLineColor = lineColor;
        lzLineWidth = lineWidth;
        lzMaxY = maxY;
        lzMaxX = maxX;
        [self initConfig];
    }
    return self;
}

- (void)initConfig {
    self.backgroundColor = [UIColor clearColor];
    ySpan = self.frame.size.height / lzMaxY;
    xSpan = self.frame.size.width / lzMaxX;
    
    NSArray * keyArray = [lzValueDic allKeys];
    keyArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare: obj2];
        return result == NSOrderedDescending;
    }];
    
    lzPath = [UIBezierPath bezierPath];
    for (NSInteger i = 0;i < keyArray.count;i++) {
        NSInteger value = [[lzValueDic objectForKey:keyArray[i]] doubleValue];
        CGPoint point = CGPointMake(xSpan * i, ySpan * (lzMaxY - value));
        if(i == 0) {
            [lzPath moveToPoint:point];
            continue;
        }
        [lzPath addLineToPoint:point];
    }
    
    //添加阴影
    if (lzFillColors.count != 0) {
        UIBezierPath * gradientPath = [lzPath copy];
        [gradientPath addLineToPoint:CGPointMake(keyArray.count * xSpan, self.frame.size.height)];
        [gradientPath addLineToPoint:CGPointMake(0, self.frame.size.height)];
        [gradientPath closePath];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = gradientPath.CGPath;
        
        gradientLayer = [CAGradientLayer layer];
        
        NSArray * colors = @[(id)[lzFillColors[0] CGColor], (id)[lzFillColors[1]CGColor]];
        gradientLayer.frame = self.bounds;
        gradientLayer.colors = colors;
        gradientLayer.opacity = 0.5;
        gradientLayer.mask = maskLayer;
        [self.layer addSublayer:gradientLayer];
    }
    
    heightArray = [@[] mutableCopy];
    for (int i = 0; i < keyArray.count; i++) {
        NSNumber * height = @([[lzValueDic objectForKey:@(i)] integerValue] * ySpan);
        [heightArray addObject:height];
    }
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0)];
    lineView.backgroundColor = [UIColor redColor];
    [self addSubview:lineView];
}


#pragma mark - phtriangleDelegate



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint beginPoint = [touch locationInView:self];
    [self willMove:beginPoint.x];
    //    if (self.delegate) {
    //        [self.delegate willMove:self.center.x];
    //    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint nowPoint = [touch locationInView:self];
    if (nowPoint.x < 0 || nowPoint.x > self.frame.size.width) {
        return;
    }
    [self didMove:nowPoint.x];

}



- (void)willMove:(CGFloat)xAxis {
    [self actionWithXAxis:xAxis];
    if (self.delegate) {
        [self.delegate actionOnSelectXValue:[self getLeftIntervalViaX:xAxis - self.frame.origin.x]];
    }
}

- (void)didMove:(CGFloat)xAxis {
    [self actionWithXAxis:xAxis];
    if (self.delegate) {
        [self.delegate actionOnSelectXValue:[self getLeftIntervalViaX:xAxis - self.frame.origin.x]];
    }
}

- (void)endMove:(CGFloat)xAxis {
    [self actionWithXAxis:xAxis];
    if (self.delegate) {
        [self.delegate actionOnSelectXValue:[self getLeftIntervalViaX:xAxis - self.frame.origin.x]];
    }

}

- (void)actionWithXAxis:(CGFloat)xAxis {
    //    NSInteger leftInterval = [self getLeftIntervalViaX:xAxis - self.frame.origin.x];
    //    NSInteger rightInterval = leftInterval + 1;
    //    CGFloat y = [self getYWithX1:leftInterval * xSpan Y1:[heightArray[leftInterval] floatValue] X2:rightInterval * xSpan Y2:[heightArray[rightInterval] floatValue] X:(xAxis - self.frame.origin.x)];
    [self refreshIndicatorWithPoint:CGPointMake(xAxis, 0)];
}

- (void)refreshIndicatorWithPoint:(CGPoint)point {
    roundView.center = point;
    CGRect rect = lineView.frame;
    rect.origin.x = point.x - 0.5;
    rect.origin.y = 0;
    rect.size.height = self.frame.size.height;
    lineView.frame = rect;
}

- (CGFloat)getYWithX1:(CGFloat)x1 Y1:(CGFloat)y1 X2:(CGFloat)x2 Y2:(CGFloat)y2 X:(CGFloat)x{
    return (x - x1) * (y2 - y1) / (x2 - x1) + y1;
}

- (NSInteger)getLeftIntervalViaX:(CGFloat)x {
    return (x / xSpan) == lzMaxX ? (lzMaxX - 1) : (x / xSpan);
}



@end
