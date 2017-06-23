//
//  ViewController.m
//  LZLineChart
//
//  Created by liuze1 on 2017/6/23.
//  Copyright © 2017年 liuze. All rights reserved.
//

#import "ViewController.h"
#import "LZLineChart.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableDictionary * dictionary = [@{} mutableCopy];
    for (int i = 0; i < 100; i++) {
        [dictionary setObject:@((NSInteger)(arc4random() % 6 + 1)) forKey:@(i)];
    }
    LZLineChart * dailyLineChart = [[LZLineChart alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 40, 200) valueDic:dictionary fillColors:@[[UIColor greenColor], [UIColor blueColor]] lineColor:[UIColor redColor] lineWidth:2 maxY:6 maxX:100];
    [self.view addSubview:dailyLineChart];
}



@end
