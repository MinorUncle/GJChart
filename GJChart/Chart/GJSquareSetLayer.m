//
//  SquareLayer.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/19.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import "GJSquareSetLayer.h"
@interface GJSquareSetLayer ()
{
    /////矩形数据
    NSMutableArray<NSValue*>* rangeArry;///位置数组
}
@end
@implementation GJSquareSetLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        rangeArry = [[NSMutableArray alloc]init];
        _fillColor = [UIColor redColor];
        _strokeColor = [UIColor blackColor];
        _lineStyle = UIEdgeInsetsMake(SquareLayerNone, SquareLayerNone, SquareLayerNone, SquareLayerNone);
        
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx{
    for (int i = 0; i < rangeArry.count; i++) {
        NSValue* value = rangeArry[i];
        CGRect rect = [value CGRectValue];
        [self drawSquareWithContext:ctx Range:rect];
    }
}
-(void)drawSquare{

}
-(void)drawLine{
}
-(void)drawArea{
}
-(void)drawSquareWithContext:(CGContextRef)ctx Range:(CGRect)rect{
    CGContextSetFillColorWithColor(ctx, _fillColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextFillRect(ctx, rect);
    CGContextSetLineWidth(ctx, 1);
    
    //上
    CGContextMoveToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y);
    [self setLineDashWithStyle:_lineStyle.top context:ctx];
    CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y);
    CGContextStrokePath(ctx);


    //左
    CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y);
    [self setLineDashWithStyle:_lineStyle.left context:ctx];
    CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y + rect.size.height);
    CGContextStrokePath(ctx);

    //下
    CGContextMoveToPoint(ctx, rect.origin.x , rect.origin.y + rect.size.height);
    [self setLineDashWithStyle:_lineStyle.bottom context:ctx];
    CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGContextStrokePath(ctx);

    ///右
    CGContextMoveToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    [self setLineDashWithStyle:_lineStyle.right context:ctx];
    CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y);
    CGContextStrokePath(ctx);

    
}
-(void)setLineDashWithStyle:(SquareLayerStyle)style context:(CGContextRef)ctx{
    switch (style) {
        case SquareLayerNone:
            CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
            break;
        case SquareLayerDash:
        {
            CGFloat lengths[] = {3,3};
            CGContextSetLineDash(ctx, 0, lengths, 2);
            CGContextSetStrokeColorWithColor(ctx, _strokeColor.CGColor);

        }
            break;
        case SquareLayerSolid:
        {
            CGFloat lengths[] = {300,0};
            CGContextSetLineDash(ctx, 0, lengths, 2);
            CGContextSetStrokeColorWithColor(ctx, _strokeColor.CGColor);

        }
            break;
        default:
            break;
    }
    
}
-(void)addSquareWithRect:(CGRect)rect{
    [rangeArry addObject:[NSValue valueWithCGRect:rect]];
    [self setNeedsDisplay];
}
-(void)addSquareWithRects:(NSArray<NSValue*>*)rects{
    [rangeArry addObjectsFromArray:rects];
    [self setNeedsDisplay];
}

@end
