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
    if (self.dataDelegate == nil || CGRectEqualToRect(self.bounds, CGRectZero)){
        return;
    }
    [_sectionLayerArry makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    NSInteger capacity = 0;
    if ([self.dataDelegate respondsToSelector:@selector(numberOfSectionsInCoordinateView:)]) {
        capacity = [self.dataDelegate numberOfSectionsInCoordinateView:self];
    }
    
    for (int i = 0; i < capacity; i++) {
        NSArray<NSValue*>* values = [self.dataDelegate GJChartView:self dataForSection:i];
        
        CoordinateViewSectionType type = CoordinateViewSectionTypeLine;
        if ([self.dataDelegate respondsToSelector:@selector(GJChartView:typeWithSection:)]) {
            type = [self.delegate GJChartView:self typeWithSection:i];
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
                if ([self.delegate respondsToSelector:@selector(GJChartView:customTextLayerStlye:customSectionLayerStyle:inSection:)]) {
                    [self.delegate GJChartView:self customTextLayerStlye:textSet customSectionLayerStyle:lineSet inSection:i];
                }
                
                [self setLineLayer:lineSet WithValues:values];
                
                //tip
                if ([self.dataDelegate respondsToSelector:@selector(GJChartView:tipTitleForSection:)]) {
                    NSString* title = [self.dataDelegate GJChartView:self tipTitleForSection:i];
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
                if ([self.delegate respondsToSelector:@selector(GJChartView:customTextLayerStlye:customSectionLayerStyle:inSection:)]) {
                    [self.delegate GJChartView:self customTextLayerStlye:textSet customSectionLayerStyle:squareLayer inSection:i];
                }
                [self setSquareLayer:squareLayer WithValues:values];
                if ([self.dataDelegate respondsToSelector:@selector(GJChartView:tipTitleForSection:)]) {
                    NSString* title = [self.dataDelegate GJChartView:self tipTitleForSection:i];
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
        if ([self.delegate respondsToSelector:@selector(GJChartView:titleWithValue:inSection:)]){
            for (NSValue* value in values) {
                NSString* titleName = [self.delegate GJChartView:self titleWithValue:[value CGPointValue] inSection:i];
                if (titleName != nil) {
                    CGPoint point = [_coordinateLayer getPointWithValue:[value CGPointValue]];
                    [textSet addTextWithPoint:point text:titleName textAlignment:TextAlignmentBotton];
                }
            }
        }else{
            for (NSValue* value in values) {
                
                NSString* titleName = [NSString stringWithFormat:@"%d",(int)[value CGPointValue].y];
                CGPoint point = [_coordinateLayer getPointWithValue:[value CGPointValue]];
                [textSet addTextWithPoint:point text:titleName textAlignment:TextAlignmentBotton];
            }
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
-(void)buildTipView{
    if ([self.dataDelegate respondsToSelector:@selector(GJChartView:tipTitleForSection:)]) {
        for (int i =0; i<_sectionLayerArry.count; i++) {
            NSString* title = [self.dataDelegate GJChartView:self tipTitleForSection:i];
            
        }
    }
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
      _squareLayer.frame = self.bounds;
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




@end
