 //
//  CoordinateView.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/5.
//  Copyright © 2016年 tongguan. All rights reserved.
//


#import "CoordinateView.h"


@interface CoordinateView()
{
    NSMutableArray* _sectionLayerArry;
}

@end
@implementation CoordinateView
+(Class)layerClass{
    return [CoordinateSystemLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _sectionLayerArry = [[NSMutableArray alloc]init];
        _squareWRate = 0.3;
        [self buildUI];
    }
    return self;
}
-(void)buildUI{
    _speed = 0.01;
    
    ////背景方块条
    
    
    _squareLayer = [[SquareSetLayer alloc]init];
    [self.layer addSublayer:_squareLayer];
    
    ////坐标轴，
    _coordinateLayer = (CoordinateSystemLayer*)self.layer;
    _coordinateLayer.showYCoordinate = YES;
    _coordinateLayer.showXCoordinate = YES;
    
    
    //圆点
    _circularLayer = [[CircularPointSetLayer alloc]init];
    [self.layer addSublayer:_circularLayer];
    //线条
    _lineLayer = [[LineSetLayer alloc]init];
    [self.layer addSublayer:_lineLayer];
    /////文字
    _textLayer = [[TextSetLayer alloc]init];
    _textLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_textLayer];
    
    [self setFrame:self.frame];
    
    [_lineLayer beginWithPoint:[self.coordinateLayer getPointWithValue:CGPointZero]];
}

-(void)buildSection{
    if (self.dataDelegate == nil || CGRectEqualToRect(self.bounds, CGRectZero)){
        return;
    }
    [_sectionLayerArry makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    NSInteger capacity = 1;
    if ([self.dataDelegate respondsToSelector:@selector(numberOfSectionsInCoordinateView:)]) {
        capacity = [self.dataDelegate numberOfSectionsInCoordinateView:self];
    }
    
    for (int i = 0; i < capacity; i++) {
        NSArray<NSValue*>* values = [self.dataDelegate CoordinateView:self dataForSection:i];
        
        CoordinateViewSectionType type = CoordinateViewSectionTypeLine;
        if ([self.dataDelegate respondsToSelector:@selector(CoordinateView:typeWithSection:)]) {
            type = [self.delegate CoordinateView:self typeWithSection:i];
        }
        
        /**
         *  字符内容layer
         */
        TextSetLayer* textSet = [[TextSetLayer alloc]init];
        textSet.frame = [self bounds];
        
        
        
        /**
         *  section Layer
         */
        CALayer* sectionLayer;
        switch (type) {
            case CoordinateViewSectionTypeLine:
            {
                LineSetLayer* lineSet = [[LineSetLayer alloc]init];
                if ([self.delegate respondsToSelector:@selector(CoordinateView:customTextLayerStlye:customSectionLayerStyle:inSection:)]) {
                    [self.delegate CoordinateView:self customTextLayerStlye:textSet customSectionLayerStyle:lineSet inSection:i];
                }
                
                [self setLineLayer:lineSet WithValues:values];

                
                sectionLayer = lineSet;
                break;
            }
            case CoordinateViewSectionTypeBar:{
                SquareSetLayer* squareLayer = [[SquareSetLayer alloc]init];
                if ([self.delegate respondsToSelector:@selector(CoordinateView:customTextLayerStlye:customSectionLayerStyle:inSection:)]) {
                    [self.delegate CoordinateView:self customTextLayerStlye:textSet customSectionLayerStyle:squareLayer inSection:i];
                }
                [self setSquareLayer:squareLayer WithValues:values];
                
                sectionLayer = squareLayer;
                break;
            }
                
            default:
                break;
        }
        sectionLayer.frame = self.bounds;
        [self.layer addSublayer:sectionLayer];
        [_sectionLayerArry addObject:sectionLayer];
        
        
        [self.layer addSublayer:textSet];
        [_sectionLayerArry addObject:textSet];
        
        if ([self.delegate respondsToSelector:@selector(CoordinateView:titleWithValue:)]) {
            for (NSValue* value in values) {
                NSString* titleName = [self.delegate CoordinateView:self titleWithValue:[value CGPointValue]];
                CGPoint point = [_coordinateLayer getPointWithValue:[value CGPointValue]];
                [textSet addTextWithPoint:point text:titleName textAlignment:TextAlignmentBotton];
            }
        }else{
            for (NSValue* value in values) {
                
                NSString* titleName = [NSString stringWithFormat:@"%d",(int)[value CGPointValue].y];
                CGPoint point = [_coordinateLayer getPointWithValue:[value CGPointValue]];
                [textSet addTextWithPoint:point text:titleName textAlignment:TextAlignmentBotton];            }
        }
        
        
    }
}
-(void)setLineLayer:(LineSetLayer*)lineSet WithValues:(NSArray<NSValue*>*)values{
    
    NSMutableArray* pointArry = [[NSMutableArray alloc]initWithCapacity:values.count];
    for (NSValue* value in values) {
        CGPoint point =[_coordinateLayer getPointWithValue:[value CGPointValue]];
        [pointArry addObject:[NSValue valueWithCGPoint:point]];
    }
    [lineSet addLinesWithPoints:pointArry];
}
-(void)setSquareLayer:(SquareSetLayer*)squareLayer WithValues:(NSArray<NSValue*>*)values{
    
    NSMutableArray* rectArry = [[NSMutableArray alloc]initWithCapacity:values.count];
    for (NSValue* value in values) {
        
        
        CGRect rect = [self getSquareRectWithValue:[value CGPointValue]];
        [rectArry addObject:[NSValue valueWithCGRect:rect]];
    }
    [squareLayer addSquareWithRects:rectArry];
}
-(CGRect)getSquareRectWithValue:(CGPoint)vaule{
    CGPoint point =[_coordinateLayer getPointWithValue:vaule];
    CGFloat bottom = [_coordinateLayer getYWithValue:0];
    CGFloat x = point.x - _coordinateLayer.unitW * _coordinateLayer.countX * _squareWRate * 0.5;
    CGFloat y = point.y;
    CGFloat w = _coordinateLayer.unitW * _coordinateLayer.countX * _squareWRate;
    CGFloat h = bottom - point.y;

    
    
    CGRect rect = CGRectMake(x, y, w, h);
    return rect;
}
-(void)setDelegate:(id<CoordinateViewDelegate>)delegate{
    _delegate = delegate;
    _coordinateLayer.delegate = delegate;
    [self buildSection];
}
-(void)setDataDelegate:(id<CoordinateViewDataSourceDelegate>)dataDelegate{
    _dataDelegate = dataDelegate;
    [self buildSection];
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [_textLayer clear];
    _textLayer.frame = self.bounds;
    _circularLayer.frame = self.bounds;
    _squareLayer.frame = self.bounds;
    _lineLayer.frame = self.bounds;
    [self buildSection];
    
  
}
-(void)addValue:(CGPoint)value{
    
    CGPoint point =[self.coordinateLayer getPointWithValue:value];

    ///关闭动画
//    CABasicAnimation* anima = [CABasicAnimation animationWithKeyPath:@"path"];
//    [_lineLayer addAnimation:anima forKey:nil];
    [_lineLayer addLineToPoint:point];
    
    NSString* str;
    if([self.delegate respondsToSelector:@selector(CoordinateView:titleWithValue:)]){
        str = [self.delegate CoordinateView:self titleWithValue:value];
    }else{
        str = [NSString stringWithFormat:@"%d",(int)value.y];
    }
    [_textLayer addTextWithPoint:point text:str textAlignment:TextAlignmentBotton];

   
//    [_path addLineToPoint:[self getPointWithValue:value]];
//    [UIView animateWithDuration:1 animations:^(void){
//        _coordinateLayer.path = _path.CGPath;
//
//    }];
}


-(void)addSquareWithValueRect:(CGRect)valueRect color:(UIColor *)color style:(UIEdgeInsets)style{
    valueRect.origin.x = [self.coordinateLayer getXWithValue:valueRect.origin.x];
    valueRect.origin.y = [self.coordinateLayer getYWithValue:valueRect.origin.y];
    valueRect.size.width = valueRect.size.width/ self.coordinateLayer.MaxX * self.coordinateLayer.coordinateW;
    valueRect.size.height = -(valueRect.size.height/ self.coordinateLayer.MaxY * self.coordinateLayer.coordinateH);
    
    ///坐标系转换
    CGFloat top = style.top;
    style.top = style.bottom;
    style.bottom = top;
   // [_squareLayer addSquareWithRect:valueRect color:color style:style];
}
-(void)beginWithValue:(CGPoint)value{
    CGPoint point = [self.coordinateLayer getPointWithValue:value];
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //////测试
    NSLog(@"VIEW TOUCH");
    static CGFloat x = 0;
    x += arc4random()%50;
    CGFloat y = arc4random() %100;
    [self addValue:CGPointMake(x, y)];
    
    //    CGFloat width = fabsf(arc4random()%100 - x);
    //    CGFloat height =fabsf(arc4random()%100 - y);
    //    [view addSquareWithValueRect:CGRectMake(-10, 10, 200, 0) color:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5] style:UIEdgeInsetsMake(SquareLayerDash, SquareLayerNone, SquareLayerSolid, SquareLayerNone)];
}


@end
