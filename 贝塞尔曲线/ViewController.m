//
//  ChartViewController.m
//  TVBAINIAN
//
//  Created by tongguan on 16/1/21.
//  Copyright © 2016年 tongguantech. All rights reserved.
//

#import "ViewController.h"
#import "CoordinateView.h"


@interface ViewController ()<CoordinateViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    CoordinateView* _coordinateView;
    UIScrollView* _scrollView;
    UIDatePicker* _picker;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
    // Do any additional setup after loading the view.
}
-(void)buildUI{
    CGRect rect = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];

    rect.size.height *= 0.5;
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:rect];
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    _coordinateView = [[CoordinateView alloc]initWithFrame:_scrollView.bounds];
    _coordinateView.backgroundColor = [UIColor greenColor];
    _coordinateView.lineLayer.color = [UIColor yellowColor];
    _coordinateView.color = [UIColor yellowColor];
    _coordinateView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_coordinateView];
    [self drawTenMin];
}
-(void)valueChange:(UIDatePicker* )picker{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* str = [formatter stringFromDate:_picker.date];
    NSLog(@"%@",str);
    
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 4;
}


-(void)drawTenMin{
    _coordinateView.MaxX = 1440;
    _coordinateView.unitX = 2;
    _coordinateView.countX = 5;
    CGRect rect = _coordinateView.frame;
    rect.size.width = 6880;
    _coordinateView.frame = rect;
    _scrollView.contentSize = rect.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)CoordinateView:(CoordinateView *)view titleWithXValue:(CGFloat)value{
    int hour = (int)value / 60;
    int min = (int)value % 60;
    NSString* title = [NSString stringWithFormat:@"%02d:%02d",hour,min];
    return title;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch");
}
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
