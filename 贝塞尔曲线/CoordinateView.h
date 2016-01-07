//
//  CoordinateView.h
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/5.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface CoordinateView : UIView
@property(nonatomic,assign)CGFloat MaxY; ///最大Y
@property(nonatomic,assign)CGFloat MaxX;
@property(nonatomic,assign)NSInteger countY;  ////y的一个大单元包含小单元的数量
@property(nonatomic,assign)NSInteger countX;
@property(nonatomic,assign)CGFloat unitY;  ////一个小Y的单位
@property(nonatomic,assign)CGFloat unitX;
@property(nonatomic,retain)UIColor* color;
@property(nonatomic,assign)CGPoint beginValue;
@property(nonatomic,assign)float speed;   //动画速度 ///未使用


-(void)addValue:(CGPoint)value;


@end
