//
//  GJPolygonLayer.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/20.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import "GJPolygonSetLayer.h"
@interface GJPolygonSetLayer ()
{
    NSMutableArray< NSArray<NSValue*>*>* _polygons;
    NSMutableArray<UIColor*>* _colors;
}
@end
@implementation GJPolygonSetLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        _polygons = [[NSMutableArray alloc]init];
        _colors = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx{
    for (int i = 0; i < _colors.count; i++) {
        [self drawPolygonWithPoints:_polygons[i] clolor:_colors[i] inContext:ctx];
    }
}
-(void)drawPolygonWithPoints:(NSArray<NSValue*>*)points clolor:(UIColor*)color inContext:(CGContextRef)ctx{
    if (points.count <2) {return;}
    CGPoint point = [points[0] CGPointValue];
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    CGContextMoveToPoint(ctx, point.x, point.y);
    for (int i = 1; i<points.count; i++) {
        point = [points[i] CGPointValue];
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
    CGContextFillPath(ctx);
}
-(void)addAreaWithPoints:(NSArray<NSValue*>*)points  color:(UIColor*)color{
    [_polygons addObject:points];
    [_colors addObject:color];
    [self setNeedsDisplay];
}

@end
