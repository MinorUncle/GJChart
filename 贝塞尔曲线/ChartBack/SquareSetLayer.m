//
//  SquareLayer.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/19.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import "SquareSetLayer.h"
@interface SquareSetLayer()
{
    /////矩形数据
    NSMutableArray<NSValue*>* rangeArry;///位置数组
    NSMutableArray<UIColor*>* colorArry;////颜色数组
    NSMutableArray<NSValue*>* styleArry;  ///样式数组
}
@end
@implementation SquareSetLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        rangeArry = [[NSMutableArray alloc]init];
        colorArry = [[NSMutableArray alloc]init];
        styleArry = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx{
    for (int i = 0; i < rangeArry.count; i++) {
        NSValue* value = rangeArry[i];
        CGRect rect = [value CGRectValue];
        value = styleArry[i];
        UIEdgeInsets style = [value UIEdgeInsetsValue];
        UIColor* color = colorArry[i];
        [self drawSquareWithContext:ctx Range:rect color:color style:style];
    }
}
-(void)drawSquare{

}
-(void)drawLine{
}
-(void)drawArea{
}
-(void)drawSquareWithContext:(CGContextRef)ctx Range:(CGRect)rect color:(UIColor*)color style:(UIEdgeInsets)style{
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextFillRect(ctx, rect);
    CGContextSetLineWidth(ctx, 1);
    
    //上
    CGContextMoveToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y);
    [self setLineDashWithStyle:style.top context:ctx];
    CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y);
    CGContextStrokePath(ctx);


    //左
    CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y);
    [self setLineDashWithStyle:style.left context:ctx];
    CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y + rect.size.height);
    CGContextStrokePath(ctx);

    //下
    CGContextMoveToPoint(ctx, rect.origin.x , rect.origin.y + rect.size.height);
    [self setLineDashWithStyle:style.bottom context:ctx];
    CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGContextStrokePath(ctx);

    ///右
    CGContextMoveToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    [self setLineDashWithStyle:style.right context:ctx];
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
            CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);

        }
            break;
        case SquareLayerSolid:
        {
            CGFloat lengths[] = {300,0};
            CGContextSetLineDash(ctx, 0, lengths, 2);
            CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);

        }
            break;
        default:
            break;
    }
    
}
-(void)addSquareWithRect:(CGRect)rect color:(UIColor*)color style:(UIEdgeInsets)style{
    [rangeArry addObject:[NSValue valueWithCGRect:rect]];
    [colorArry addObject:color];
    [styleArry addObject:[NSValue valueWithUIEdgeInsets:style]];
    [self setNeedsDisplay];
}
@end
