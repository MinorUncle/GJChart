//
//  PointCircularLayer.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/19.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import "PointCircularLayer.h"
#define SMALL_RADIUS 2
#define BIG_RADIUS 3

@interface PointCircularLayer()
{
    NSMutableArray<NSValue*>* _pointArry;////圆心
    
}
@end

@implementation PointCircularLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pointArry = [[NSMutableArray alloc]init];
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
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGPoint point = [value CGPointValue];
        CGRect rect = CGRectMake(point.x - BIG_RADIUS, point.y - BIG_RADIUS, 2*BIG_RADIUS, 2*BIG_RADIUS);
        CGContextAddEllipseInRect(ctx, rect);
        CGContextDrawPath(ctx, kCGPathFill);
        
        CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
        rect = CGRectMake(point.x - SMALL_RADIUS, point.y - SMALL_RADIUS, 2*SMALL_RADIUS, 2*SMALL_RADIUS);
        CGContextAddEllipseInRect(ctx, rect);
        CGContextDrawPath(ctx, kCGPathFill);
        
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    }
}
@end
