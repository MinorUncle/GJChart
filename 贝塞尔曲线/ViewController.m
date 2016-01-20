//
//  ViewController.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/5.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import "ViewController.h"
#import "CoordinateView.h"
#import "PolygonLayer.h"

@interface ViewController ()
{
    CoordinateView* view;
    UIScrollView* _scrollView;
}

@end

@implementation ViewController
//-(void)loadView{
//    [super loadView];
//    self.view = [[CustomView alloc]init];
//    self.view.backgroundColor = [UIColor whiteColor];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    view = [[CoordinateView alloc]init];
    view.backgroundColor = [UIColor redColor];
    view.MaxY = 100;
    view.MaxX = 900;
    view.unitX = 20;
    view.unitY = 10;
    view.countX = 5;
    view.countY = 5;
   
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:view];
    view.frame = CGRectMake(60, 60, 900, 300);
    _scrollView.contentSize = view.bounds.size;
    
    PolygonLayer* polygonLayer = [[PolygonLayer alloc]init];
    polygonLayer.frame = view.bounds;
    [view.layer addSublayer:polygonLayer];
    NSMutableArray* arry = [[NSMutableArray alloc]init];
    for (int i = 2; i < 800; i = i+30) {
        CGPoint point = CGPointMake(i, arc4random() % 100);
        [arry addObject:[NSValue valueWithCGPoint:point]];
    }
    
    [polygonLayer addAreaWithPoints:arry color:[UIColor greenColor]];
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
