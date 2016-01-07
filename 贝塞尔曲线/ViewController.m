//
//  ViewController.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/5.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import "ViewController.h"
#import "CoordinateView.h"

@interface ViewController ()
{
    CoordinateView* view;
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
    [self.view addSubview:view];
    view.frame = CGRectMake(60, 60, 300, 300);
    view.center = self.view.center;
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGFloat x= arc4random()%100;
    CGFloat y = arc4random() %100;
    [view addValue:CGPointMake(x, y)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
