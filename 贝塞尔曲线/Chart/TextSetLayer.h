//
//  PointTextView.h
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/18.
//  Copyright © 2016年 tongguan. All rights reserved.
//
////表格中文字
#import <UIKit/UIColor.h>
#import <UIKit/UIView.h>
#import <UIKit/NSStringDrawing.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

typedef enum _TextAlignment{
    TextAlignmentNone = 0,
    TextAlignmentTop,
    TextAlignmentLeft,
    TextAlignmentBotton,
    TextAlignmentRight,
    TextAlignmentCenter,
    TextAlignmentTopLeft,
    TextAlignmentTopRight,
    TextAlignmentBottonLeft,
    TextAlignmentBottonRight,
}TextAlignment;
@interface TextSetLayer : CALayer
@property(nonatomic,retain,readonly)NSMutableDictionary* textDic;////[nsstring,cgpoint]
@property(nonatomic,retain)UIFont* font;////
@property(nonatomic,retain)UIColor* fontColor;////
@property(nonatomic,assign)CGFloat textAlignmentMargin;////   ///对齐时的距离 默认2， TextAlignmentNone则无事此属性



-(void)addTextWithDic:(NSDictionary*)dic;
-(void)addTextWithPoint:(CGPoint)point text:(NSString*)str textAlignment:(TextAlignment)alignment;
-(void)clear;  ///清除所有数据
@end
