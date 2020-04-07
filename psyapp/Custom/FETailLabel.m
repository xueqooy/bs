//
//  FETailLabel.m
//  smartapp
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FETailLabel.h"

@implementation FETailLabel {
    CAShapeLayer *roundRectLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
   // [self drawRoundRect];
    _textInsets = UIEdgeInsetsMake(0, CGRectGetHeight(self.bounds) / 6.0 , 0, 0);
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self drawRoundRect];
}



- (void)drawRoundRect {
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width  = CGRectGetWidth(self.bounds);
    CGFloat radius = height / 6.0;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [self drawTailForPath:path];
    
    //绘制圆角
    [path addArcWithCenter:CGPointMake(2 *radius, radius) radius:radius startAngle:M_PI endAngle:M_PI * 1.5 clockwise:YES];
    [path addArcWithCenter:CGPointMake(width - radius, radius) radius:radius startAngle:M_PI * 1.5 endAngle:0 clockwise:YES];
    [path addArcWithCenter:CGPointMake(width - radius, height - radius) radius:radius startAngle:0 endAngle:M_PI / 2.0 clockwise:YES];
    [path addArcWithCenter:CGPointMake(2 * radius, height - radius) radius:radius startAngle:M_PI / 2.0 endAngle:M_PI clockwise:YES];

    [path closePath];
    [mMainColor setFill];
    
    roundRectLayer = [CAShapeLayer layer];
    roundRectLayer.path = path.CGPath;
    
    self.layer.mask = roundRectLayer;
}

- (void)drawTailForPath:(UIBezierPath *)path {
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat radius = height / 6.0;
    //绘制小尾巴
    [path moveToPoint:CGPointMake(radius, height / 3.0)];
    [path addLineToPoint:CGPointMake(0, height / 2.0)];
    [path addLineToPoint:CGPointMake(radius, height / 3.0 * 2.0)];
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}
@end
