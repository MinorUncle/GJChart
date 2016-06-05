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
    CoordinateViewSectionTypeLine, ///  线，
    CoordinateViewSectionTypeBar
  //  CoordinateViewSectionTypePie

};
@class GJChartView;
@protocol GJChartViewDelegate <NSObject,CoordinateSystemLayerDelegate>
@optional
 ///自定义点的名称
-(NSString*) GJChartView:(GJChartView*)view titleWithValue:(CGPoint)point inSection:(NSInteger)section;
-(CoordinateViewSectionType) GJChartView:(GJChartView*)view typeWithSection:(NSInteger)section;  ///自定义组类型
-(void)GJChartView:(GJChartView*)view customTextLayerStlye:(GJTextSetLayer*)textLayer customSectionLayerStyle:(CALayer*)sectionLayer inSection:(NSInteger)section;
@end

@protocol GJChartViewDataSourceDelegate <NSObject>
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
- (NSInteger)numberOfSectionsInCoordinateView:(GJChartView *)coordinateView;              // Default is 0 if not implemented
-(CGFloat) GJChartView:(GJChartView*)view valueWithIndexPath:(NSIndexPath*)indexPath;
-(NSString *)GJChartView:(GJChartView *)view tipTitleForSection:(NSInteger)section;
@end


@interface GJChartView : UIScrollView





@property(nonatomic,assign)CGPoint beginValue;
//@property(nonatomic,assign)float speed;   //动画速度 ///未使用
/**
 *  条状图的宽与大单元格的比例
 */
@property(nonatomic,assign)CGFloat squareWRate;
////自动设置单元格最大最小
@property(nonatomic,assign)BOOL autoResizeYMaxAndMin;
@property(nonatomic,assign)BOOL autoResizeXMaxAndMin;
///自动设置大单元格个数
@property(nonatomic,assign)BOOL autoResizeYBigUnitCount;
@property(nonatomic,assign)BOOL autoResizeXBigUnitCount;
//自动对齐0的位置为大标尺的位置，同时存在正负时很可能会最小程度改变最大最小值，
@property(nonatomic,assign)BOOL autoAdjustYZeroPoint;
@property(nonatomic,assign)BOOL autoAdjustXZeroPoint;
@property(nonatomic,assign)BOOL showBackgroundHLine;
@property(nonatomic,assign)BOOL showBackgroundVLine;
@property(nonatomic,strong)GJLineSetLayer* backgroundHLineLayer;
@property(nonatomic,strong)GJLineSetLayer* backgroundVLineLayer;

@property(nonatomic,retain,readonly)GJSquareSetLayer* squareLayer;
@property(nonatomic,retain,readonly)GJCoordinateLayer* coordinateLayer;

@property(nonatomic,weak) id<GJChartViewDelegate> charDelegate;
@property(nonatomic,weak) id<GJChartViewDataSourceDelegate> charDataDelegate;

@property(nonatomic,assign)CGFloat tipViewWidth;
@property(nonatomic,assign)CGFloat tipViewHeight;



-(void)reloadData;
//////背景方块
-(void)addSquareWithValueRect:(CGRect)valueRect color:(UIColor *)color style:(UIEdgeInsets)style;

/////文字

@end
