//
//  PointCircularLayer.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/19.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import "CircularPointSetLayer.h"


@interface CircularPointSetLayer()
{
    NSMutableArray<NSValue*>* _pointArry;////圆心
    
}
@end

@implementation CircularPointSetLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pointArry = [[NSMutableArray alloc]init];
        _insideColor = [UIColor greenColor];
        _outsideColor = [UIColor blueColor];
        _bigRadius = 3;
        _smallRadius = 2;
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx{
    [self drawCirularWithContext:ctx];
    
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsDisplay];
}
-(void)addCircularToPoint:(CGPoint)point{
    
    [_pointArry addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
}


-(void)drawCirularWithContext:(CGContextRef)ctx{
    for (NSValue* value in _pointArry) {
        CGContextSetFillColorWithColor(ctx, _outsideColor.CGColor);
        CGPoint point = [value CGPointValue];
        CGRect rect = CGRectMake(point.x - _bigRadius, point.y - _bigRadius, 2*_bigRadius, 2*_bigRadius);
        CGContextAddEllipseInRect(ctx, rect);
        CGContextDrawPath(ctx, kCGPathFill);
        
        CGContextSetFillColorWithColor(ctx, _insideColor.CGColor);
        rect = CGRectMake(point.x - _smallRadius, point.y - _smallRadius, 2*_smallRadius, 2*_smallRadius);
        CGContextAddEllipseInRect(ctx, rect);
        CGContextDrawPath(ctx, kCGPathFill);
    }
}
@end
