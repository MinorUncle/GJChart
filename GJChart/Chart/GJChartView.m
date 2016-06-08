 //
//  GJChartView.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/5.
//  Copyright © 2016年 tongguan. All rights reserved.
//


#import "GJChartView.h"

//提示框水平间距，竖直间距通过 tipViewHeight调整
#define TIP_VIEW_H_MARGIN 2
@interface GJChartView()
{
    NSMutableArray* _sectionLayerArry;
    CGFloat _totalTipXPoint;
    CGFloat _currentRowMaxWidth;
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
        _verticalMaxTipCount = 4;
        _sectionLayerArry = [[NSMutableArray alloc]init];
        _squareWRate = 0.2;
        _tipViewWidth = 50;
        _tipViewHeight = 12;
        _autoResizeYMaxAndMin = YES;
        _autoResizeYBigUnitCount = YES;
        _autoResizeXMaxAndMin = YES;
        _autoResizeXBigUnitCount = YES;
        _showBackgroundHLine = YES;
        _showBackgroundVLine = NO;
        _autoAdjustXZeroPoint = YES;
        _autoAdjustYZeroPoint = YES;
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
    [self analysisCoordinate];
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
                    CGPoint point = [self getTipViewOrginWithTitle:title textSetLayer:textSet Section:i];
                    point.y += self.tipViewHeight*(0.5);
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
                    CGPoint point = [self getTipViewOrginWithTitle:title textSetLayer:textSet Section:i];
                    point.y += self.tipViewHeight*(0.25);
                    CGRect rect = CGRectMake(point.x,point.y, self.tipViewWidth, self.tipViewHeight*0.5);
                    [squareLayer addSquareWithRect:rect];
                    point = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
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
-(CGPoint)getTipViewOrginWithTitle:(NSString*)title textSetLayer:(GJTextSetLayer*)textLayer Section:(NSInteger)index{
    
    NSInteger flg;
    if (_verticalMaxTipCount == 0) {
        flg = index;
    }else{
        flg = index % _verticalMaxTipCount;
    }
    if (index == 0) {
        _totalTipXPoint =[_coordinateLayer getXWithValue:0]+MAX(_coordinateLayer.bigLineH, _coordinateLayer.arrowSize)+10;
    }else{
        if (flg == 0) {
            _totalTipXPoint += _currentRowMaxWidth + TIP_VIEW_H_MARGIN;
            _currentRowMaxWidth = 0;
        }
    }
    CGSize size = [title sizeWithAttributes:textLayer.font == nil?nil:@{NSFontAttributeName:textLayer.font}];
    CGFloat currentW = size.width+textLayer.textAlignmentMargin+_tipViewWidth;
    _currentRowMaxWidth = MAX(_currentRowMaxWidth, currentW);
    return CGPointMake(_totalTipXPoint, flg* _tipViewHeight);
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
        if (values.count == 0) {
            break;
        }
        maxCount = MAX(maxCount, values.count);
        for (NSValue* value in values) {
            maxX = MAX(maxX, [value CGPointValue].x);
            maxY = MAX(maxY, [value CGPointValue].y);
            
            minX = MIN(minX, [value CGPointValue].x);
            minY = MIN(minY, [value CGPointValue].y);
        }
    }

    if (_autoResizeYMaxAndMin) {
        if (minY == MAXFLOAT) {
            minY = 0;
        }
        if (maxY == -MAXFLOAT) {
            maxY = 1;
        }
        if(minY >0){
            minY = 0;
        }else if(maxY < 0){
            maxY = 0;
        }
        if (minY == maxY && minY == 0) {
            maxY = 1;
        }
        _coordinateLayer.MaxY = maxY;
        _coordinateLayer.MinY = minY ;
    }
    if (_autoResizeXMaxAndMin) {
        if (minX == MAXFLOAT) {
            minX = 0;
        }
        if (maxX == -MAXFLOAT) {
            maxX = 1;
        }
        if(minX >0){
            minX = 0;
        }else if(maxX < 0){
            maxX = 0;
        }
        _coordinateLayer.MinX = minX ;
        _coordinateLayer.MaxX = maxX;
    }

    if (_autoResizeYBigUnitCount && maxCount != 0 && _coordinateLayer.countY != 0) {
            if (_coordinateLayer.MaxY * _coordinateLayer.MinY >= 0) {
                _coordinateLayer.bigUnitYCount =  MAX(maxCount/_coordinateLayer.countY,3);
            }else{
                _coordinateLayer.bigUnitYCount =  MAX(maxCount/_coordinateLayer.countY - 1,3);
            }
    }
    if (_autoResizeXBigUnitCount && _coordinateLayer.countX != 0 && maxCount != 0) {
            if (_coordinateLayer.MaxX * _coordinateLayer.MinX >= 0) {
                _coordinateLayer.bigUnitXCount =  MAX(maxCount,3);
            }else{
                _coordinateLayer.bigUnitXCount =  MAX(maxCount-1,3);
            }
    }
            //修正0位置，
    if(_autoAdjustXZeroPoint){
        CGFloat max = _coordinateLayer.MaxX;
        CGFloat min = _coordinateLayer.MinX;
        uint bigCount = _coordinateLayer.bigUnitXCount;
        uint count = _coordinateLayer.countX;
        [self adjustZeorWithMax:&max Min:&min BigCount:&bigCount Count:count resize:_autoResizeXMaxAndMin && _autoResizeXBigUnitCount];
        _coordinateLayer.MinX = min;
        _coordinateLayer.MaxX = max;
        _coordinateLayer.bigUnitXCount = bigCount;
        _coordinateLayer.countX = count;
    }
    
    if (_autoAdjustYZeroPoint) {
        CGFloat max = _coordinateLayer.MaxY;
        CGFloat min = _coordinateLayer.MinY;
        uint bigCount = _coordinateLayer.bigUnitYCount;
        uint count = _coordinateLayer.countY;
        [self adjustZeorWithMax:&max Min:&min BigCount:&bigCount Count:count resize:_autoResizeYMaxAndMin && _autoResizeYBigUnitCount];
        _coordinateLayer.MinY = min;
        _coordinateLayer.MaxY = max;
        _coordinateLayer.bigUnitYCount = bigCount;
        _coordinateLayer.countY = count;
        

    }
    
     if (_showBackgroundHLine) {
        if (_coordinateLayer.unitY != 0 && _coordinateLayer.countY != 0) {
            [self.backgroundHLineLayer clear];
            int lineCount = _coordinateLayer.bigUnitYCount;
            for (int j = 1; j<lineCount ; j++) {
                CGFloat y =  _coordinateLayer.unitY*_coordinateLayer.countY * j + _coordinateLayer.MinY;
                CGPoint beginPoint = [_coordinateLayer getPointWithValue:CGPointMake(_coordinateLayer.MinX,y)];
                CGPoint endPoint = [_coordinateLayer getPointWithValue:CGPointMake(_coordinateLayer.MaxX, y)];
                [self.backgroundHLineLayer addLineFromPoint:beginPoint toPoint:endPoint];
            }
        }
        
    }
    
    if (_showBackgroundVLine) {
        if (_coordinateLayer.unitX != 0 && _coordinateLayer.countX != 0) {
            [self.backgroundVLineLayer clear];
            
            int lineCount = _coordinateLayer.bigUnitXCount;
            for (int j = 1; j<lineCount ; j++) {
                CGFloat x =  _coordinateLayer.unitX*_coordinateLayer.countX * j + _coordinateLayer.MinX;
                CGPoint beginPoint = [_coordinateLayer getPointWithValue:CGPointMake(x,_coordinateLayer.MinY)];
                CGPoint endPoint = [_coordinateLayer getPointWithValue:CGPointMake(x, _coordinateLayer.MaxY)];
                [self.backgroundVLineLayer addLineFromPoint:beginPoint toPoint:endPoint];
            }
        }
    }
}
-(GJLineSetLayer *)backgroundHLineLayer{
    if (_backgroundHLineLayer == nil) {
        _backgroundHLineLayer = [[GJLineSetLayer alloc]init];
        _backgroundHLineLayer.capType = LineTypeDash;
        _backgroundHLineLayer.color = [UIColor grayColor];
        _backgroundHLineLayer.showPoint = NO;
        [self.layer addSublayer:_backgroundHLineLayer];
    }

    _backgroundHLineLayer.frame = _coordinateLayer.bounds;
    return _backgroundHLineLayer;
}
-(GJLineSetLayer *)backgroundVLineLayer{
    if (_backgroundVLineLayer == nil) {
        _backgroundVLineLayer = [[GJLineSetLayer alloc]init];
        _backgroundVLineLayer.capType = LineTypeSolid;
        _backgroundVLineLayer.color = [UIColor grayColor];
        _backgroundVLineLayer.showPoint = NO;
        [self.layer addSublayer:_backgroundVLineLayer];
    }

    _backgroundVLineLayer.frame = _coordinateLayer.bounds;
    return _backgroundVLineLayer;
}

-(void)adjustZeorWithMax:(CGFloat*)max Min:(CGFloat*)min BigCount:(uint*)bigCount Count:(uint)smallCount resize:(BOOL)resize{
    //修正0位置，
    CGFloat unit =  (*max - *min)/(*bigCount)/smallCount;
    if (*max * *min < 0) {//调整0位置
        CGFloat count = fabs(*min/unit/smallCount);
        int iCount = count;
        if (count - iCount > 0.00001 ) {
            (*bigCount) +=1;
            if (*min > 0) {
                *min = (iCount + 1) * fabs(unit) *smallCount;
            }else{
                *min = -(iCount + 1) * fabs(unit) *smallCount;
            }
            if (*max >0) {
                //                    NSLog(@"test1 %f,%f,%f",(float)_bigUnitXCount - iCount - 1,fabsf(unitX),(float)_countX);
                *max = (*bigCount - iCount - 1) * fabs(unit)  *smallCount;
            }else{
                //                    NSLog(@"test %f,%f,%f",(float)_bigUnitXCount - iCount - 1,fabsf(unitX),(float)_countX);
                *max = -((float)(*bigCount) - iCount - 1)*fabs(unit)  * (float)smallCount;
            }
        }else if(resize){
            *bigCount +=2;
            *max += unit * smallCount;
            *min -= unit * smallCount;
        }
    }else if(resize){//正好时在左右添加一个
//        CGFloat unitX = smallCount;//保存，防止改变；
        
        if (*max != 0) {
            *bigCount +=1;
            *max += unit *smallCount;
        }
        if (*min != 0) {
            *bigCount +=1;
            *min -= unit * smallCount;
        }
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
-(void)setAutoResizeXMaxAndMin:(BOOL)autoResizeXMaxAndMin{
    _autoResizeXMaxAndMin = autoResizeXMaxAndMin;
    [self buildSection];
}
-(void)setAutoResizeYMaxAndMin:(BOOL)autoResizeYMaxAndMin{
    _autoResizeYMaxAndMin = autoResizeYMaxAndMin;
    [self buildSection];
}
-(void)setTipViewHeight:(CGFloat)tipViewHeight{
    _tipViewHeight = tipViewHeight;
    [self buildSection];
}
-(void)setAutoAdjustXZeroPoint:(BOOL)autoAdjustXZeroPoint{
    _autoAdjustXZeroPoint = autoAdjustXZeroPoint;
    [self buildSection];
}
-(void)setAutoAdjustYZeroPoint:(BOOL)autoAdjustYZeroPoint{
    _autoAdjustYZeroPoint = autoAdjustYZeroPoint;
    [self buildSection];
}

-(void)setAutoResizeYBigUnitCount:(BOOL)autoResizeYBigUnitCount{
    _autoResizeYBigUnitCount = autoResizeYBigUnitCount;
    [self buildSection];
}
-(void)setAutoResizeXBigUnitCount:(BOOL)autoResizeXBigUnitCount{
    _autoResizeXBigUnitCount = autoResizeXBigUnitCount;
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
