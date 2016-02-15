//
//  GJLineSetLayer.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/21.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import "GJLineSetLayer.h"
@interface GJLineSetLayer()
{
    UIBezierPath* path;
}
@end
@implementation GJLineSetLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fillColor = [UIColor clearColor].CGColor;
        path = [[UIBezierPath alloc]init];
        _circularLayer = [[GJCircularPointSetLayer alloc]init];
        [self addSublayer:_circularLayer];
        
//        [self setLineDashPattern:@[@3,@3]];
        [self setStrokeColor:[UIColor yellowColor].CGColor];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _circularLayer.frame = self.bounds;
}
-(void)setCapType:(LineType)capType{
    switch (capType) {
        case LineTypeDash:
        {
            [self setLineDashPattern:@[@3,@3]];
        }
            break;
        case LineTypeSolid:
        {
            [self setLineDashPattern:@[@30,@0]];
        }
            break;
        case LineTypeNone:
        {
            [self setStrokeColor:[UIColor clearColor].CGColor];
        }
            break;
            
        default:
            break;
    }
}
-(void)setColor:(UIColor *)color{
    _color = color;

    [self setStrokeColor:color.CGColor];
}
-(void)addLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint{
    [path moveToPoint:fromPoint];
    [path addLineToPoint:toPoint];
    [_circularLayer addCircularToPoint:toPoint];
    self.path = path.CGPath;
}

-(void)addLinesWithPoints:(NSArray<NSValue*>*)points{
    if (points.count <2) {return;}
    CGPoint point = [points[0] CGPointValue];
    [path moveToPoint:point];
    [_circularLayer addCircularToPoint:point];
    for (int i = 1; i<points.count; i++) {
        [path addLineToPoint:[points[i] CGPointValue]];
        [_circularLayer addCircularToPoint:[points[i] CGPointValue]];

    }
    self.path = path.CGPath;
}
-(void)clear{
    [path removeAllPoints];
    [_circularLayer clear];
}
-(void)reload{  ///更新画面
    self.path = path.CGPath;
}
-(void)beginWithPoint:(CGPoint)point{  ///设置当前点
    [path moveToPoint:point];
    [_circularLayer addCircularToPoint:point];
}
-(void)addLineToPoint:(CGPoint)toPoint{    ///起点为当前点
    [path addLineToPoint:toPoint];
    [_circularLayer addCircularToPoint:toPoint];
    self.path = path.CGPath;
}
@end