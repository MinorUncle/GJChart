//
//  SquareLayer.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/19.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import "SquareLayer.h"
@interface SquareLayer()
{
    NSMutableArray<NSValue*>* rangeArry;///位置数组
    NSMutableArray<UIColor*>* colorArry;////颜色数组
    NSMutableArray<NSValue*>* styleArry;  ///样式数组
}
@end
@implementation SquareLayer
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
-(void)drawSquareWithContext:(CGContextRef)ctx Range:(CGRect)rect color:(UIColor*)color style:(UIEdgeInsets)style{
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    
    CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y);
    CGFloat lengths[] = {10,10};
    CGContextSetLineDash(ctx, 0, lengths,2);
   
}
-(void)setLineDashWithStyle:(SquareLayerStyle)style context:(CGContextRef)ctx{
    switch (style) {
        case SquareLayerNone:
            CGContextSetRGBStrokeColor(ctx, <#CGFloat red#>, <#CGFloat green#>, <#CGFloat blue#>, <#CGFloat alpha#>)
            break;
        case SquareLayerDash:
            break;
        case SquareLayerSolid:
            break;
        default:
            break;
    }
    
}
-(void)addSquareWithRange:(CGRect)rect color:(UIColor*)color style:(UIEdgeInsets)style{
    [rangeArry addObject:[NSValue valueWithCGRect:rect]];
    [colorArry addObject:color];
    [styleArry addObject:[NSValue valueWithUIEdgeInsets:style]];
    [self setNeedsDisplay];
}
@end
