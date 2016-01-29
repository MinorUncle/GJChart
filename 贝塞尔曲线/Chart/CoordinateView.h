//
//  CoordinateView.h
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/5.
//  Copyright © 2016年 tongguan. All rights reserved.
//

//坐标轴
#import <UIKit/UIKit.h>
#import "SquareSetLayer.h"
#import "TextSetView.h"
#import "CircularPointSetLayer.h"
#import "LineSetLayer.h"
@class CoordinateView;
@protocol CoordinateViewDelegate <NSObject>
@optional
-(NSString*) CoordinateView:(CoordinateView*)view titleWithXValue:(CGFloat)value;  ///自定义x轴名称
-(NSString*) CoordinateView:(CoordinateView*)view titleWithYValue:(CGFloat)value;  ///自定义y轴名称
-(NSString*) CoordinateView:(CoordinateView*)view titleWithValue:(CGPoint)point;  ///自定义点的名称


@end

@interface CoordinateView : UIView
@property(nonatomic,assign)CGFloat MaxY; ///最大Y
@property(nonatomic,assign)CGFloat MaxX;
@property(nonatomic,assign)NSInteger countY;  ////y的一个大单元包含小单元的数量
@property(nonatomic,assign)NSInteger countX;
@property(nonatomic,assign)CGFloat unitY;  ////一个小Y的单位
@property(nonatomic,assign)CGFloat unitX;
@property(nonatomic,retain)UIColor* color;

@property(nonatomic,assign)BOOL showYCoordinate;




@property(nonatomic,assign)CGPoint beginValue;
@property(nonatomic,assign)float speed;   //动画速度 ///未使用

@property(nonatomic,retain,readonly)TextSetView* textView;
@property(nonatomic,retain,readonly)CircularPointSetLayer* circularLayer;
@property(nonatomic,retain,readonly)SquareSetLayer* squareLayer;
@property(nonatomic,retain,readonly)LineSetLayer* lineLayer;
@property(nonatomic,weak) id<CoordinateViewDelegate> delegate;



-(CGFloat)getYWithValue:(int)value;
-(CGFloat)getXWithValue:(int)value;
-(CGFloat)getValueWithY:(CGFloat)Y;


////折线
-(void)addValue:(CGPoint)value;
-(void)beginWithValue:(CGPoint)value;
-(void)addValues:(NSArray<NSValue*>*)values;

//////背景方块
-(void)addSquareWithValueRect:(CGRect)valueRect color:(UIColor *)color style:(UIEdgeInsets)style;

/////文字

@end
