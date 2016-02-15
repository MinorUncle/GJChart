//
//  SquareLayer.h
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/19.
//  Copyright © 2016年 tongguan. All rights reserved.
//


/**
 /矩形集合
 
 */
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
typedef enum SquareLayerStyle{
    SquareLayerNone = 0,   ///无效果
    SquareLayerDash,        ///虚线
    SquareLayerSolid        ///实线
}SquareLayerStyle;
@interface GJSquareSetLayer : CALayer
@property(retain,nonatomic)UIColor* fillColor;
@property(retain,nonatomic)UIColor* strokeColor;
@property(assign,nonatomic)UIEdgeInsets lineStyle;

/**
 *  画方块
 *
 *  @param rect  位置
 *  @param color 颜色
 *  @param style 边框样式
 */
-(void)addSquareWithRect:(CGRect)rect;

-(void)addSquareWithRects:(NSArray<NSValue*>*)rects;

@end
