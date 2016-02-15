//
//  ChartViewController.m
//  TVBAINIAN
//
//  Created by tongguan on 16/1/21.
//  Copyright © 2016年 tongguantech. All rights reserved.
//

#import "ViewController.h"
#import "CoordinateView.h"


@interface ViewController ()<CoordinateViewDelegate,CoordinateViewDataSourceDelegate>
{
    CoordinateView* _coordinateView;
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
    for (int i = 0; i<4; i++) {
        NSMutableArray* arry = [[NSMutableArray alloc]init];
        for (int j = 0; j<15; j++) {
            int x = j*20;
            CGFloat y = arc4random() %100;
            [arry addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        }
        [_data addObject:arry];
    }
}
-(void)buildUI{
    CGRect rect = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];

    rect.size.height *= 0.5;
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:rect];
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    _coordinateView = [[CoordinateView alloc]initWithFrame:_scrollView.bounds];
    _coordinateView.lineLayer.color = [UIColor yellowColor];
    _coordinateView.coordinateLayer.color = [UIColor yellowColor];
    _coordinateView.delegate = self;
    _coordinateView.dataDelegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_coordinateView];
    [self drawTenMin];
}

-(void)drawTenMin{
    _coordinateView.coordinateLayer.MaxX = 440;
    _coordinateView.coordinateLayer.unitX = 2;
    _coordinateView.coordinateLayer.countX = 5;
    
    
    _coordinateView.coordinateLayer.MaxY = 140;
    _coordinateView.coordinateLayer.unitY = 6;
    _coordinateView.coordinateLayer.countY = 5;
    CGRect rect = _coordinateView.frame;
    rect.size.width = 1880;
    _coordinateView.frame = rect;
    _scrollView.contentSize = rect.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark DELEGATE

-(NSString *)CoordinateSystemLayer:(CoordinateSystemLayer *)view titleWithXValue:(CGFloat)value
{
    int hour = (int)value / 60;
    int min = (int)value % 60;
    NSString* title = [NSString stringWithFormat:@"%02d:%02d",hour,min];
    return title;
}
-(NSString *)CoordinateSystemLayer:(CoordinateSystemLayer *)view titleWithYValue:(CGFloat)value{
    return [NSString stringWithFormat:@"%.1f",value];

}
-(NSString *)CoordinateView:(CoordinateView *)view titleWithValue:(CGPoint)point{
    return [NSString stringWithFormat:@"%0.1f元",point.y];
}

-(NSInteger)numberOfSectionsInCoordinateView:(CoordinateView *)coordinateView{
    return _data.count;
}
-(CoordinateViewSectionType)CoordinateView:(CoordinateView *)view typeWithSection:(NSInteger)section{
    if (section == 1 ) {
        return CoordinateViewSectionTypeBar;
    }
    return CoordinateViewSectionTypeLine;
}

-(NSArray<NSValue *> *)CoordinateView:(CoordinateView *)view dataForSection:(NSInteger)section{
    return _data[section];
}
-(void)CoordinateView:(CoordinateView *)view customTextLayerStlye:(TextSetLayer *)textLayer customSectionLayerStyle:(CALayer *)sectionLayer inSection:(NSInteger)section{
    if (section == 0) {
        textLayer.fontColor = [UIColor redColor];
        ((LineSetLayer*)sectionLayer).capType = LineTypeDash;
    }else if (section == 1){
        textLayer.fontColor = [UIColor yellowColor];
//        ((SquareSetLayer*)sectionLayer).capType = LineTypeDash;
    }

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"VIEW TOUCH");
    static CGFloat x = 0;
    x += arc4random()%50;
    CGFloat y = arc4random() %100;
    [_coordinateView addValue:CGPointMake(x, y)];}
//-(NSString *)CoordinateView:(CoordinateView *)view titleWithYValue:(CGFloat)value{
//    NSString* title;
//    return title;
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
