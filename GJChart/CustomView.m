//
//  CustomView.m
//  贝塞尔曲线
//
//  Created by tongguan on 16/1/5.
//  Copyright © 2016年 tongguan. All rights reserved.
//

#import "CustomView.h"
@interface CustomView()
{
    CAShapeLayer* shapeLayer;
}
@end

@implementation CustomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        shapeLayer = [[CAShapeLayer alloc]init];
        shapeLayer.fillColor = [UIColor greenColor].CGColor;
        shapeLayer.backgroundColor = [UIColor yellowColor].CGColor;
        shapeLayer.lineWidth = 2.0;
        shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        shapeLayer.anchorPoint = (CGPoint){0.5,0.5};
        [self.layer addSublayer:shapeLayer];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsDisplay];
    shapeLayer.frame = CGRectMake(frame.size.width * 0.25, frame.size.width * 0.25, frame.size.width*0.5, frame.size.height*0.5);

}
-(void)drow1{
    CABasicAnimation* anima = [CABasicAnimation animationWithKeyPath:@"path"];

    UIBezierPath* path = [UIBezierPath bezierPath];
    CGPoint point = (CGPoint){0,0};
    [path moveToPoint:point];
    
    point.x = shapeLayer.bounds.size.width;point.y = 0;
    [path addLineToPoint:point];
    
    point.x = 0;point.y = shapeLayer.bounds.size.height;
    [path addLineToPoint:point];
    
    point.x = shapeLayer.bounds.size.width;point.y = shapeLayer.bounds.size.height;
    [path addLineToPoint:point];
    
    shapeLayer.path = path.CGPath;

    
    [shapeLayer addAnimation:anima forKey:nil];


}
-(void)drow2{
    CABasicAnimation* anima = [CABasicAnimation animationWithKeyPath:@"path"];

    UIBezierPath* path = [UIBezierPath bezierPath];
    CGPoint point = (CGPoint){shapeLayer.bounds.size.width / 2.0,0};
    [path moveToPoint:point];
    point.x = 0;point.y = shapeLayer.bounds.size.height;
    [path addLineToPoint:point];
    
    point.x = shapeLayer.bounds.size.width;point.y = shapeLayer.bounds.size.height;
    [path addLineToPoint:point];
    
    shapeLayer.path = path.CGPath;

    [shapeLayer addAnimation:anima forKey:nil];

//    shapeLayer.strokeStart = 0.2;
//    shapeLayer.strokeEnd = 0.7;
    
}
-(void)drow3{
//    CABasicAnimation* anima = [CABasicAnimation animationWithKeyPath:@"path"];

//    UIBezierPath* path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0, 0)];
//    [path addLineToPoint: (CGPoint){shapeLayer.bounds.size.width,shapeLayer.bounds.size.height}];
//    
//    [shapeLayer addAnimation:anima forKey:nil];
//    shapeLayer.path = path.CGPath;
    
//    shapeLayer.strokeStart = 0.2;
//    shapeLayer.strokeEnd = 0.7;
    
}
-(void)drow4{
    CABasicAnimation* anima = [CABasicAnimation animationWithKeyPath:@"path"];
    

    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:shapeLayer.bounds];
    shapeLayer.path = path.CGPath;
    
    [shapeLayer addAnimation:anima forKey:nil];
//    shapeLayer.strokeStart = 0.2;
//    shapeLayer.strokeEnd = 0.7;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    shapeLayer.strokeColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1].CGColor;
//    shapeLayer.strokeStart = arc4random()%255 / 255.0;
//    shapeLayer.strokeEnd = arc4random()%255 / 255.0;
    int result = arc4random()%4 +1;
    NSLog(@"result:%d",result);
    switch (result) {
        case 1:
            [self drow1];
            
            break;
        case 2:
            [self drow2];
            break;
        case 3:
            [self drow3];
            break;
        case 4:
            [self drow4];
            break;
            
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/

@end
