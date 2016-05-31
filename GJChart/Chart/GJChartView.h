//
//  GJChartView.h
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/5.
//  Copyright © 2016年 tongguan. All rights reserved.
//

//坐标轴
#import <UIKit/UIKit.h>
#import "GJSquareSetLayer.h"
#import "GJTextSetLayer.h"
#import "GJCircularPointSetLayer.h"
#import "GJLineSetLayer.h"
#import "GJCoordinateLayer.h"

typedef NS_ENUM(NSInteger, CoordinateViewSectionType) {
    CoordinateViewSectionTypeLine,
    CoordinateViewSectionTypeBar,
    CoordinateViewSectionTypePie

};
@class GJChartView;
@protocol CoordinateViewDelegate <NSObject,CoordinateSystemLayerDelegate>
@optional
 ///自定义点的名称
-(NSString*) GJChartView:(GJChartView*)view titleWithValue:(CGPoint)point;
-(CoordinateViewSectionType) GJChartView:(GJChartView*)view typeWithSection:(NSInteger)section;  ///自定义组类型
-(void)GJChartView:(GJChartView*)view customTextLayerStlye:(GJTextSetLayer*)textLayer customSectionLayerStyle:(CALayer*)sectionLayer inSection:(NSInteger)section;
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
-(NSArray<NSValue*>*) GJChartView:(GJChartView*)view dataForSection:(NSInteger)section;
@optional
- (NSInteger)numberOfSectionsInCoordinateView:(GJChartView *)coordinateView;              // Default is 1 if not implemented
-(CGFloat) GJChartView:(GJChartView*)view valueWithIndexPath:(NSIndexPath*)indexPath;


@end


@interface GJChartView : UIView





@property(nonatomic,assign)CGPoint beginValue;
//@property(nonatomic,assign)float speed;   //动画速度 ///未使用
/**
 *  条状图的宽与大单元格的比例
 */
@property(nonatomic,assign)CGFloat squareWRate;

@property(nonatomic,retain,readonly)GJSquareSetLayer* squareLayer;
@property(nonatomic,retain,readonly)GJCoordinateLayer* coordinateLayer;

@property(nonatomic,weak) id<CoordinateViewDelegate> delegate;
@property(nonatomic,weak) id<CoordinateViewDataSourceDelegate> dataDelegate;






//////背景方块
-(void)addSquareWithValueRect:(CGRect)valueRect color:(UIColor *)color style:(UIEdgeInsets)style;

/////文字

@end
