//
//  CoordinateLayer.h
//  贝塞尔曲线
//
//  Created by 未成年大叔 on 16/2/10.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIColor.h>
#import <UIKit/UIGeometry.h>
@class GJCoordinateLayer;
@protocol CoordinateSystemLayerDelegate <NSObject>
@optional
 ///自定义x轴名称
-(NSString*) GJCoordinateLayer:(GJCoordinateLayer*)view titleWithXValue:(CGFloat)value;
///自定义y轴名称
-(NSString*) GJCoordinateLayer:(GJCoordinateLayer*)view titleWithYValue:(CGFloat)value;
@end
@interface GJCoordinateLayer : CAShapeLayer
////最大Y,当max小于min时，相应坐标箭头调换
@property(nonatomic,assign)CGFloat MaxY;
@property(nonatomic,assign)CGFloat MaxX;
@property(nonatomic,assign)CGFloat MinY;
@property(nonatomic,assign)CGFloat MinX;
////y的一个大单元包含小单元的数量
@property(nonatomic,assign)uint countY;
@property(nonatomic,assign)uint countX;

///大单元格的个数，
@property(nonatomic,assign)uint bigUnitYCount;
@property(nonatomic,assign)uint bigUnitXCount;

 ////一个小Y的单位值，负数代表递减
@property(nonatomic,assign,readonly)CGFloat unitY;
@property(nonatomic,assign,readonly)CGFloat unitX;

@property(nonatomic,assign)BOOL showYCoordinate;
@property(nonatomic,assign)BOOL showXCoordinate;
 ///坐标轴可用宽度，不包括，坐标轴文字
@property(nonatomic,assign,readonly)CGFloat coordinateW;
@property(nonatomic,assign,readonly)CGFloat coordinateH;

@property(nonatomic,assign,readonly)CGFloat unitW;
@property(nonatomic,assign,readonly)CGFloat unitH;
@property(nonatomic,assign)UIEdgeInsets contentInsets;
@property(nonatomic,assign)CGFloat arrowSize;//箭头大小
@property(nonatomic,assign)CGFloat bigLineH;//小标尺大小
@property(nonatomic,assign)CGFloat smallLineH;//大标尺大小
@property(nonatomic,weak)id<CoordinateSystemLayerDelegate> coordinateDeleagte;

-(CGFloat)getYWithValue:(CGFloat)value;
-(CGFloat)getXWithValue:(CGFloat)value;
-(CGFloat)getValueWithY:(CGFloat)Y;
-(CGPoint)getPointWithValue:(CGPoint)value;
@end
