//
//  PointCircularLayer.h
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/19.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface PointCircularLayer : CALayer
@property(nonatomic,retain)UIColor* insideColor;   
@property(nonatomic,retain)UIColor* outsideColor;

-(void)addCircularToPoint:(CGPoint)point;
@end
