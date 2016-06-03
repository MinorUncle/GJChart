 //
//  GJChartView.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/5.
//  Copyright © 2016年 tongguan. All rights reserved.
//


#import "GJChartView.h"


@interface GJChartView()
{
    NSMutableArray* _sectionLayerArry;
}

@end
@implementation GJChartView
+(Class)layerClass{
    return [GJCoordinateLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _sectionLayerArry = [[NSMutableArray alloc]init];
        _squareWRate = 0.2;
        _tipViewWidth = 50;
        _tipViewHeight = 12;
        _autoResizeMax = YES;
        _autoResizeUnit = YES;
        _showBackgroundLine = YES;
        [self buildUI];
    }
    return self;
}
-(void)buildUI{
   // _speed = 0.01;
    
    ////背景方块条
    _squareLayer = [[GJSquareSetLayer alloc]init];
    [self.layer addSublayer:_squareLayer];
    
    ////坐标轴，
    _coordinateLayer = (GJCoordinateLayer*)self.layer;

    [self setFrame:self.frame];
    
}

-(void)buildSection{
    if (self.charDataDelegate == nil || CGRectEqualToRect(self.bounds, CGRectZero)){
        return;
    }
    if (self.autoResizeMax || self.autoResizeUnit) {
        [self analysisCoordinate];
    }
    [_sectionLayerArry makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [_sectionLayerArry removeAllObjects];
    NSInteger capacity = 0;
    if ([self.charDataDelegate respondsToSelector:@selector(numberOfSectionsInCoordinateView:)]) {
        capacity = [self.charDataDelegate numberOfSectionsInCoordinateView:self];
    }
    

    for (int i = 0; i < capacity; i++) {
        NSArray<NSValue*>* values = [self.charDataDelegate GJChartView:self dataForSection:i];
        CoordinateViewSectionType type = CoordinateViewSectionTypeLine;
        if ([self.charDelegate respondsToSelector:@selector(GJChartView:typeWithSection:)]) {
            type = [self.charDelegate GJChartView:self typeWithSection:i];
        }
        
        /**
         *  字符内容layer
         */
        GJTextSetLayer* textSet = [[GJTextSetLayer alloc]init];
        textSet.frame = [self bounds];
        
        
        
        /**
         *  section Layer
         */
        CALayer* sectionLayer;
        switch (type) {
            case CoordinateViewSectionTypeLine:
            {
                GJLineSetLayer* lineSet = [[GJLineSetLayer alloc]init];
                if ([self.charDelegate respondsToSelector:@selector(GJChartView:customTextLayerStlye:customSectionLayerStyle:inSection:)]) {
                    [self.charDelegate GJChartView:self customTextLayerStlye:textSet customSectionLayerStyle:lineSet inSection:i];
                }
                
                [self setLineLayer:lineSet WithValues:values];
                
                //tip
                if ([self.charDataDelegate respondsToSelector:@selector(GJChartView:tipTitleForSection:)]) {
                    NSString* title = [self.charDataDelegate GJChartView:self tipTitleForSection:i];
                    CGPoint point = CGPointMake([_coordinateLayer getXWithValue:0]+MAX(_coordinateLayer.bigLineH, _coordinateLayer.arrowSize)+10, [_coordinateLayer getYWithValue:_coordinateLayer.MaxY] + self.tipViewHeight*(i+0.5));
                    [lineSet beginWithPoint:point];
                    point.x += self.tipViewWidth*0.5;
                    [lineSet addLineToPoint:point];
                    point.x += self.tipViewWidth*0.5;
                    [lineSet endWithPoint:point];
                    [textSet addTextWithPoint:point text:title textAlignment:TextAlignmentLeft];
                }
                
                sectionLayer = lineSet;
                break;
            }
            case CoordinateViewSectionTypeBar:{
                GJSquareSetLayer* squareLayer = [[GJSquareSetLayer alloc]init];
                if ([self.charDelegate respondsToSelector:@selector(GJChartView:customTextLayerStlye:customSectionLayerStyle:inSection:)]) {
                    [self.charDelegate GJChartView:self customTextLayerStlye:textSet customSectionLayerStyle:squareLayer inSection:i];
                }
                [self setSquareLayer:squareLayer WithValues:values];
                
                if ([self.charDataDelegate respondsToSelector:@selector(GJChartView:tipTitleForSection:)]) {
                    NSString* title = [self.charDataDelegate GJChartView:self tipTitleForSection:i];
                    CGRect rect = CGRectMake([_coordinateLayer getXWithValue:0]+MAX(_coordinateLayer.bigLineH, _coordinateLayer.arrowSize)+10, [_coordinateLayer getYWithValue:_coordinateLayer.MaxY] + self.tipViewHeight*(i+0.25), self.tipViewWidth, self.tipViewHeight*0.5);
                    [squareLayer addSquareWithRect:rect];
                    
                    CGPoint point = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
                    [textSet addTextWithPoint:point text:title textAlignment:TextAlignmentLeft];

                }
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
        //title
        
        for (NSValue* value in values) {
            NSString* titleName = [NSString stringWithFormat:@"%d",(int)[value CGPointValue].y];
            if ([self.charDelegate respondsToSelector:@selector(GJChartView:titleWithValue:inSection:)]) {
                titleName = [self.charDelegate GJChartView:self titleWithValue:[value CGPointValue] inSection:i];
            }
            CGPoint point = [_coordinateLayer getPointWithValue:[value CGPointValue]];
            [textSet addTextWithPoint:point text:titleName textAlignment:TextAlignmentBotton];
            
            }
    }
}
-(void)analysisCoordinate{
    CGFloat maxY = -MAXFLOAT;
    CGFloat maxX = -MAXFLOAT;
    CGFloat minY = MAXFLOAT;
    CGFloat minX = MAXFLOAT;
    CGFloat maxCount = -MAXFLOAT;
    
    long capacity = 0;
    if ([self.charDataDelegate respondsToSelector:@selector(numberOfSectionsInCoordinateView:)]) {
        capacity = [self.charDataDelegate numberOfSectionsInCoordinateView:self];
    }
    if (capacity == 0) {
        return;
    }
    for (int i = 0; i < capacity; i++) {
        NSArray<NSValue*>* values;
        if ([self.charDataDelegate respondsToSelector:@selector(GJChartView:dataForSection:)]) {
            values = [self.charDataDelegate GJChartView:self dataForSection:i];
        }
        maxCount = MAX(maxCount, values.count);
        for (NSValue* value in values) {
            maxX = MAX(maxX, [value CGPointValue].x);
            maxY = MAX(maxY, [value CGPointValue].y);
            
            minX = MIN(minX, [value CGPointValue].x);
            minY = MIN(minY, [value CGPointValue].y);

        }
    }
    if (_autoResizeMax) {
        _coordinateLayer.MaxY = maxY * 1.2;
        _coordinateLayer.MaxX = maxX*(1.01);
        
        if (minY <0) {
            _coordinateLayer.MinY = minY * 1.2 ;
        }
        if (minX < 0) {
            _coordinateLayer.MinX = minX * 1.01;
        }
    }
    
    if (_autoResizeUnit) {
        if (maxCount != 0 && _coordinateLayer.countY != 0) {
            _coordinateLayer.unitY =  MIN((maxY - minY) / maxCount,(maxY - minY) / _coordinateLayer.countY);
            if (_coordinateLayer.countX != 0) {
                _coordinateLayer.unitX = (maxX - minX) / (_coordinateLayer.countX * maxCount);
            }
        }
    }
    
    if (_showBackgroundLine) {
        if (_coordinateLayer.unitY == 0 || _coordinateLayer.countY == 0) {
            return;
        }
        GJLineSetLayer* lineLayer = [[GJLineSetLayer alloc]init];
        lineLayer.capType = LineTypeDash;
        lineLayer.color = [UIColor grayColor];
        lineLayer.showPoint = NO;
        lineLayer.frame = _coordinateLayer.bounds;
        int lineCount = _coordinateLayer.MaxY / _coordinateLayer.unitY / _coordinateLayer.countY;
        CGFloat height = _coordinateLayer.unitH * _coordinateLayer.countY;
        for (int j = 1; j<lineCount ; j++) {
            CGPoint beginPoint = [_coordinateLayer getPointWithValue:CGPointMake(0, height * j)];
            CGPoint endPoint = [_coordinateLayer getPointWithValue:CGPointMake(maxX, height * j)];
            [lineLayer addLineFromPoint:beginPoint toPoint:endPoint];
        }
        [self.layer addSublayer:lineLayer];
    }

}
-(void)setLineLayer:(GJLineSetLayer*)lineSet WithValues:(NSArray<NSValue*>*)values{
    
    NSMutableArray* pointArry = [[NSMutableArray alloc]initWithCapacity:values.count];
    for (NSValue* value in values) {
        CGPoint point =[_coordinateLayer getPointWithValue:[value CGPointValue]];
        [pointArry addObject:[NSValue valueWithCGPoint:point]];
    }
    [lineSet addLinesWithPoints:pointArry];
}
-(void)setSquareLayer:(GJSquareSetLayer*)squareLayer WithValues:(NSArray<NSValue*>*)values{
    
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
-(void)setCharDataDelegate:(id<GJChartViewDataSourceDelegate>)charDataDelegate{
    _charDataDelegate = charDataDelegate;
    [self buildSection];

}
-(void)setCharDelegate:(id<GJChartViewDelegate>)charDelegate{
    _charDelegate = charDelegate;
    _coordinateLayer.coordinateDeleagte = charDelegate;
    [self buildSection];

}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
      _squareLayer.frame = self.bounds;
    [self buildSection];
  
}
-(void)setAutoResizeMax:(BOOL)autoResizeMax{
    _autoResizeMax = autoResizeMax;
    [self buildSection];
}
-(void)setAutoResizeUnit:(BOOL)autoResizeUnit{
    _autoResizeUnit = autoResizeUnit;
    [self buildSection];
}
-(void)setTipViewHeight:(CGFloat)tipViewHeight{
    _tipViewHeight = tipViewHeight;
    [self buildSection];
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
-(void)reloadData{
    
    [self buildSection];
}



@end
