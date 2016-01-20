//
//  CoordinateView.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/5.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#define BIG_LINE_HEIGHT 10      //大标尺的高度
#define SMALL_LINE_HEIGHT 5   //小标尺高度
#define LEFT_PANNDINT 20      ////左边距
#define BOTTOM_PANNDING 20    ////下边距
#define ARROW_SIZE 5    ///箭头大小
#define POINT_SIZE 5    //点大小
#import "CoordinateView.h"


@interface CoordinateView()
{
    CAShapeLayer* _shaperLayer;
    UIBezierPath* _path;

    CGFloat unitW ;
    CGFloat unitH ;
}
@property(nonatomic,assign,readonly)CGFloat coordinateW;   ///坐标轴可用宽度，，
@property(nonatomic,assign,readonly)CGFloat coordinateH;

@end
@implementation CoordinateView
-(void)drawRect:(CGRect)rect{
    [self drawText];
}
-(void)drawText{
    
    
}
- (instancetype)init
{
    

    self = [super init];
    if (self) {
        _MaxX = 100;
        _MaxY = 100;
        _unitX = 5;
        _unitY = 5;
        _countX = 5;
        _countY = 5;
        _beginValue = CGPointMake(0, 0);
        _speed = 0.01;
       
        
        ////背景方块条
        _squareLayer = [[SquareLayer alloc]init];
        _squareLayer.frame = self.layer.bounds;
        [self.layer addSublayer:_squareLayer];

        ////坐标轴，
        _shaperLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_shaperLayer];
        _shaperLayer.frame = self.layer.bounds;
        [self initShaperLayer];
        _circularLayer = [[PointCircularLayer alloc]init];
        _circularLayer.frame = self.layer.bounds;
        [self.layer addSublayer:_circularLayer];
        
        /////文字
        _textView = [[PointTextView alloc]init];
        _textView.backgroundColor = [UIColor clearColor];
        [self addSubview:_textView];
        
        
       
       
    }
    return self;
}
-(void)initShaperLayer{
    _shaperLayer.strokeColor = [UIColor yellowColor].CGColor;
    _shaperLayer.fillColor = [UIColor clearColor].CGColor;
    _shaperLayer.lineWidth = 1;
    _path = [UIBezierPath bezierPath];
    _shaperLayer.path = _path.CGPath;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _shaperLayer.frame = self.bounds;
    unitW = _unitX / _MaxX * self.coordinateW;
    unitH = _unitY / _MaxY * self.coordinateH;
    [self drawCoordinate];
    
    _textView.frame = self.bounds;
    _circularLayer.frame = self.layer.bounds;
    _squareLayer.frame = self.layer.bounds;
}
-(CGFloat)coordinateW{
    return self.bounds.size.width - 2*LEFT_PANNDINT - ARROW_SIZE;
}
-(CGFloat)coordinateH{
    return self.bounds.size.height - 2*BOTTOM_PANNDING - ARROW_SIZE;
}
- (void)drawXCoordinate {
    NSMutableDictionary* textDic = [[NSMutableDictionary alloc]init];
    CGPoint temPoint;
    CGSize size = _shaperLayer.bounds.size;
    [_path setLineWidth:50];
    ///x坐标
    CGPoint point = CGPointMake(LEFT_PANNDINT,size.height - BOTTOM_PANNDING);
    [_path moveToPoint:point];
    point.x = size.width - LEFT_PANNDINT;
    [_path addLineToPoint:point];
    
    temPoint = point;
    point.x -= ARROW_SIZE;
    point.y -= ARROW_SIZE;
    [_path addLineToPoint:point];
    point = temPoint;
    [_path moveToPoint:point];
    
    point.x -= ARROW_SIZE;
    point.y += ARROW_SIZE;
    [_path addLineToPoint:point];
    
    
    ///画x坐标尺
    for (int i=1; i * _unitX < _MaxX; i++) {
        point.x = LEFT_PANNDINT + unitW * i;
        point.y = size.height - BOTTOM_PANNDING;
        [_path moveToPoint:point];
        
        if(i % _countX == 0){
            NSString* value = [NSString stringWithFormat:@"%d",(int)(i * _unitX)];
            CGSize size = [value sizeWithAttributes:nil];
            NSValue* key = [NSValue valueWithCGPoint:CGPointMake(point.x - size.width * 0.5, point.y + 2)];
            [textDic setObject:value forKey:key];
            point.y -= BIG_LINE_HEIGHT;
        }else{
            point.y -= SMALL_LINE_HEIGHT;
        }
        [_path addLineToPoint:point];
    }
    
    [_textView addTextWithDic:textDic];
}
- (void)drawYCoordinate {
    NSMutableDictionary* textDic = [[NSMutableDictionary alloc]init];
    CGPoint temPoint;
    CGSize size = _shaperLayer.bounds.size;
    [_path setLineWidth:50];
    ///Y坐标
    CGPoint point = CGPointMake(LEFT_PANNDINT,size.height - BOTTOM_PANNDING);
    [_path moveToPoint:point];
    point.y = BOTTOM_PANNDING;
    [_path addLineToPoint:point];
    
    temPoint = point;
    point.x -= ARROW_SIZE;
    point.y += ARROW_SIZE;
    [_path addLineToPoint:point];
    [_path moveToPoint: temPoint];
    
    point = temPoint;
    point.x += ARROW_SIZE;
    point.y += ARROW_SIZE;
    [_path addLineToPoint:point];
    
    //画y坐标
    for (int i=1; i * _unitY < _MaxY; i++) {
        point.x = LEFT_PANNDINT;
        point.y = size.height - BOTTOM_PANNDING - unitH * i;
        [_path moveToPoint:point];
        
        if(i % _countY == 0){
            NSString* value = [NSString stringWithFormat:@"%d",(int)(i * _unitY)];
            CGSize size = [value sizeWithAttributes:nil];
            NSValue* key = [NSValue valueWithCGPoint:CGPointMake(point.x - size.width -2, point.y - size.height*0.5)];
            [textDic setObject:value forKey:key];
            
            point.x += BIG_LINE_HEIGHT;
        }else{
            point.x += SMALL_LINE_HEIGHT;
        }
        [_path addLineToPoint:point];
        
    }
    
    [_textView addTextWithDic:textDic];

}
- (void)drawCoordinate {
    [self drawXCoordinate];
    [self drawYCoordinate];
    [_path moveToPoint:[self getPointWithValue:CGPointZero]];
    _shaperLayer.path = _path.CGPath;
   
}
-(void)addValue:(CGPoint)value{
    
//    CGFloat timeLenth = sqrtf(value.x * value.x + value.y * value.y);
    CGPoint point =[self getPointWithValue:value];
    [_path addLineToPoint:point];
    [_circularLayer addCircularToPoint:point];

    CABasicAnimation* anima = [CABasicAnimation animationWithKeyPath:@"path"];

    [_shaperLayer addAnimation:anima forKey:nil];
    _shaperLayer.path = _path.CGPath;
    
    
    NSString* str = [NSString stringWithFormat:@"%d",(int)value.y];
    CGSize size = [str sizeWithAttributes: _textView.font ? @{NSFontAttributeName:_textView.font}:nil];
    point.y -= size.height + 2;
    point.x -= size.width * 0.5;
    NSDictionary* dic = @{[NSValue valueWithCGPoint:point]:str};
    [_textView addTextWithDic:dic];
    
   
//    [_path addLineToPoint:[self getPointWithValue:value]];
//    [UIView animateWithDuration:1 animations:^(void){
//        _shaperLayer.path = _path.CGPath;
//
//    }];
}


-(void)addSquareWithValueRect:(CGRect)valueRect color:(UIColor *)color style:(UIEdgeInsets)style{
    valueRect.origin.x = [self getXWithValue:valueRect.origin.x];
    valueRect.origin.y = [self getYWithValue:valueRect.origin.y];
    valueRect.size.width *= (unitW / _unitX);
    valueRect.size.height *= -(unitH / _unitY);
    
    ///坐标系转换
    CGFloat top = style.top;
    style.top = style.bottom;
    style.bottom = top;
    [_squareLayer addSquareWithRect:valueRect color:color style:style];
}
-(void)beginWithValue:(CGPoint)value{
    CGPoint point = [self getPointWithValue:value];
    [_circularLayer addCircularToPoint:point];
}


-(CGPoint)getPointWithValue:(CGPoint)value{
    
    value.x = [self getXWithValue:value.x];
    value.y = [self getYWithValue:value.y];
    return value;
}
-(CGFloat)getXWithValue:(int)value{
    if(_unitX == 0 ){
        return 0;
    }
    value = value / _unitX * unitW + LEFT_PANNDINT;
    return value;
}
-(CGFloat)getYWithValue:(int)value{
    if(_unitY == 0 ){
        return 0;
    }
    value = value / _unitY * unitH;
    value = _shaperLayer.frame.size.height - BOTTOM_PANNDING - value;
    return value;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //////测试
    CGFloat x= arc4random()%100;
    CGFloat y = arc4random() %100;
    [self addValue:CGPointMake(x, y)];
    
    //    CGFloat width = fabsf(arc4random()%100 - x);
    //    CGFloat height =fabsf(arc4random()%100 - y);
    //    [view addSquareWithValueRect:CGRectMake(-10, 10, 200, 0) color:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5] style:UIEdgeInsetsMake(SquareLayerDash, SquareLayerNone, SquareLayerSolid, SquareLayerNone)];
}


@end
