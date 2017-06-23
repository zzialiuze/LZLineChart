//
//  LZLineChart.m
//  LZLineChart
//
//  Created by liuze1 on 2017/6/23.
//  Copyright © 2017年 liuze. All rights reserved.
//

#import "LZLineChart.h"
#import "LZBaseLineChart.h"

#define PADDING_TOP 20
#define PADDING_BOTTOM 25
#define PADDING_LEFT 20
#define PADDING_RIGHT 20
#define LINE_WIDTH 1.0f
#define TRIANGLE_WIDTH 20
#define Y_AXIS_SPAN ((self.frame.size.height - PADDING_TOP - PADDING_BOTTOM) / 4)
#define RGBA(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

@interface LZLineChart ()
{
    NSDictionary * phValueDic;
    NSArray * phFillColors;
    UIColor * phLineColor;
    CGFloat phLineWidth;
    NSInteger phMaxY;
    NSInteger phMaxX;
    LZBaseLineChart * baseLineChart;
    
}

@end

@implementation LZLineChart

- (instancetype)initWithFrame:(CGRect)frame
                     valueDic:(NSDictionary *)valueDic
                   fillColors:(NSArray *)fillColors
                    lineColor:(UIColor *)lineColor
                    lineWidth:(CGFloat)lineWidth
                         maxY:(NSInteger)maxY
                         maxX:(NSInteger)maxX {
    self = [super initWithFrame:frame];
    if (self) {
        phValueDic = valueDic;
        phFillColors = fillColors;
        phLineColor = lineColor;
        phLineWidth = lineWidth;
        phMaxX = maxX;
        phMaxY = maxY;
        [self createCoordinateSystem];
        [self drawGraph];
    }
    return self;
}

- (void)createCoordinateSystem {
    NSArray * titleArray = @[@"279", @"279.5", @"280",@"280.5", @"281"];
    NSArray * colorArray = @[[UIColor blueColor], [UIColor yellowColor], [UIColor redColor], [UIColor redColor],[UIColor greenColor]];
    for (int i = 0; i < titleArray.count; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, Y_AXIS_SPAN * i, self.frame.size.width, PADDING_TOP + LINE_WIDTH)];
        label.font = [UIFont systemFontOfSize:PADDING_TOP - 5 weight:UIFontWeightLight];
        label.text = titleArray[i];
        label.textColor = colorArray[i];
        CAShapeLayer * shapeLayer = [CAShapeLayer layer];
        [shapeLayer setFrame:label.bounds];
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        [shapeLayer setStrokeColor:[colorArray[i] CGColor]];
        [shapeLayer setLineWidth:LINE_WIDTH];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, label.frame.size.height - LINE_WIDTH);
        CGPathAddLineToPoint(path, NULL, label.frame.size.width,label.frame.size.height - LINE_WIDTH);
        [shapeLayer setPath:path];
        CGPathRelease(path);
        [[label layer] addSublayer:shapeLayer];
        [self addSubview:label];
    }
    for (int i = 0; i < 9; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - PADDING_LEFT - PADDING_RIGHT) / 8 * i + 10, self.frame.size.height - 20, 20, 20)];
        label.text = [NSString stringWithFormat:@"%d", 3 * i];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor greenColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
}

- (void)drawGraph {
    CGRect rect = CGRectMake(PADDING_LEFT, PADDING_TOP, self.frame.size.width - PADDING_LEFT - PADDING_RIGHT, self.frame.size.height - PADDING_TOP - PADDING_BOTTOM);
    baseLineChart = [[LZBaseLineChart alloc] initWithFrame:rect
                                                  valueDic:phValueDic
                                                fillColors:@[RGBA(20, 200, 20, 1), RGBA(20, 200, 20, 1)]
                                                 lineColor:[UIColor greenColor]
                                                 lineWidth:phLineWidth
                                                      maxY:phMaxY
                                                      maxX:phMaxX
                     ];
    [self addSubview:baseLineChart];
}


@end
