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
#define BOTTOM_PANNDING 60    ////下边距
#define ARROW_SIZE 5    ///箭头大小
#define POINT_SIZE 5    //点大小
#import "CoordinateView.h"


@interface CoordinateView()
{
    CAShapeLayer* _coordinateLayer;
    UIBezierPath* _path;

    CGFloat unitW ;
    CGFloat unitH ;
}
@property(nonatomic,assign,readonly)CGFloat coordinateW;   ///坐标轴可用宽度，，
@property(nonatomic,assign,readonly)CGFloat coordinateH;

@end
@implementation CoordinateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        _MaxX = 100;
//        _MaxY = 100;
//        _unitX = 5;
//        _unitY = 5;
//        _countX = 5;
//        _countY = 5;
        _speed = 0.01;
       
        _showYCoordinate = YES;
        
        ////背景方块条
        _squareLayer = [[SquareSetLayer alloc]init];
        [self.layer addSublayer:_squareLayer];

        ////坐标轴，
        _coordinateLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_coordinateLayer];
        [self initShaperLayer];
        
        //圆点
        _circularLayer = [[CircularPointSetLayer alloc]init];
        [self.layer addSublayer:_circularLayer];
        //线条
        _lineLayer = [[LineSetLayer alloc]init];
        [self.layer addSublayer:_lineLayer];
        /////文字
        _textView = [[TextSetView alloc]init];
        _textView.backgroundColor = [UIColor clearColor];
        [self addSubview:_textView];
        
        [self setFrame:self.frame];
        
        [_lineLayer beginWithPoint:[self getPointWithValue:CGPointZero]];

       
    }
    return self;
}
-(void)initShaperLayer{
    _coordinateLayer.strokeColor = [UIColor colorWithRed:138/256.0 green:138/256.0 blue:138/256.0 alpha:1].CGColor;

    _coordinateLayer.fillColor = [UIColor clearColor].CGColor;
    _coordinateLayer.lineWidth = 1;
    _path = [UIBezierPath bezierPath];
    _coordinateLayer.path = _path.CGPath;
}
-(void)setMaxY:(CGFloat)MaxY{
    if (_MaxY == MaxY) {  ///防止重绘
        return;
    }
    _MaxY = MaxY;
    if (_MaxY == 0) {return;}
    unitH = _unitY / _MaxY * self.coordinateH;
    [self clear];
    [self drawCoordinate];
}
-(void)setMaxX:(CGFloat)MaxX{
    if (_MaxX == MaxX) {  ///防止重绘
        return;
    }
    
    _MaxX = MaxX;
    if (_MaxX == 0) {return;}
    unitW = _unitX / _MaxX * self.coordinateW;
    [self clear];
    [self drawCoordinate];
}

-(void)setUnitX:(CGFloat)unitX{
    if (_unitX == unitX) {  ///防止重绘
        return;
    }
    
    _unitX = unitX;
    if (_MaxX == 0) {return;}
    unitW = _unitX / _MaxX * self.coordinateW;
    [self clear];
    [self drawCoordinate];
}
-(void)setUnitY:(CGFloat)unitY{
    if (_unitY == unitY) {  ///防止重绘
        return;
    }
    
    _unitY = unitY;
    if (_MaxY == 0) {return;}
    unitH = _unitY / _MaxY * self.coordinateH;
    [self clear];
    [self drawCoordinate];
}
-(void)clear{
    [_textView clear];
    [_lineLayer clear];
    [_path removeAllPoints];
    _coordinateLayer.path = _path.CGPath;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _coordinateLayer.frame = self.bounds;
    unitW = _unitX / _MaxX * self.coordinateW;
    unitH = _unitY / _MaxY * self.coordinateH;
    [_path removeAllPoints];
    [_textView clear];
    [self drawCoordinate];
    
    _textView.frame = self.bounds;
    _circularLayer.frame = self.layer.bounds;
    _squareLayer.frame = self.layer.bounds;
    _lineLayer.frame = self.layer.bounds;
}
-(CGFloat)coordinateW{
    return self.bounds.size.width - 2*LEFT_PANNDINT - ARROW_SIZE;
}
-(CGFloat)coordinateH{
    return self.bounds.size.height - 2*BOTTOM_PANNDING - ARROW_SIZE;
}
- (void)drawXCoordinate {
    if (!_unitX || !_MaxX || !_countX || !unitW) {
        return;
    }
    
    NSMutableDictionary* textDic = [[NSMutableDictionary alloc]init];
    CGPoint temPoint;
    CGSize size = _coordinateLayer.bounds.size;
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
    for (int i=1; i * _unitX <= _MaxX; i++) {
        point.x = LEFT_PANNDINT + unitW * i;
        point.y = size.height - BOTTOM_PANNDING;
        [_path moveToPoint:point];
        
        if(i % _countX == 0){
            NSString* value;
            if ([self.delegate respondsToSelector:@selector(CoordinateView:titleWithXValue:)]){
                value = [self.delegate CoordinateView:self titleWithXValue:(i * _unitX)];
            }else{
                value = [NSString stringWithFormat:@"%d",(int)(i * _unitX)];
            }
            CGSize size = [value sizeWithAttributes: _textView.font == nil ? nil : @{NSFontAttributeName:_textView.font}];
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
    if (!_unitY || !_MaxY || !_countY  || !unitH) {
        return;
    }
    NSMutableDictionary* textDic = [[NSMutableDictionary alloc]init];
    CGPoint temPoint;
    CGSize size = _coordinateLayer.bounds.size;
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
    for (int i=1; i * _unitY <= _MaxY; i++) {
        point.x = LEFT_PANNDINT;
        point.y = size.height - BOTTOM_PANNDING - unitH * i;
        [_path moveToPoint:point];
        
        if(i % _countY == 0){
            NSString* value;
            if ([self.delegate respondsToSelector:@selector(CoordinateView:titleWithYValue:)]){
                value = [self.delegate CoordinateView:self titleWithYValue:(i * _unitY)];
            }else{
                value = [NSString stringWithFormat:@"%d",(int)(i * _unitY)];
            }
            CGSize size = [value sizeWithAttributes: _textView.font == nil ? nil : @{NSFontAttributeName:_textView.font}];
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
    CGPoint zeroPoint = [self getPointWithValue:CGPointZero];
    NSString* value;
    if ([self.delegate respondsToSelector:@selector(CoordinateView:titleWithXValue:)]){
        value = [self.delegate CoordinateView:self titleWithXValue:(0)];
    }else{
        value = @"0";
    }
    [_textView addTextWithPoint:zeroPoint text:value textAlignment:TextAlignmentTop];
    [self drawXCoordinate];
    
    if (_showYCoordinate) {
        [self drawYCoordinate];
    }
    [_path moveToPoint:[self getPointWithValue:CGPointZero]];
    _coordinateLayer.path = _path.CGPath;
   
}
-(void)addValue:(CGPoint)value{
    
    CGPoint point =[self getPointWithValue:value];

    ///关闭动画
//    CABasicAnimation* anima = [CABasicAnimation animationWithKeyPath:@"path"];
//    [_lineLayer addAnimation:anima forKey:nil];
    [_lineLayer addLineToPoint:point];
    
    NSString* str;
    if([self.delegate respondsToSelector:@selector(CoordinateView:titleWithValue:)]){
        [self.delegate CoordinateView:self titleWithValue:value];
    }else{
        str = [NSString stringWithFormat:@"%d",(int)value.y];
    }
    [_textView addTextWithPoint:point text:str textAlignment:TextAlignmentBotton];
    [_circularLayer addCircularToPoint:point];

   
//    [_path addLineToPoint:[self getPointWithValue:value]];
//    [UIView animateWithDuration:1 animations:^(void){
//        _coordinateLayer.path = _path.CGPath;
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
    [_lineLayer beginWithPoint:point];
}

-(void)addValues:(NSArray<NSValue*>*)values{
    if (values.count < 1) {return;}
    
    CGPoint point = [values[0] CGPointValue];
    [self beginWithValue:point];
    for (int i = 1; i < values.count; i++) {
        point = [values[i] CGPointValue];
        [self addValue:point];
    }
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
    value = (value / _unitX) * unitW + LEFT_PANNDINT;
    return value;
}
-(CGFloat)getYWithValue:(int)value{
    if(_unitY == 0 ){
        return 0;
    }
    value = value / _unitY * unitH;
    value = _coordinateLayer.frame.size.height - BOTTOM_PANNDING - value;
    return value;
}
-(CGFloat)getValueWithY:(CGFloat)Y{
    return (_coordinateLayer.frame.size.height - BOTTOM_PANNDING - Y) / unitH * _unitY;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //////测试
    static CGFloat x = 0;
    x += arc4random()%50;
    CGFloat y = arc4random() %100;
    [self addValue:CGPointMake(x, y)];
    
    //    CGFloat width = fabsf(arc4random()%100 - x);
    //    CGFloat height =fabsf(arc4random()%100 - y);
    //    [view addSquareWithValueRect:CGRectMake(-10, 10, 200, 0) color:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5] style:UIEdgeInsetsMake(SquareLayerDash, SquareLayerNone, SquareLayerSolid, SquareLayerNone)];
}


@end
