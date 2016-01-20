//
//  PointTextView.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/18.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import "PointTextView.h"

@implementation PointTextView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    [self drawText];
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
-(void)addTextWithPoint:(CGPoint)point text:(NSString*)str{
    [self.textDic setObject:str forKey:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsDisplay];
}
-(void)addTextWithDic:(NSDictionary*)dic{
    
    for (NSValue* key in dic.allKeys) {
        [self.textDic setObject:dic[key] forKey:key];
    }
    [self setNeedsDisplay];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
