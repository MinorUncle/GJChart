//
//  PolygonLayer.h
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/20.
//  Copyright © 2016年 tongguan. All rights reserved.
//多边形

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface PolygonLayer : CALayer
-(void)addAreaWithPoints:(NSArray<NSValue*>*)points  color:(UIColor*)color;
@end
