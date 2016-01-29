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
@interface SquareSetLayer : CALayer
-(void)addSquareWithRect:(CGRect)rect color:(UIColor*)color style:(UIEdgeInsets)style;
@end
