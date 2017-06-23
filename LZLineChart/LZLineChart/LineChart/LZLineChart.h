//
//  LZLineChart.h
//  LZLineChart
//
//  Created by liuze1 on 2017/6/23.
//  Copyright © 2017年 liuze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZLineChart : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     valueDic:(NSDictionary *)valueDic
                   fillColors:(NSArray *)fillColors
                    lineColor:(UIColor *)lineColor
                    lineWidth:(CGFloat)lineWidth
                         maxY:(NSInteger)maxY
                         maxX:(NSInteger)maxX;

@end
