//
//  PointTextView.h
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/18.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointTextView : UIView
@property(nonatomic,retain,readonly)NSMutableDictionary* textDic;////[nsstring,cgpoint]
@property(nonatomic,retain)NSFont* font;////
@property(nonatomic,retain)UIColor* fontColor;////


-(void)addTextWithDic:(NSDictionary*)dic;
-(void)addTextWithPoint:(CGPoint)point text:(NSString*)str;
@end
