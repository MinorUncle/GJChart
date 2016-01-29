//
//  PointCircularLayer.h
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/19.
//  Copyright © 2016年 tongguan. All rights reserved.
//

//点集合
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CircularPointSetLayer : CAShapeLayer
@property(nonatomic,retain)UIColor* insideColor;   
@property(nonatomic,retain)UIColor* outsideColor;
@property(nonatomic,assign)CGFloat smallRadius;
@property(nonatomic,assign)CGFloat bigRadius;

-(void)addCircularToPoint:(CGPoint)point;
@end
