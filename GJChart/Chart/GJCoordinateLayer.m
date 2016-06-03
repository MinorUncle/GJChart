//
//  CoordinateLayer.m
//  贝塞尔曲线
//
//  Created by 未成年大叔 on 16/2/10.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#define BIG_LINE_HEIGHT 10      //大标尺的高度
#define SMALL_LINE_HEIGHT 5   //小标尺高度
#define LEFT_PANNDINT 40      ////左边距
#define BOTTOM_PANNDING 20    ////下边距
#define ARROW_SIZE 5    ///箭头大小


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
@synthesize unitW = _unitW,unitH=_unitH;
- (instancetype)init
{
    self = [super init];
    if (self) {
        _arrowSize = ARROW_SIZE;
        _bigLineH = BIG_LINE_HEIGHT;
        _smallLineH = SMALL_LINE_HEIGHT;
        _contentInsets = UIEdgeInsetsMake(0, LEFT_PANNDINT, BOTTOM_PANNDING, 0);
        _path = [[UIBezierPath alloc]init];
        _xPath = [[UIBezierPath alloc]init];
        _yPath = [[UIBezierPath alloc]init];
        _showYCoordinate = YES;
        _showXCoordinate = YES;
        _countX = 5;
        _countY = 5;
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
    

    [self clear];
    [self updateXCoordinate];
    [self updateYCoordinate];
}
-(void)setMaxY:(CGFloat)MaxY{
    if (_MaxY == MaxY || MaxY == 0) {  ///防止重绘
        return;
    }
    _MaxY = MaxY;
    [self clear];
    [self updateYCoordinate];
    [self updateXCoordinate];}
-(void)setMinY:(CGFloat)MinY{
    if (_MinY == MinY) {  ///防止重绘
        return;
    }
    _MinY = MinY;
    [self clear];
    [self updateYCoordinate];
    [self updateXCoordinate];
}
-(void)setMaxX:(CGFloat)MaxX{
    if (_MaxX == MaxX || MaxX == 0) {  ///防止重绘
        return;
    }
    
    _MaxX = MaxX;
    [self clear];
    [self updateYCoordinate];
    [self updateXCoordinate];}
-(void)setMinX:(CGFloat)MinX{
    if (_MinX == MinX) {  ///防止重绘
        return;
    }
    
    _MinX = MinX;
    [self clear];
    [self updateYCoordinate];
    [self updateXCoordinate];}

-(void)setUnitX:(CGFloat)unitX{
    if (_unitX == unitX || unitX == 0) {  ///防止重绘
        return;
    }
    
    
    _unitX = unitX;
    if (_MaxX == 0) {return;}
    [self clear];
    [self updateXCoordinate];
    [self updateYCoordinate];

}
-(void)setUnitY:(CGFloat)unitY{
    if (_unitY == unitY || unitY == 0) {  ///防止重绘
        return;
    }
    
    _unitY = unitY;
    if (_MaxY == 0) {return;}
    [self clear];
    [self updateXCoordinate];
    [self updateYCoordinate];
}
-(void)setCountX:(uint)countX{
    if (_countX == countX || countX == 0) {  ///防止重绘
        return;
    }
    _countX = countX;
    [self clear];
    [self updateXCoordinate];
    [self updateYCoordinate];

}

-(CGFloat)unitW{
    _unitW = _unitX / (_MaxX - _MinX) * self.coordinateW;
    return _unitW;
}
-(CGFloat)unitH{
    _unitH = _unitY / (_MaxY-_MinY) * self.coordinateH;
    return _unitH;
}

-(void)setCountY:(uint)countY{
    if (_countY == countY || countY == 0) {  ///防止重绘
        return;
    }
    _countY = countY;
    [self clear];
    [self updateXCoordinate];
    [self updateYCoordinate];
}

-(void)setBigLineH:(CGFloat)bigLineH{
    _bigLineH = bigLineH;
    
}
-(void)setSmallLineH:(CGFloat)smallLineH{
    _smallLineH = smallLineH;
}
-(void)setArrowSize:(CGFloat)arrowSize{
    _arrowSize = arrowSize;
}

-(CGFloat)coordinateW{
    return self.bounds.size.width - _contentInsets.left - _contentInsets.right - _arrowSize;
}
-(CGFloat)coordinateH{
    return self.bounds.size.height - _contentInsets.top - _contentInsets.bottom - _arrowSize;
}
- (void)updateXCoordinate {
    if (!_unitX || !_countX || !self.unitW) {
        return;
    }

    [_xPath removeAllPoints];
    NSMutableDictionary* textDic = [[NSMutableDictionary alloc]init];
    CGPoint temPoint;
    [_xPath setLineWidth:50];
    ///x坐标
    CGPoint point = CGPointMake([self getXWithValue:_MinX],[self getYWithValue:0]);
    [_xPath moveToPoint:point];
    point.x = [self getXWithValue:_MaxX];
    [_xPath addLineToPoint:point];
    
   
    
    CGFloat sigUnitX ,upMax;
    if (_MaxX > _MinX) {
        sigUnitX = fabs( _unitX);
        upMax = _MaxX;
        
        temPoint = point;
        point.x -= _arrowSize;
        point.y -= _arrowSize;
        [_xPath addLineToPoint:point];
        point = temPoint;
        [_xPath moveToPoint:point];
        
        point.x -= _arrowSize;
        point.y += _arrowSize;
        [_xPath addLineToPoint:point];
    }else{
        sigUnitX = -fabs( _unitX);
        upMax = _MinX + (_MinX - _MaxX);
        
        point = CGPointMake([self getXWithValue:_MinX],[self getYWithValue:0]);
        [_xPath moveToPoint:point];
        temPoint = point;
        point.x += _arrowSize;
        point.y -= _arrowSize;
        [_xPath addLineToPoint:point];
        point = temPoint;
        [_xPath moveToPoint:point];
        
        point.x += _arrowSize;
        point.y += _arrowSize;
        [_xPath addLineToPoint:point];
    }
    
    CGFloat zY = [self getYWithValue:0];
    ///画x坐标尺
    for (int i=0; i * _unitX + _MinX<= upMax; i++) {
        point.x = [self getXWithValue:i * sigUnitX + _MinX];
        point.y = zY;
        [_xPath moveToPoint:point];

        if(i % _countX == 0){
            NSString* value;
            if ([self.coordinateDeleagte respondsToSelector:@selector(GJCoordinateLayer:titleWithXValue:)]){
                value = [self.coordinateDeleagte GJCoordinateLayer:self titleWithXValue:(i * sigUnitX +_MinX)];
            }else{
                value = [NSString stringWithFormat:@"%0.2f",(i * sigUnitX +_MinX)];
            }
            CGSize size = [value sizeWithAttributes: _textSetLayer.font == nil ? nil : @{NSFontAttributeName:_textSetLayer.font}];
            NSValue* key = [NSValue valueWithCGPoint:CGPointMake(point.x - size.width * 0.5, point.y + 2)];
            if(value != nil){
                [textDic setObject:value forKey:key];
            }
            point.y -= _bigLineH;
        }else{
            point.y -= _smallLineH;
        }
        [_xPath addLineToPoint:point];
    }
    
    [_textSetLayer addTextWithDic:textDic];
    NSLog(@"REDRAW XCOORDINATE IN FRAME:%@",[NSValue valueWithCGRect:self.frame]);
    [self drawCoordinate];
}
- (void)updateYCoordinate {
    if (!_unitY || !_countY  || !self.unitH) {
        return;
    }

    [_yPath removeAllPoints];
    NSMutableDictionary* textDic = [[NSMutableDictionary alloc]init];
    CGPoint temPoint;
    [_yPath setLineWidth:50];
    ///Y坐标
    CGPoint point = CGPointMake([self getXWithValue:0],[self getYWithValue:_MinY]);
    [_yPath moveToPoint:point];
    point.y = [self getYWithValue:_MaxY];
    [_yPath addLineToPoint:point];
    
    CGFloat sigUnitY ,upMax;
    if (_MaxY > _MinY) {
        sigUnitY = fabs( _unitY);
        upMax = _MaxY;
        
        temPoint = point;
        point.x -= _arrowSize;
        point.y += _arrowSize;
        [_yPath addLineToPoint:point];
        [_yPath moveToPoint: temPoint];
        
        point = temPoint;
        point.x += _arrowSize;
        point.y += _arrowSize;
        [_yPath addLineToPoint:point];
    }else{
        sigUnitY = -fabs( _unitY);
        upMax = _MinY + (_MinY - _MaxY);
        
        point = CGPointMake([self getXWithValue:0],[self getYWithValue:_MinY]);
        [_yPath moveToPoint:point];
        temPoint = point;
        point.x -= _arrowSize;
        point.y -= _arrowSize;
        [_yPath addLineToPoint:point];
        [_yPath moveToPoint: temPoint];
        
        point = temPoint;
        point.x += _arrowSize;
        point.y -= _arrowSize;
        [_yPath addLineToPoint:point];
    }
    
    //画y坐标
    CGFloat zX =  [self getXWithValue:0];
    for (int i=0; i * _unitY + _MinY <= upMax; i++) {
        point.x = zX;
        point.y = [self getYWithValue:i * sigUnitY + _MinY];
        [_yPath moveToPoint:point];
        if(i % _countY == 0){
            NSString* value;
            if ([self.delegate respondsToSelector:@selector(GJCoordinateLayer:titleWithYValue:)]){
                value = [self.delegate GJCoordinateLayer:self titleWithYValue:(i * sigUnitY + _MinY)];
            }else{
                value = [NSString stringWithFormat:@"%d",(int)(i * sigUnitY + _MinY)];
            }
            CGSize size = [value sizeWithAttributes: _textSetLayer.font == nil ? nil : @{NSFontAttributeName:_textSetLayer.font}];
            NSValue* key = [NSValue valueWithCGPoint:CGPointMake(point.x - size.width -2, point.y - size.height*0.5)];
            if (value != nil) {
                [textDic setObject:value forKey:key];
            }
            
            point.x += _bigLineH;
        }else{
            point.x += _smallLineH;
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

-(CGFloat)getXWithValue:(CGFloat)value{
    if(_unitX == 0 ){
        return 0;
    }
    value = ((value - _MinX)  / _unitX) * self.unitW + _contentInsets.left;
    return value;
}
-(CGFloat)getYWithValue:(CGFloat)value{
    if(_unitY == 0 ){
        return 0;
    }
    value = (value - _MinY) / _unitY * self.unitH;
    value = self.frame.size.height - _contentInsets.bottom - value;
    return value;
}
-(CGFloat)getValueWithY:(CGFloat)Y{
    return (self.frame.size.height - _contentInsets.bottom - Y) / self.unitH * _unitY + _MinY;
}
-(CGFloat)getValueWithX:(CGFloat)X{
    return (X-_contentInsets.left) / self.unitW * _unitX + _MinX;
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
