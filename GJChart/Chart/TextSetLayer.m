//
//  PointTextView.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/18.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import "TextSetLayer.h"
#import <UIKit/UIGraphics.h>

@implementation TextSetLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textDic = [[NSMutableDictionary alloc]init];
        _textAlignmentMargin = 4;
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx{
    UIGraphicsPushContext(ctx);
    [self drawText];
    UIGraphicsPopContext();

}
-(void)setTextDic:(NSMutableDictionary *)textDic{
    _textDic = textDic;
}
-(void)drawText{
//    NSDictionary *font=@{NSFontAttributeName: [UIFont systemFontOfSize:12.f],NSForegroundColorAttributeName:[UIColor yellowColor]};
    NSMutableDictionary* font = [[NSMutableDictionary alloc]init];
    if (_font != nil) {
        [font setObject:_font forKey:NSFontAttributeName];
    }
    if (_fontColor != nil) {
        [font setObject:_fontColor forKey:NSForegroundColorAttributeName];
    }

    for (NSValue* value in self.textDic.allKeys) {
        CGPoint point = [value CGPointValue];
        NSString* str = self.textDic[value];
        [str drawAtPoint:point withAttributes:font];
    }
}
-(void)addTextWithPoint:(CGPoint)point text:(NSString*)str textAlignment:(TextAlignment)alignment{
    
    point = [self transformPoint:point WithTextAlignment:alignment text:str];
    [self.textDic setObject:str forKey:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}
-(CGPoint)transformPoint:(CGPoint)point WithTextAlignment:(TextAlignment)alignment text:(NSString*)str{
    CGSize size = [str sizeWithAttributes: _font == nil ? nil : @{NSFontAttributeName:_font}];
    switch (alignment) {
        case TextAlignmentTop:
        {
            point.y += _textAlignmentMargin;
            point.x -= size.width*0.5;
        }
            break;
        case TextAlignmentTopLeft:
        {
            point.y += _textAlignmentMargin;
            point.x += _textAlignmentMargin;
        }
            break;
        case TextAlignmentTopRight:
        {
            point.y += _textAlignmentMargin;
            point.x -= _textAlignmentMargin + size.width;
        }
            break;
        case TextAlignmentBotton:
        {
            point.y -= size.height + _textAlignmentMargin;
            point.x -= size.width * 0.5;
        }
            break;
        case TextAlignmentBottonLeft:
        {
            point.y -= size.height + _textAlignmentMargin;
            point.x += _textAlignmentMargin;
        }
            break;
        case TextAlignmentBottonRight:
        {
            point.y -= size.height + _textAlignmentMargin;
            point.x -= size.width + _textAlignmentMargin;
        }
            break;
        case TextAlignmentCenter:
        {
            point.y -= size.height * 0.5;
            point.x -= size.width * 0.5;
        }
            break;
        case TextAlignmentLeft:
        {
            point.y -= size.height*0.5;
            point.x += _textAlignmentMargin;
        }
            break;
        case TextAlignmentRight:
        {
            point.y -= size.height*0.5;
            point.x -= size.width + _textAlignmentMargin;
        }
            break;
        case TextAlignmentNone:
            break;
    }
    return point;
}
-(void)addTextWithDic:(NSDictionary*)dic{
    
    for (NSValue* key in dic.allKeys) {
        [self.textDic setObject:dic[key] forKey:key];
    }

    [self setNeedsDisplay];
}
-(void)clear{  ///清除所有数据
    [self.textDic removeAllObjects];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
