//
//  LineSetLayer.h
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/21.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
typedef enum _LineType{
    LineTypeNone,
    LineTypeDash,
    LineTypeSolid,
}LineType;

@interface LineSetLayer : CAShapeLayer
@property(nonatomic,retain)UIColor* color;////只能设置统一线条颜色       ///填充颜色请调用fillColor
@property(nonatomic,assign)LineType capType;////线条类型

-(void)addLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
-(void)addLinesWithPoints:(NSArray<NSValue*>*)points;
-(void)addLineToPoint:(CGPoint)toPoint;    ///起点为当前点
-(void)beginWithPoint:(CGPoint)point;  ///设置当前点
@end
