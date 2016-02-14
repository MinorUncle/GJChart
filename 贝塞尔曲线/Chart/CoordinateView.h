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
#import "TextSetLayer.h"
#import "CircularPointSetLayer.h"
#import "LineSetLayer.h"
#import "CoordinateSystemLayer.h"

typedef NS_ENUM(NSInteger, CoordinateViewSectionType) {
    CoordinateViewSectionTypeLine,
    CoordinateViewSectionTypeBar,
    CoordinateViewSectionTypePie

};
@class CoordinateView;
@protocol CoordinateViewDelegate <NSObject,CoordinateSystemLayerDelegate>
@optional
 ///自定义点的名称
-(NSString*) CoordinateView:(CoordinateView*)view titleWithValue:(CGPoint)point;
-(CoordinateViewSectionType) CoordinateView:(CoordinateView*)view typeWithSection:(NSInteger)section;  ///自定义组类型
-(void)CoordinateView:(CoordinateView*)view customTextLayerStlye:(TextSetLayer*)textLayer customSectionLayerStyle:(CALayer*)sectionLayer inSection:(NSInteger)section;
@end

@protocol CoordinateViewDataSourceDelegate <NSObject>
/**
 *  数据代理
 *
 *  @param view    坐标视图
 *  @param section section
 *
 *  @return CGPoint的NSValue数组
 */
-(NSArray<NSValue*>*) CoordinateView:(CoordinateView*)view dataForSection:(NSInteger)section;
@optional
- (NSInteger)numberOfSectionsInCoordinateView:(CoordinateView *)coordinateView;              // Default is 1 if not implemented
-(CGFloat) CoordinateView:(CoordinateView*)view valueWithIndexPath:(NSIndexPath*)indexPath;


@end


@interface CoordinateView : UIView





@property(nonatomic,assign)CGPoint beginValue;
@property(nonatomic,assign)float speed;   //动画速度 ///未使用
/**
 *  条状图的宽与大单元格的比例
 */
@property(nonatomic,assign)CGFloat squareWRate;

@property(nonatomic,retain,readonly)TextSetLayer* textLayer;
@property(nonatomic,retain,readonly)CircularPointSetLayer* circularLayer;
@property(nonatomic,retain,readonly)SquareSetLayer* squareLayer;
@property(nonatomic,retain,readonly)LineSetLayer* lineLayer;
@property(nonatomic,retain,readonly)CoordinateSystemLayer* coordinateLayer;

@property(nonatomic,weak) id<CoordinateViewDelegate> delegate;
@property(nonatomic,weak) id<CoordinateViewDataSourceDelegate> dataDelegate;





////折线
-(void)addValue:(CGPoint)value;
-(void)beginWithValue:(CGPoint)value;
-(void)addValues:(NSArray<NSValue*>*)values;

//////背景方块
-(void)addSquareWithValueRect:(CGRect)valueRect color:(UIColor *)color style:(UIEdgeInsets)style;

/////文字

@end
