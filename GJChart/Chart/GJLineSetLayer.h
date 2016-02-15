//
//  GJLineSetLayer.h
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/21.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "GJCircularPointSetLayer.h"
typedef enum _LineType{
    LineTypeNone,
    LineTypeDash,
    LineTypeSolid,
}LineType;

@interface GJLineSetLayer : CAShapeLayer
@property(nonatomic,retain)UIColor* color;////只能设置统一线条颜色       ///填充颜色请调用fillColor
@property(nonatomic,assign)LineType capType;////线条类型
@property(nonatomic,retain)GJCircularPointSetLayer* circularLayer;////
-(void)addLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
-(void)addLinesWithPoints:(NSArray<NSValue*>*)points; //第一个为起点
-(void)addLineToPoint:(CGPoint)toPoint;
-(void)beginWithPoint:(CGPoint)point;  ///设置当前点

-(void)clear;   ////只删除数据，不更新画面，
-(void)reload;    ///更新画面
@end
