//
//  ChartViewController.m
//  TVBAINIAN
//
//  Created by tongguan on 16/1/21.
//  Copyright © 2016年 tongguantech. All rights reserved.
//

#import "ViewController.h"
#import "GJChartView.h"


@interface ViewController ()<GJChartViewDelegate,GJChartViewDataSourceDelegate,UIScrollViewDelegate>
{
    GJChartView* _coordinateView;
    UIScrollView* _scrollView;
    NSMutableArray* _data;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildData];
    [self buildUI];
    // Do any additional setup after loading the view.
}
-(void)buildData{
    _data = [[NSMutableArray alloc]init];
    for (int i = 0; i<2; i++) {
        float x = 0;
        CGFloat y = 0;
        NSMutableArray* arry = [[NSMutableArray alloc]init];
        for (int j = 0; j<7; j++) {
            y +=1;
            [arry addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
            x += 1;
        }
        [_data addObject:arry];
    }
}
-(void)buildUI{
    CGRect rect = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    rect.origin.y = rect.size.height *0.2;
    rect.size.height *= 0.5;
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:rect];
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = 50;
    _coordinateView = [[GJChartView alloc]initWithFrame:_scrollView.bounds];
    _coordinateView.coordinateType = CoordinateTypeHorizontal;
    _coordinateView.charDelegate = self;
    _coordinateView.charDataDelegate = self;

    _scrollView.directionalLockEnabled = YES;
//    _coordinateView.autoResizeXBigUnitCount = NO;
//    _coordinateView.coordinateLayer.bigUnitXCount = 7;



    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_coordinateView];
    [self drawTenMin];
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _coordinateView;
}

-(void)drawTenMin{
    CGRect rect = _coordinateView.frame;
    rect.size.width = self.view.bounds.size.width*3;
    _coordinateView.frame = rect;
    _scrollView.contentSize = rect.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark DELEGATE

///自定义x轴名称
-(NSString*) GJChartView:(GJChartView*)view xTitleWithCoordinateXValue:(CGFloat)value{
    NSString* title = [NSString stringWithFormat:@"%f",value];
    return title;
}
///自定义y轴名称
-(NSString*) GJChartView:(GJChartView*)view yTitleWithCoordinateYValue:(CGFloat)value
{
   
    NSString* title = [NSString stringWithFormat:@"%0.1f人",value];
    return title;
}

-(NSString *)GJChartView:(GJChartView *)view titleWithValue:(CGPoint)point inSection:(NSInteger)section{
    if (section == 0) {
        return [NSString stringWithFormat:@"%0.1f个",point.y];
    }
    return [NSString stringWithFormat:@"%0.1f元",point.y];
}

-(NSInteger)numberOfSectionsInCoordinateView:(GJChartView *)coordinateView{
    return _data.count;
}

-(NSArray<NSValue *> *)GJChartView:(GJChartView *)view dataForSection:(NSInteger)section{
    if(section <= 0)
        return  nil;
    return _data[section];
}
-(NSString *)GJChartView:(GJChartView *)view tipTitleForSection:(NSInteger)section{
    NSString* tip;
    if (section == 0) {
        tip = @"人数";
    }else{
        tip = @"收益";
    }
    return tip;
}
-(CoordinateViewSectionType)GJChartView:(GJChartView *)view typeWithSection:(NSInteger)section{
    return CoordinateViewSectionTypeBar;
    if (section%2 == 0) {
        return CoordinateViewSectionTypeBar;
    }else{
        return  CoordinateViewSectionTypeLine;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self buildData];
    
    CGRect rect;
    
    rect.size = _scrollView.contentSize;
    rect.origin = CGPointZero;
    _coordinateView.frame = rect;
    _coordinateView.showBackgroundHLine = NO;

//    [_coordinateView reloadData];
}
@end
