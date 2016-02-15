//
//  CoordinateLayer.m
//  贝塞尔曲线
//
//  Created by 未成年大叔 on 16/2/10.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#define BIG_LINE_HEIGHT 10      //大标尺的高度
#define SMALL_LINE_HEIGHT 5   //小标尺高度
#define LEFT_PANNDINT 30      ////左边距
#define BOTTOM_PANNDING 20    ////下边距
#define ARROW_SIZE 5    ///箭头大小
#define POINT_SIZE 5    //点大小


#import "GJCoordinateLayer.h"
#import <UIKit/UIBezierPath.h>
#import <UIKit/UIColor.h>
#import "GJTextSetLayer.h"
@interface GJCoordinateLayer()
{
  
    
    GJTextSetLayer* _textSetLayer;
    UIBezierPath* _path;
    UIBezierPath* _xPath;
    UIBezierPath* _yPath;

}

@end
@implementation GJCoordinateLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        _path = [[UIBezierPath alloc]init];
        _xPath = [[UIBezierPath alloc]init];
        _yPath = [[UIBezierPath alloc]init];

        self.backgroundColor = [UIColor greenColor].CGColor;
        self.strokeColor = [UIColor colorWithRed:138/256.0 green:138/256.0 blue:138/256.0 alpha:1].CGColor;
        
        self.fillColor = [UIColor clearColor].CGColor;
        self.lineWidth = 1;
        
        _textSetLayer = [[GJTextSetLayer alloc]init];
        [self addSublayer:_textSetLayer];
        

    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _textSetLayer.frame = self.bounds;

    if (_MaxX == 0 || _MaxY == 0) {
        return;
    }
    
    _unitW = _unitX / _MaxX * self.coordinateW;
    _unitH = _unitY / _MaxY * self.coordinateH;
    [self clear];
    [self updateXCoordinate];
    [self updateYCoordinate];

    
}
-(void)setMaxY:(CGFloat)MaxY{
    if (_MaxY == MaxY || MaxY == 0) {  ///防止重绘
        return;
    }
    _MaxY = MaxY;
    _unitH = _unitY / _MaxY * self.coordinateH;
    [self clear];
    [self updateYCoordinate];
}
-(void)setMaxX:(CGFloat)MaxX{
    if (_MaxX == MaxX || MaxX == 0) {  ///防止重绘
        return;
    }
    
    _MaxX = MaxX;
    _unitW = _unitX / _MaxX * self.coordinateW;
    [self clear];
    [self updateXCoordinate];
}

-(void)setUnitX:(CGFloat)unitX{
    if (_unitX == unitX || unitX == 0) {  ///防止重绘
        return;
    }
    
    _unitX = unitX;
    if (_MaxX == 0) {return;}
    _unitW = _unitX / _MaxX * self.coordinateW;
    [self clear];
    [self updateXCoordinate];
}
-(void)setUnitY:(CGFloat)unitY{
    if (_unitY == unitY || unitY == 0) {  ///防止重绘
        return;
    }
    
    _unitY = unitY;
    if (_MaxY == 0) {return;}
    _unitH = _unitY / _MaxY * self.coordinateH;
    [self clear];
    [self updateYCoordinate];
}
-(void)setCountX:(NSInteger)countX{
    if (_countX == countX || countX == 0) {  ///防止重绘
        return;
    }
    _countX = countX;
    [self clear];
    [self updateXCoordinate];
}
-(void)setCountY:(NSInteger)countY{
    if (_countY == countY || countY == 0) {  ///防止重绘
        return;
    }
    _countY = countY;
    [self clear];
    [self updateYCoordinate];
}

-(CGFloat)coordinateW{
    return self.bounds.size.width - 2*LEFT_PANNDINT - ARROW_SIZE;
}
-(CGFloat)coordinateH{
    return self.bounds.size.height - 2*BOTTOM_PANNDING - ARROW_SIZE;
}
- (void)updateXCoordinate {
    if (!_unitX || !_MaxX || !_countX || !_unitW) {
        return;
    }
    [_xPath removeAllPoints];
    NSMutableDictionary* textDic = [[NSMutableDictionary alloc]init];
    CGPoint temPoint;
    CGSize size = self.bounds.size;
    [_xPath setLineWidth:50];
    ///x坐标
    CGPoint point = CGPointMake(LEFT_PANNDINT,size.height - BOTTOM_PANNDING);
    [_xPath moveToPoint:point];
    point.x = size.width - LEFT_PANNDINT;
    [_xPath addLineToPoint:point];
    
    temPoint = point;
    point.x -= ARROW_SIZE;
    point.y -= ARROW_SIZE;
    [_xPath addLineToPoint:point];
    point = temPoint;
    [_xPath moveToPoint:point];
    
    point.x -= ARROW_SIZE;
    point.y += ARROW_SIZE;
    [_xPath addLineToPoint:point];
    
    
    ///画x坐标尺
    for (int i=0; i * _unitX <= _MaxX; i++) {
        point.x = LEFT_PANNDINT + _unitW * i;
        point.y = size.height - BOTTOM_PANNDING;
        [_xPath moveToPoint:point];
        
        if(i % _countX == 0){
            NSString* value;
            if ([self.delegate respondsToSelector:@selector(GJCoordinateLayer:titleWithXValue:)]){
                value = [self.delegate GJCoordinateLayer:self titleWithXValue:(i * _unitX)];
            }else{
                value = [NSString stringWithFormat:@"%d",(int)(i * _unitX)];
            }
            CGSize size = [value sizeWithAttributes: _textSetLayer.font == nil ? nil : @{NSFontAttributeName:_textSetLayer.font}];
            NSValue* key = [NSValue valueWithCGPoint:CGPointMake(point.x - size.width * 0.5, point.y + 2)];
            [textDic setObject:value forKey:key];
            point.y -= BIG_LINE_HEIGHT;
        }else{
            point.y -= SMALL_LINE_HEIGHT;
        }
        [_xPath addLineToPoint:point];
    }
    
    [_textSetLayer addTextWithDic:textDic];
    NSLog(@"REDRAW XCOORDINATE IN FRAME:%@",[NSValue valueWithCGRect:self.frame]);
    [self drawCoordinate];
}
- (void)updateYCoordinate {
    if (!_unitY || !_MaxY || !_countY  || !_unitH) {
        return;
    }
    [_yPath removeAllPoints];
    NSMutableDictionary* textDic = [[NSMutableDictionary alloc]init];
    CGPoint temPoint;
    CGSize size = self.bounds.size;
    [_yPath setLineWidth:50];
    ///Y坐标
    CGPoint point = CGPointMake(LEFT_PANNDINT,size.height - BOTTOM_PANNDING);
    [_yPath moveToPoint:point];
    point.y = BOTTOM_PANNDING;
    [_yPath addLineToPoint:point];
    
    temPoint = point;
    point.x -= ARROW_SIZE;
    point.y += ARROW_SIZE;
    [_yPath addLineToPoint:point];
    [_yPath moveToPoint: temPoint];
    
    point = temPoint;
    point.x += ARROW_SIZE;
    point.y += ARROW_SIZE;
    [_yPath addLineToPoint:point];
    
    //画y坐标
    for (int i=1; i * _unitY <= _MaxY; i++) {
        point.x = LEFT_PANNDINT;
        point.y = size.height - BOTTOM_PANNDING - _unitH * i;
        [_yPath moveToPoint:point];
        
        if(i % _countY == 0){
            NSString* value;
            if ([self.delegate respondsToSelector:@selector(GJCoordinateLayer:titleWithYValue:)]){
                value = [self.delegate GJCoordinateLayer:self titleWithYValue:(i * _unitY)];
            }else{
                value = [NSString stringWithFormat:@"%d",(int)(i * _unitY)];
            }
            CGSize size = [value sizeWithAttributes: _textSetLayer.font == nil ? nil : @{NSFontAttributeName:_textSetLayer.font}];
            NSValue* key = [NSValue valueWithCGPoint:CGPointMake(point.x - size.width -2, point.y - size.height*0.5)];
            [textDic setObject:value forKey:key];
            
            point.x += BIG_LINE_HEIGHT;
        }else{
            point.x += SMALL_LINE_HEIGHT;
        }
        [_yPath addLineToPoint:point];
        
    }
    
    [_textSetLayer addTextWithDic:textDic];
    NSLog(@"REDRAW YCOORDINATE IN FRAME:%@",[NSValue valueWithCGRect:self.frame]);

    [self drawCoordinate];
}
- (void)drawCoordinate {
    [_path removeAllPoints];
    if (_showXCoordinate) {
        [_path appendPath:_xPath];
    }
    
    if (_showYCoordinate) {
        [_path appendPath:_yPath];
    }
    [_path moveToPoint:[self getPointWithValue:CGPointZero]];
    self.path = _path.CGPath;
    
}

-(CGFloat)getXWithValue:(int)value{
    if(_unitX == 0 ){
        return 0;
    }
    value = (value / _unitX) * _unitW + LEFT_PANNDINT;
    return value;
}
-(CGFloat)getYWithValue:(int)value{
    if(_unitY == 0 ){
        return 0;
    }
    value = value / _unitY * _unitH;
    value = self.frame.size.height - BOTTOM_PANNDING - value;
    return value;
}
-(CGFloat)getValueWithY:(CGFloat)Y{
    return (self.frame.size.height - BOTTOM_PANNDING - Y) / _unitH * _unitY;
}

-(CGPoint)getPointWithValue:(CGPoint)value{
    
    value.x = [self getXWithValue:value.x];
    value.y = [self getYWithValue:value.y];
    return value;
}
-(void)clear{
    [_textSetLayer clear];
    [_path removeAllPoints];
    self.path = _path.CGPath;
}


@end
