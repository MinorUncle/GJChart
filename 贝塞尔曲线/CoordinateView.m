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
       

        _shaperLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_shaperLayer];
        _shaperLayer.frame = self.layer.bounds;
        [self initShaperLayer];
       
    }
    return self;
}
-(void)initShaperLayer{
    _shaperLayer.strokeColor = [UIColor yellowColor].CGColor;
    _shaperLayer.fillColor = [UIColor clearColor].CGColor;
    _shaperLayer.lineWidth = 1;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _shaperLayer.frame = self.bounds;
    unitW = _unitX / _MaxX * self.coordinateW;
    unitH = _unitY / _MaxY * self.coordinateH;
    [self drawCoordinate];
    
}
-(CGFloat)coordinateW{
    return self.bounds.size.width - 2*LEFT_PANNDINT - ARROW_SIZE;
}
-(CGFloat)coordinateH{
    return self.bounds.size.height - 2*BOTTOM_PANNDING - ARROW_SIZE;
}
- (void)drawCoordinate {
    CGPoint temPoint;
    CGSize size = _shaperLayer.bounds.size;
    UIBezierPath* path = [UIBezierPath bezierPath];
    ///x坐标
    CGPoint point = CGPointMake(LEFT_PANNDINT,size.height - BOTTOM_PANNDING);
    [path moveToPoint:point];
    point.x = size.width - LEFT_PANNDINT;
    [path addLineToPoint:point];
    
    temPoint = point;
    point.x -= ARROW_SIZE;
    point.y -= ARROW_SIZE;
    [path addLineToPoint:point];
    point = temPoint;
    [path moveToPoint:point];
    
    point.x -= ARROW_SIZE;
    point.y += ARROW_SIZE;
    [path addLineToPoint:point];
    
    ///y
    point = CGPointMake(LEFT_PANNDINT,size.height - BOTTOM_PANNDING);
    [path moveToPoint:point];
    point.y = BOTTOM_PANNDING;
    [path addLineToPoint:point];
    
    temPoint = point;
    point.x -= ARROW_SIZE;
    point.y += ARROW_SIZE;
    [path addLineToPoint:point];
    [path moveToPoint: temPoint];
    
    point = temPoint;
    point.x += ARROW_SIZE;
    point.y += ARROW_SIZE;
    [path addLineToPoint:point];
    
    
///画x坐标尺
    for (int i=1; i * _unitX < _MaxX; i++) {
        point.x = LEFT_PANNDINT + unitW * i;
        point.y = size.height - BOTTOM_PANNDING;
        [path moveToPoint:point];
    
        if(i % _countX == 0){
            point.y -= BIG_LINE_HEIGHT;
            [@"8" drawAtPoint:point withAttributes:nil];
        }else{
            point.y -= SMALL_LINE_HEIGHT;
        }
        [path addLineToPoint:point];
        
    }
    
//画y坐标
    for (int i=1; i * _unitY < _MaxY; i++) {
        point.x = LEFT_PANNDINT;
        point.y = size.height - BOTTOM_PANNDING - unitH * i;
        [path moveToPoint:point];
        
        if(i % _countX == 0){
            point.x += BIG_LINE_HEIGHT;
        }else{
            point.x += SMALL_LINE_HEIGHT;
        }
        [path addLineToPoint:point];
        
    }
    [path moveToPoint:[self getPointWithValue:_beginValue]];
    _path = path;
    _shaperLayer.path = path.CGPath;
    
}
-(void)addValue:(CGPoint)value{
    
//    CGFloat timeLenth = sqrtf(value.x * value.x + value.y * value.y);
        [_path addLineToPoint:[self getPointWithValue:value]];

        CABasicAnimation* anima = [CABasicAnimation animationWithKeyPath:@"path"];
//    anima.duration = _speed * timeLenth;
    
        [_shaperLayer addAnimation:anima forKey:nil];
        _shaperLayer.path = _path.CGPath;
    
   
//    [_path addLineToPoint:[self getPointWithValue:value]];
//    [UIView animateWithDuration:1 animations:^(void){
//        _shaperLayer.path = _path.CGPath;
//
//    }];
}
-(CGPoint)getPointWithValue:(CGPoint)value{
    if(_unitX == 0 || _unitY == 0){
        return CGPointZero;
    }
    value.x = value.x / _unitX * unitW + LEFT_PANNDINT;
    value.y = value.y / _unitY * unitH;
    value.y = _shaperLayer.frame.size.height - BOTTOM_PANNDING - value.y;
    return value;
}


@end
