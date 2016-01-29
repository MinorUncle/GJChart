//
//  ChartViewController.m
//  TVBAINIAN
//
//  Created by tongguan on 16/1/21.
//  Copyright © 2016年 tongguantech. All rights reserved.
//

#import "ChartViewController.h"
#import "CoordinateView.h"
#import "InfomationCallBack.h"
#import "PullDownView.h"

#define PAGE_TEN_SIXTY 3
#define PAGE_COUNT_THIRTY 6
#define PAGE_COUNT_TEN 18
@interface ChartViewController ()<CoordinateViewDelegate,PullDownViewDelegate>
{
    CoordinateView* _coordinateView;
    LineSetLayer* lineLayer ;//坐标的虚线
    LineSetLayer* _enterLayer;
    LineSetLayer* _outLayer;
    TextSetView* _textView;
    UIScrollView* _scrollView;
    UIButton* enterBtn;
    UIButton* outBtn;
    UIButton* stopBtn;
    UIButton* selectDate;
    PullDownView* pullDownView;   ////类型选择
    UIDatePicker* timePicker; ///时间选择
    UIButton* searchBtn;  ///确定按钮
    
    int unitx;    ///每格单位
    int pageCount;     ////表格占几个屏幕
    
    CGFloat XMargin;
    CGFloat height ;
    CGFloat YMargin;
}
@property(nonatomic,retain)NSArray* enterDate;
@property(nonatomic,retain)NSArray* outDate;
@property(nonatomic,retain)NSArray* stopDate;


@end

@implementation ChartViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self castmDataInit];
    [self setleftBtntypeto:backType];
    [self setNavigationBarTitle:@"人数统计"];
    [self buildUI];
    [self updateData];
    _scrollView.contentOffset = CGPointZero;


    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateCurrentData];
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)castmDataInit{
    unitx = 20;
    pageCount = 4;

    XMargin = 0;
    height = 60;
    YMargin = 0;
}
-(void)updateCurrentData{
    NSString* time = [self getStringWithDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    [[InfomationCallBack defaultInfomationCallBack] webServerGetCurrentPersonStatsWithDeviceNum:_deviceId cid:_cid currentTime:time success:^(int enterCount, int outCount, int stopCount) {
        [enterBtn setTitle:[NSString stringWithFormat:@"%d",enterCount] forState:UIControlStateNormal];
        [outBtn setTitle:[NSString stringWithFormat:@"%d",outCount] forState:UIControlStateNormal];
        [stopBtn setTitle:[NSString stringWithFormat:@"%d",stopCount] forState:UIControlStateNormal];
        
    } failue:^(int errCode, NSString *errStr) {
        
    }];
}
-(void)updateWithType:(int)type beginTime:(NSString*)beginTime endTime:(NSString*)endTime{
    [[InfomationCallBack defaultInfomationCallBack] webServerGetPersonStatisticsWithDeviceNum:_deviceId cid:_cid type:type beginDate:beginTime endDate:endTime success:^(NSArray* result) {
 
        NSInteger maxValue = 0;
        
        /**
         *  /先找出最大值
         */
        for (NSDictionary* dic in result) {
            int kind = [dic[@"kpiId"] intValue];
            if (kind == 3) {
                break ;
            }
            NSDictionary* datas = dic[@"datas"];
            NSDictionary* dataList = datas[@"dataList"];
           
            for (NSString* time in dataList.allKeys) {
                
                int YValue = [dataList[time] intValue];
                if (YValue > maxValue) {
                    maxValue = YValue;
                }
            }
        }
        //根据最大值画坐标
        [_coordinateView.circularLayer clear];
        [_textView clear];
        //先赋值0避免重绘
        _coordinateView.MaxY = 0;
        _coordinateView.countY = 0;
        _coordinateView.unitY = 0;
        _coordinateView.MaxY = maxValue * 1.2;
        _coordinateView.countY = 5;
        _coordinateView.unitY = maxValue / (4.0 * _coordinateView.countY);
        switch (pullDownView.value) {
            case 1:
                [self drawTenMin];
                break;
            case 2:
                [self drawThirtyMin];
                break;
            case 3:
                [self drawSixtyMin];
                break;
                
            default:
                break;
        }
        
        
        int times = 0;  //标记只移动一次scrollview
        for (NSDictionary* dic in result) {
            NSMutableArray<NSValue*>* valueArry = [[NSMutableArray alloc]initWithCapacity:dic.count];
            int kind = [dic[@"kpiId"] intValue];
            if (kind == 3) {
                break ;
            }
            NSDictionary* datas = dic[@"datas"];
            NSDictionary* dataList = datas[@"dataList"];
            NSDateFormatter* formate = [[NSDateFormatter alloc]init];
            [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* date = [formate dateFromString:beginTime];
            NSTimeInterval interval = [date timeIntervalSince1970];
            
            NSDateFormatter* temFormate = [[NSDateFormatter alloc]init];
            [temFormate setDateFormat:@"yyyy-MM-dd HH:mm"];

           
            for (NSString* time in dataList.allKeys) {
                NSDate* temDate = [temFormate dateFromString:time];
                if (temDate == nil) {
                    continue;
                }
                NSTimeInterval lenthTime = [temDate timeIntervalSince1970];
                int XValue =(int)((lenthTime - interval)/60);
            
                int YValue = [dataList[time] intValue];
             
                CGPoint point = CGPointMake([_coordinateView getXWithValue:XValue], [_coordinateView getYWithValue:YValue]);
                //画字
                [_textView addTextWithPoint:point text:[NSString stringWithFormat:@"%d",YValue] textAlignment:TextAlignmentBotton];

                NSValue* value = [NSValue valueWithCGPoint:point];
                [valueArry addObject:value];
            }
            
            
            [valueArry sortUsingComparator: ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                CGPoint point1 = [(NSValue*)obj1 CGPointValue];
                CGPoint point2 = [(NSValue*)obj2 CGPointValue];
                return point1.x > point2.x;
            }];
            
            //得到第一个不为0的数据 ,times用于只移动一次
            if (times == 0) {
                times ++;
                for (NSValue* value in valueArry) {
                    CGPoint point = [value CGPointValue];
                    CGFloat y = [_coordinateView getValueWithY:point.y];
                    if (y > 0.1) {
                        _scrollView.contentOffset = CGPointMake(point.x, 0);
                        break;
                    }
                    
                }
            }
            
          
           
            [_coordinateView.circularLayer addCircularWithPoints:valueArry];

            switch (kind) {
                case 1: ///进入客流
                {
                    self.enterDate = valueArry;
                }
                    break;
                case 2: ///出客流
                {
                     self.outDate = valueArry;
                }
                    break;
                case 3: ///滞留
                {
//                    self.stopDate = valueArry;
                }
                    break;
                default:
                    break;
            }
            
        }
        
    } failue:^(int errCode, NSString *errStr) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"提示" message:errStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [view show];
        
    }];
}
-(void)setEnterDate:(NSArray *)enterDate{
    _enterDate = enterDate;
    [_enterLayer clear];
    [_enterLayer addLinesWithPoints:enterDate];
}
-(void)setOutDate:(NSArray *)outDate{
    _outDate = outDate;
    [_outLayer clear];
    [_outLayer addLinesWithPoints:outDate];
}
-(void)setStopDate:(NSArray *)stopDate{
    _stopDate = stopDate;
    [_coordinateView.lineLayer clear];
    [_coordinateView.lineLayer addLinesWithPoints:stopDate];
}

-(void)buildUI{
    [self buildTopUI];
    [self initCoordinateUI];
    [self initDatePinckerUI];
}
-(void)buildTopUI{

    UIImage* img = [UIImage imageNamed:@"ckxtb"];///
    CGRect rect = CGRectMake(0, 66, (SCREEN_WIDTH - 2 * XMargin)/3.0, height);
    enterBtn = [[UIButton alloc]initWithFrame:rect];
    enterBtn.backgroundColor = [UIColor whiteColor];
    [enterBtn setImage:img forState:UIControlStateNormal];
    [enterBtn setTitle:@"---" forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CGRect rect0 = enterBtn.imageView.bounds;
    rect0.origin.y = rect0.size.height;
    UILabel* lab0 = [[UILabel alloc]initWithFrame:rect0];
    lab0.textAlignment = NSTextAlignmentCenter;
    lab0.font = [UIFont systemFontOfSize:10];
    lab0.text = @"出客流";
    enterBtn.imageView.clipsToBounds = NO;
    [enterBtn.imageView addSubview:lab0];
    enterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [self.backgroundView addSubview:enterBtn];
    
    rect.origin.x = CGRectGetMaxX(rect) + XMargin;
    outBtn = [[UIButton alloc]initWithFrame:rect];
    [outBtn setBackgroundColor:[UIColor whiteColor]];
    img = [UIImage imageNamed:@"rkxtb"];///
    [outBtn setImage:img forState:UIControlStateNormal];
    [outBtn setTitle:@"--" forState:UIControlStateNormal];
    CGRect rect1 = outBtn.imageView.bounds;
    rect1.origin.y = rect1.size.height;
    
    UILabel* lab1 = [[UILabel alloc]initWithFrame:rect1];
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.font = [UIFont systemFontOfSize:10];
    lab1.text = @"入客流";
    outBtn.imageView.clipsToBounds = NO;
    [outBtn.imageView addSubview:lab1];
    outBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [outBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backgroundView addSubview:outBtn];
    
    rect.origin.x = CGRectGetMaxX(rect) + XMargin;
    stopBtn = [[UIButton alloc]initWithFrame:rect];
    [stopBtn setBackgroundColor:[UIColor whiteColor]];
    img = [UIImage imageNamed:@"rkxtb"];///
    [stopBtn setImage:img forState:UIControlStateNormal];
    [stopBtn setTitle:@"---" forState:UIControlStateNormal];
     rect1 = stopBtn.imageView.bounds;
    rect1.origin.y = rect1.size.height;
    
    lab1 = [[UILabel alloc]initWithFrame:rect1];
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.font = [UIFont systemFontOfSize:10];
    lab1.text = @"滞客流";
    stopBtn.imageView.clipsToBounds = NO;
    [stopBtn.imageView addSubview:lab1];
    stopBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);

    [stopBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backgroundView addSubview:stopBtn];
    
    NSString* title = @"查询日期:";
    UIFont *font = [UIFont systemFontOfSize:18];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:font}];
    rect.origin.y = CGRectGetMaxY(rect)+ YMargin;
    rect.size.width = size.width;
    rect.origin.x = 0;
    UILabel* lab = [[ UILabel alloc]initWithFrame:rect];
    lab.backgroundColor = [UIColor whiteColor];
    lab.font = font;
    lab.text = title;
    [self.backgroundView addSubview:lab];
    
    NSString* str = [self getStringWithDate:[NSDate date] format:@"yyyy-MM-dd"];
    font = [UIFont systemFontOfSize:14];
    size = [title sizeWithAttributes:@{NSFontAttributeName:font}];
    rect.origin.x = CGRectGetMaxX(rect) + XMargin;
    rect.size.width = SCREEN_WIDTH - rect.origin.x;
    selectDate = [[UIButton alloc]initWithFrame:rect];
    selectDate.backgroundColor = [UIColor whiteColor];
    [selectDate.titleLabel setFont:font];
    [selectDate setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [selectDate setTitle:str forState:UIControlStateNormal];
    [selectDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectDate addTarget:self action:@selector(dateSelectCheck:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:selectDate];
    
    title = @"时间间隔:";
    font = [UIFont systemFontOfSize:18];
    size= [ title sizeWithAttributes:@{NSFontAttributeName:font}];
    rect.origin.x = 0;
    rect.origin.y = CGRectGetMaxY(rect)+ YMargin;
    rect.size.width = size.width;
    UILabel* intervalLab = [[UILabel alloc]initWithFrame:rect];
    intervalLab.backgroundColor = [UIColor whiteColor];
    intervalLab.font = font;
    intervalLab.text = title;
    [self.backgroundView addSubview:intervalLab];
    
    rect.origin.x = CGRectGetMaxX(rect) + XMargin;
    title = [self getStringWithType:2];
    font = [UIFont systemFontOfSize:14];
    rect.size.width = 140;
    pullDownView = [[PullDownView alloc]initWithFrame:rect];
    [pullDownView setTitleFont:font];
    pullDownView.pullDownViewDelegate = self;
    pullDownView.itemsName = @[[self getStringWithType:1],[self getStringWithType:2],[self getStringWithType:3]];
    pullDownView.itemsTag = @[@1,@2,@3];
    [pullDownView setValue:3];
    pullDownView.titleColor = [UIColor redColor];
    [self.backgroundView addSubview:pullDownView];
    
    font = [UIFont systemFontOfSize:18];
    rect.origin.x = CGRectGetMaxX(rect) + XMargin;
    rect.size.width = SCREEN_WIDTH - rect.origin.x;
    searchBtn = [[UIButton alloc]initWithFrame:rect];
    [searchBtn setTitle:@"确定" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    searchBtn.tag = 2;  ///tag 表示时间间隔类型
    [searchBtn addTarget:self action:@selector(updateData) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    searchBtn.backgroundColor = [UIColor whiteColor];
    [searchBtn.titleLabel setFont:font];
    [searchBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    [self.backgroundView addSubview:searchBtn];
    
}


-(void)initCoordinateUI{
    
    CGRect rect = searchBtn.frame;
    rect.origin.y = CGRectGetMaxY(rect) + YMargin;
    rect.size.height = self.backgroundView.bounds.size.height - rect.origin.y;
    rect.size.width = self.backgroundView.bounds.size.width;
    rect.origin.x = 0;
    self.view.backgroundColor = [UIColor blackColor];
    _scrollView = [[UIScrollView alloc]initWithFrame:rect];
    _scrollView.backgroundColor = [UIColor colorWithRed:241/256.0 green:241/256.0 blue:241/256.0 alpha:1];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = false;
    

    
    _coordinateView = [[CoordinateView alloc]initWithFrame:_scrollView.bounds];
    _coordinateView.backgroundColor = [UIColor colorWithRed:241/256.0 green:241/256.0 blue:241/256.0 alpha:1];
    _coordinateView.lineLayer.color = [UIColor colorWithRed:138/256.0 green:138/256.0 blue:138/256.0 alpha:1];
    _coordinateView.color = [UIColor blackColor];
    _coordinateView.delegate = self;
    [_coordinateView.textView setFontColor:[UIColor whiteColor]];
    [self.backgroundView insertSubview:_scrollView atIndex:0];
    [_scrollView addSubview:_coordinateView];
    [self drawTenMin];
    //添加3条虚线
    lineLayer = [[LineSetLayer alloc]init];
    lineLayer.frame = _coordinateView.bounds;
    [_coordinateView.lineLayer addSublayer:lineLayer];
    
    
    ///滞留使用coordinateView自带，其他自定义
    _coordinateView.lineLayer.color = [UIColor purpleColor];
    _coordinateView.lineLayer.fillColor = [UIColor clearColor].CGColor;
    _coordinateView.textView.fontColor = [UIColor blackColor];
    _coordinateView.showYCoordinate = NO;
    
    _enterLayer = [[LineSetLayer alloc]init];
    [_coordinateView.layer addSublayer:_enterLayer];
    _enterLayer.frame = _coordinateView.layer.bounds;
    _enterLayer.color = [UIColor colorWithRed:221/255.0 green:71/255.0 blue:87/255.0 alpha:1];
    _enterLayer.fillColor = [UIColor clearColor].CGColor;
    
    
    _outLayer = [[LineSetLayer alloc]init];
    [_coordinateView.layer addSublayer:_outLayer];
    _outLayer.frame = _coordinateView.layer.bounds;
    _outLayer.color = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    _outLayer.fillColor = [UIColor clearColor].CGColor;
    
    /**
     提示线条
     */
    LineSetLayer * enterTipLayer = [[LineSetLayer alloc]init];
    [_coordinateView.layer addSublayer:enterTipLayer];
    enterTipLayer.color = [UIColor colorWithRed:221/255.0 green:71/255.0 blue:87/255.0 alpha:1];
    enterTipLayer.frame = _coordinateView.bounds;
    enterTipLayer.backgroundColor = [UIColor clearColor].CGColor;
    [enterTipLayer addLineFromPoint:CGPointMake(30, 20) toPoint:CGPointMake(50, 20)];
    
    LineSetLayer * outTipLayer = [[LineSetLayer alloc]init];
    [_coordinateView.layer addSublayer:outTipLayer];
    outTipLayer.color = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    outTipLayer.frame = _coordinateView.bounds;
    outTipLayer.backgroundColor = [UIColor clearColor].CGColor;
    [outTipLayer addLineFromPoint:CGPointMake(30, 40) toPoint:CGPointMake(50, 40)];
    /**
     提示文字
     */
    TextSetView* tipTextView = [[TextSetView alloc]init];
    [_coordinateView addSubview:tipTextView];
    tipTextView.frame = _coordinateView.bounds;
    tipTextView.backgroundColor = [UIColor clearColor];
    tipTextView.fontColor = [UIColor blackColor];
    [tipTextView addTextWithPoint:CGPointMake(80, 20) text:@"入客流" textAlignment:TextAlignmentCenter];
    [tipTextView addTextWithPoint:CGPointMake(80, 40) text:@"出客流" textAlignment:TextAlignmentCenter];


    
    
    
    _textView = [[TextSetView alloc]init];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.frame = _coordinateView.bounds;
    _textView.fontColor = [UIColor blackColor];
    [_coordinateView addSubview:_textView];
    
    
    
}
-(void)initDatePinckerUI{
    timePicker = [[UIDatePicker alloc]init];
    [self.backgroundView addSubview:timePicker];
    
    CGRect rect;
    rect.size.height = self.view.bounds.size.height * 0.3;
    rect.size.width = self.view.bounds.size.width;
    timePicker.alpha = 0.0;
    timePicker.frame = rect;
    timePicker.center = self.backgroundView.center;
    timePicker.backgroundColor = [UIColor whiteColor];
    timePicker.datePickerMode = UIDatePickerModeDate;
    [timePicker addTarget:self action:@selector(pickerValueChange:) forControlEvents:UIControlEventValueChanged];
}
-(void)pickerValueChange:(UIDatePicker*)picker{
    [self dateSelectCheck:selectDate];
    NSString* timeStr = [self getStringWithDate:timePicker.date format:@"yyyy-MM-dd"];
    [selectDate setTitle:timeStr forState:UIControlStateNormal];
}
-(void)dateSelectCheck:(UIButton*)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [UIView animateWithDuration:0.5 animations:^{
            timePicker.alpha = 1.;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            timePicker.alpha = 0.0;
        }];
    }
}
-(void)updateData{
    NSString* beginStr = [NSString stringWithFormat:@"%@ 00:00:00", selectDate.titleLabel.text];
    NSString* endStr = [NSString stringWithFormat:@"%@ 23:59:59", selectDate.titleLabel.text];
    int type = (int)pullDownView.value;
    [self updateWithType:type beginTime:beginStr endTime:endStr];
}
-(NSString*)getStringWithType:(int)type{
    NSString* str;
    switch (type) {
        case 1:
            str = @"10分钟";
            break;
        case 2:
            str = @"30分钟";
            break;
        case 3:
            str = @"1小时";
            break;
        case 4:
            str = @"1天";
            break;
        case 5:
            str = @"1周";
            break;
        case 6:
            str = @"1月";
            break;
        default:
            break;
    }
    return str;
}

-(void)drawSixtyMin{
    _coordinateView.MaxX = 1440;
    _coordinateView.unitX = unitx;
    _coordinateView.countX = 5;
    CGRect rect = _coordinateView.frame;
    rect.size.width = PAGE_TEN_SIXTY * SCREEN_WIDTH;
    _coordinateView.frame = rect;
    rect.size.height = 0;
    _scrollView.contentSize = rect.size;
    
    lineLayer.frame = _coordinateView.bounds;
    CGSize size = lineLayer.frame.size;
    CGFloat h = size.height / 3 - 10;
    [lineLayer setCapType:LineTypeDash];
    [lineLayer setColor:[UIColor grayColor]];
    [lineLayer addLineFromPoint:CGPointMake(0, h) toPoint:CGPointMake(size.width, h)];
    [lineLayer addLineFromPoint:CGPointMake(0, 2*h) toPoint:CGPointMake(size.width, 2*h)];
    [lineLayer addLineFromPoint:CGPointMake(0, 3*h) toPoint:CGPointMake(size.width, 3*h)];
}
-(void)drawThirtyMin{
    _coordinateView.MaxX = 1440;
    _coordinateView.unitX = unitx;
    _coordinateView.countX = 5;
    
    
    CGRect rect = _coordinateView.frame;
    rect.size.width = PAGE_COUNT_THIRTY * SCREEN_WIDTH;
    _coordinateView.frame = rect;
    rect.size.height = 0;
    _scrollView.contentSize = rect.size;
    
    lineLayer.frame = _coordinateView.bounds;
    CGSize size = lineLayer.frame.size;
    CGFloat h = size.height / 3 - 10;
    [lineLayer setCapType:LineTypeDash];
    [lineLayer setColor:[UIColor grayColor]];
    [lineLayer addLineFromPoint:CGPointMake(0, h) toPoint:CGPointMake(size.width, h)];
    [lineLayer addLineFromPoint:CGPointMake(0, 2*h) toPoint:CGPointMake(size.width, 2*h)];
    [lineLayer addLineFromPoint:CGPointMake(0, 3*h) toPoint:CGPointMake(size.width, 3*h)];
}
-(void)drawTenMin{
    _coordinateView.MaxX = 1440;
    _coordinateView.unitX = unitx;
    _coordinateView.countX = 5;
    CGRect rect = _coordinateView.frame;
    rect.size.width = PAGE_COUNT_TEN * SCREEN_WIDTH;
    _coordinateView.frame = rect;
    rect.size.height = 0;
    _scrollView.contentSize = rect.size;
    
    lineLayer.frame = _coordinateView.bounds;
    CGSize size = lineLayer.frame.size;
    CGFloat h = size.height / 3 - 10;
    [lineLayer setCapType:LineTypeDash];
    [lineLayer setColor:[UIColor grayColor]];
    [lineLayer addLineFromPoint:CGPointMake(0, h) toPoint:CGPointMake(size.width, h)];
    [lineLayer addLineFromPoint:CGPointMake(0, 2*h) toPoint:CGPointMake(size.width, 2*h)];
    [lineLayer addLineFromPoint:CGPointMake(0, 3*h) toPoint:CGPointMake(size.width, 3*h)];
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
-(NSString*)getStringWithDate:(NSDate*)date format:(NSString*)format{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
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
