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
//映射坐标轴属性，用于方便实现x,y坐标的转换
@property(nonatomic,assign)CGFloat MaxY;
@property(nonatomic,assign)CGFloat MaxX;
@property(nonatomic,assign)CGFloat MinY;
@property(nonatomic,assign)CGFloat MinX;
@property(nonatomic,assign)uint countY;
@property(nonatomic,assign)uint countX;
@property(nonatomic,assign)uint bigUnitYCount;
@property(nonatomic,assign)uint bigUnitXCount;
@property(nonatomic,assign,readonly)CGFloat unitY;
@property(nonatomic,assign,readonly)CGFloat unitX;
@property(nonatomic,assign,readonly)CGFloat unitW;
@property(nonatomic,assign,readonly)CGFloat unitH;
@end
@implementation GJChartView
-(CGFloat)unitW{
    if (self.coordinateType == CoordinateTypeDefault) {
        return _coordinateLayer.unitW;
    }else{
        return _coordinateLayer.unitH;
    }
}
-(CGFloat)unitH{
    if (self.coordinateType == CoordinateTypeDefault) {
        return _coordinateLayer.unitH;
    }else{
        return _coordinateLayer.unitW;
    }
}

-(CGFloat)MaxX{
    if (self.coordinateType == CoordinateTypeDefault) {
        return _coordinateLayer.MaxX;
    }else{
        return _coordinateLayer.MaxY;
    }
}
-(void)setMaxX:(CGFloat)MaxX{
    if (self.coordinateType == CoordinateTypeDefault) {
        _coordinateLayer.MaxX = MaxX;
    }else{
        _coordinateLayer.MaxY = MaxX;
    }
}
-(CGFloat)MinX{
    if (self.coordinateType == CoordinateTypeDefault) {
        return _coordinateLayer.MinX;
    }else{
        return _coordinateLayer.MinY;
    }
}
-(void)setMinX:(CGFloat)MinX{
    if (self.coordinateType == CoordinateTypeDefault) {
        _coordinateLayer.MinX = MinX;
    }else{
        _coordinateLayer.MinY = MinX;
    }
}

-(uint)countX{
    if (self.coordinateType == CoordinateTypeDefault) {
        return _coordinateLayer.countX;
    }else{
        return _coordinateLayer.countY;
    }
}
-(void)setCountX:(uint)countX{
    if (self.coordinateType == CoordinateTypeDefault) {
        _coordinateLayer.countX = countX;
    }else{
        _coordinateLayer.countY = countX;
    }
}

-(CGFloat)MaxY{
    if (self.coordinateType == CoordinateTypeDefault) {
        return _coordinateLayer.MaxY;
    }else{
        return _coordinateLayer.MaxX;
    }
}
-(void)setMaxY:(CGFloat)MaxY{
    if (self.coordinateType == CoordinateTypeDefault) {
        _coordinateLayer.MaxY = MaxY;
    }else{
        _coordinateLayer.MaxX = MaxY;
    }
}
-(CGFloat)MinY{
    if (self.coordinateType == CoordinateTypeDefault) {
        return _coordinateLayer.MinY;
    }else{
        return _coordinateLayer.MinX;
    }
}
-(void)setMinY:(CGFloat)MinY{
    if (self.coordinateType == CoordinateTypeDefault) {
        _coordinateLayer.MinY = MinY;
    }else{
        _coordinateLayer.MinX = MinY;
    }
}

-(uint)countY{
    if (self.coordinateType == CoordinateTypeDefault) {
        return _coordinateLayer.countY;
    }else{
        return _coordinateLayer.countX;
    }
}
-(void)setCountY:(uint)countY{
    if (self.coordinateType == CoordinateTypeDefault) {
        _coordinateLayer.countY = countY;
    }else{
        _coordinateLayer.countX = countY;
    }
}
-(CGFloat)unitX{
    if (self.coordinateType == CoordinateTypeDefault) {
        return _coordinateLayer.unitX;
    }else{
        return _coordinateLayer.unitY;
    }
}
-(CGFloat)unitY{
    if (self.coordinateType == CoordinateTypeDefault) {
        return _coordinateLayer.unitY;
    }else{
        return _coordinateLayer.unitX;
    }
}
-(uint)bigUnitXCount{
    if (self.coordinateType == CoordinateTypeDefault) {
        return _coordinateLayer.bigUnitXCount;
    }else{
        return _coordinateLayer.bigUnitYCount;
    }
}
-(void)setBigUnitXCount:(uint)bigUnitXCount{
    if (self.coordinateType == CoordinateTypeDefault) {
        _coordinateLayer.bigUnitXCount = bigUnitXCount;
    }else{
        _coordinateLayer.bigUnitYCount = bigUnitXCount;
    }
}
-(uint)bigUnitYCount{
    if (self.coordinateType == CoordinateTypeDefault) {
        return _coordinateLayer.bigUnitYCount;
    }else{
        return _coordinateLayer.bigUnitXCount;
    }
}
-(void)setBigUnitYCount:(uint)bigUnitYCount{
    if (self.coordinateType == CoordinateTypeDefault) {
        _coordinateLayer.bigUnitYCount = bigUnitYCount;
    }else{
        _coordinateLayer.bigUnitXCount = bigUnitYCount;
    }
}

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
        NSMutableArray<NSValue*>* values = [[NSMutableArray alloc]initWithArray:[self.charDataDelegate GJChartView:self dataForSection:i]];
//        for (int i = 0; i<values.count; i++) {
//            NSValue* value = values[i];
//            CGPoint p = [value CGPointValue];
//            p.x += p.y;
//            p.y = p.x - p.y;
//            p.x = p.x - p.y;
//            value = [NSValue valueWithCGPoint:p];
//            [values replaceObjectAtIndex:i withObject:value];
//        }
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
            CGPoint point = [self _getPointWithValue:[value CGPointValue]];
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
        _totalTipXPoint =[self _getXWithValue:0]+MAX(_coordinateLayer.bigLineH, _coordinateLayer.arrowSize)+10;
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
    
    //真实的
    CGFloat realMaxY = -MAXFLOAT;
    CGFloat realMaxX = -MAXFLOAT;
    CGFloat realMinY = MAXFLOAT;
    CGFloat realMinX = MAXFLOAT;
    
    CGFloat maxCount = -MAXFLOAT;
    uint XBigUnitCount = self.bigUnitXCount;
    uint YBigUnitCount = self.bigUnitYCount;


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
            continue;
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
        realMaxY = maxY;
        realMinY = minY;
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
    }else{
        maxY = self.MaxY;
        minY = self.MinY;
        
        realMaxY = maxY;
        realMinY = minY;
    }
    if (_autoResizeXMaxAndMin) {
        realMaxX = maxX;
        realMinX = minX;
        
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
    }else{
        maxX = self.MaxX;
        minX = self.MinX;
        
        realMaxX = maxX;
        realMinX = minX;
    }

    if (_autoResizeYBigUnitCount && maxCount != 0 && self.countY != 0) {
        if (maxY* minY >= 0) {
            YBigUnitCount =  MAX(maxCount/self.countY,3);
        }else{
            YBigUnitCount =  MAX(maxCount/self.countY - 1,3);
        }
    }
    if (_autoResizeXBigUnitCount && self.countX != 0 && maxCount != 0) {
        float bigUnit = (realMaxX-realMinX)/(maxCount-1);

        if (realMaxX * realMinX > 0) {
            if (realMaxX>0) {
                XBigUnitCount =  MAX(realMaxX/bigUnit,3);
            }else{
                XBigUnitCount =  MAX(-realMinX/bigUnit,3);
            }
        }else{
            XBigUnitCount =  MAX((realMaxX - realMinX)/bigUnit,3);
        }
    }
            //修正0位置，
    if(_autoAdjustXZeroPoint){
        uint count = self.countX;
        [self adjustZeorWithMax:&maxX Min:&minX BigCount:&XBigUnitCount Count:count resize:_autoResizeXMaxAndMin && _autoResizeXBigUnitCount];
    }
    
    if (_autoAdjustYZeroPoint) {
        uint count = self.countY;
        [self adjustZeorWithMax:&maxY Min:&minY BigCount:&YBigUnitCount Count:count resize:_autoResizeYMaxAndMin && _autoResizeYBigUnitCount];
    }
    self.MaxY = maxY;
    self.MinY = minY;
    self.MaxX = maxX;
    self.MinX = minX;
    self.bigUnitYCount = YBigUnitCount;
    self.bigUnitXCount = XBigUnitCount;

    [self.backgroundHLineLayer clear];
    if (_showBackgroundHLine) {
         [self drawBackgroundHLine];
    }
    [self.backgroundVLineLayer clear];
    if (_showBackgroundVLine) {
        [self drawBackgroundVLine];
    }
}
-(void)drawBackgroundVLine{
    if (self.unitX != 0 && self.countX != 0) {
        int lineCount = self.bigUnitXCount;
        for (int j = 1; j<lineCount ; j++) {
            CGFloat x =  self.unitX*self.countX * j + self.MinX;
            CGPoint beginPoint = [self _getPointWithValue:CGPointMake(x,self.MinY)];
            CGPoint endPoint = [self _getPointWithValue:CGPointMake(x, self.MaxY)];
            [self.backgroundVLineLayer addLineFromPoint:beginPoint toPoint:endPoint];
        }
    }
}
-(void)drawBackgroundHLine{
    if (self.unitY != 0 && self.countY != 0) {
        int lineCount = self.bigUnitYCount;
        for (int j = 1; j<lineCount ; j++) {
            CGFloat y =  self.unitY*self.countY * j + self.MinY;
            CGPoint beginPoint = [self _getPointWithValue:CGPointMake(self.MinX,y)];
            CGPoint endPoint = [self _getPointWithValue:CGPointMake(self.MaxX, y)];
            [self.backgroundHLineLayer addLineFromPoint:beginPoint toPoint:endPoint];
        }
    }
}


-(void)setShowBackgroundHLine:(BOOL)showBackgroundHLine{
    if (_showBackgroundHLine != showBackgroundHLine) {
        _showBackgroundHLine = showBackgroundHLine;
        if (showBackgroundHLine) {
            [self drawBackgroundHLine];
        }else{
            [self.backgroundHLineLayer clear];
        }
    }
}
-(void)setShowBackgroundVLine:(BOOL)showBackgroundVLine{
    if (_showBackgroundVLine != showBackgroundVLine) {
        _showBackgroundVLine = showBackgroundVLine;
        if (showBackgroundVLine) {
            [self drawBackgroundVLine];
        }else{
            [self.backgroundVLineLayer clear];
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
        CGPoint point =[self _getPointWithValue:[value CGPointValue]];
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
    CGPoint point =[self _getPointWithValue:vaule];
    
    CGRect rect;
    if (self.coordinateType == CoordinateTypeDefault) {
        CGFloat bottom = [self _getXWithValue:0];
        CGFloat x = point.x - self.unitW * self.countX * _squareWRate * 0.5;
        CGFloat y = point.y;
        CGFloat w = self.unitW * self.countX * _squareWRate;
        CGFloat h = bottom - point.y;
        rect = CGRectMake(x, y, w, h);
    }else if (self.coordinateType == CoordinateTypeHorizontal){
        CGFloat bottom = [self _getYWithValue:0];
        CGFloat x = bottom;//; point.x - self.unitW * self.countX * _squareWRate * 0.5;
        CGFloat y = point.y  - self.unitW * self.countX * _squareWRate * 0.5;
        CGFloat w = point.x - bottom;
        CGFloat h = self.unitW * self.countX * _squareWRate;
        rect = CGRectMake(x, y, w, h);
    }
   
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
    valueRect.origin.x = [self _getXWithValue:valueRect.origin.x];
    valueRect.origin.y = [self _getYWithValue:valueRect.origin.y];
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
-(CGFloat)_getYWithValue:(CGFloat)value{
    CGFloat Y =0;
    switch (self.coordinateType) {
        case CoordinateTypeDefault:
            Y = [_coordinateLayer getYWithValue:value];
            break;
        case CoordinateTypeHorizontal:
            Y = [_coordinateLayer getXWithValue:value];
            break;
        default:
            break;
    }
    return Y;
}
-(CGFloat)_getXWithValue:(CGFloat)value{
    CGFloat X = 0;
    switch (self.coordinateType) {
        case CoordinateTypeDefault:
            X = [_coordinateLayer getXWithValue:value];
            break;
        case CoordinateTypeHorizontal:
            X = [_coordinateLayer getYWithValue:value];
            break;
        default:
            break;
    }
    return X;
}
-(CGPoint)_getPointWithValue:(CGPoint)value{
    CGPoint point;
    switch (self.coordinateType) {
        case CoordinateTypeDefault:
            point.x = [_coordinateLayer getXWithValue:value.x];
            point.y = [_coordinateLayer getYWithValue:value.y];
            break;
        case CoordinateTypeHorizontal:
            point.y = [_coordinateLayer getYWithValue:value.x];
            point.x = [_coordinateLayer getXWithValue:value.y];
            break;
            
        default:
            break;
    }
    return point;

}


@end
