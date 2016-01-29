//
//  PointCircularLayer.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/19.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import "CircularPointSetLayer.h"
#define SMALL_RADIUS 2
#define BIG_RADIUS 3

@interface CircularPointSetLayer()
{
    NSMutableArray<NSValue*>* _pointArry;////圆心
    CGMutablePathRef _bigPath; //大圆路径
    CGMutablePathRef _smallPath;//小圆路径
    
    
}
@end

@implementation CircularPointSetLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        _insideColor = [UIColor greenColor];
        _outsideColor = [UIColor blueColor];
        _smallPath = CGPathCreateMutable();
        _bigPath = CGPathCreateMutable();
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
    CGRect rect = CGRectMake(point.x - BIG_RADIUS, point.y - BIG_RADIUS, 2*BIG_RADIUS, 2*BIG_RADIUS);
    CGPathAddEllipseInRect(_bigPath, nil, rect);
    
    rect = CGRectMake(point.x - SMALL_RADIUS, point.y - SMALL_RADIUS, 2*SMALL_RADIUS, 2*SMALL_RADIUS);
    CGPathAddEllipseInRect(_smallPath, nil, rect);
    [self setNeedsDisplay];
}
-(void)addCircularWithPoints:(NSArray<NSValue *> *)points{
    for (NSValue* value in points) {
        CGPoint point = [value CGPointValue];
        [self addCircularToPoint:point];
    }
    [self setNeedsDisplay];
}

-(void)drawCirularWithContext:(CGContextRef)ctx{
//    for (NSValue* value in _pointArry) {
//        CGContextSetFillColorWithColor(ctx, _outsideColor.CGColor);
//        CGPoint point = [value CGPointValue];
//        CGRect rect = CGRectMake(point.x - BIG_RADIUS, point.y - BIG_RADIUS, 2*BIG_RADIUS, 2*BIG_RADIUS);
//        CGContextAddEllipseInRect(ctx, rect);
//        CGContextDrawPath(ctx, kCGPathFill);
//        
//        CGContextSetFillColorWithColor(ctx, _insideColor.CGColor);
//        rect = CGRectMake(point.x - SMALL_RADIUS, point.y - SMALL_RADIUS, 2*SMALL_RADIUS, 2*SMALL_RADIUS);
//        CGContextAddEllipseInRect(ctx, rect);
//        CGContextDrawPath(ctx, kCGPathFill);
//    }
    CGContextSetFillColorWithColor(ctx, _outsideColor.CGColor);
    CGContextAddPath(ctx, _bigPath);
    CGContextSetFillColorWithColor(ctx, _insideColor.CGColor);
    CGContextAddPath(ctx, _smallPath);
    CGContextFillPath(ctx);
}
-(void)clear{   ////只删除数据，不更新画面，
    [_pointArry removeAllObjects];
    CGPathRelease(_smallPath);
    CGPathRelease(_bigPath);
    _smallPath = CGPathCreateMutable();
    _bigPath = CGPathCreateMutable();
}
-(void)reload{    ///更新画面
    [self setNeedsDisplay];
}
-(void)dealloc{
    CGPathRelease(_smallPath);
    CGPathRelease(_bigPath);
}
@end
