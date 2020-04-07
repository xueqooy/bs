//
//  FECourseSurplusLabel.m
//  smartapp
//
//  Created by mac on 2019/11/6.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FECourseSurplusView.h"

@implementation FECourseSurplusView {
    CAShapeLayer *_maskLayer;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.radius = STWidth(4);
    self.arrowWidth = STWidth(15);
    self.borderColor = [UIColor clearColor];
    self.fillColor = UIColor.redColor;
    self.borderWidth = 0;
    _labelHeight = STWidth(18);
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _labelHeight)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = STFontRegular(12);
    self.titleLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    self.titleLabel.textColor = UIColor.whiteColor;
    [self addSubview:self.titleLabel];
    
    [self qmui_registerThemeColorProperties:@[NSStringFromSelector(@selector(fillColor)), NSStringFromSelector(@selector(borderColor))]];
    return self;
}

- (void)setLabelHeight:(CGFloat)labelHeight {
    _labelHeight = labelHeight;
    self.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _labelHeight);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_maskLayer) {
        [_maskLayer removeFromSuperlayer];
    }
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    _maskLayer = maskLayer;
    maskLayer.frame = self.bounds;
    
    //[self.borderColor set];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
   // path.lineWidth = self.borderWidth;
    CGFloat labelHeight = _titleLabel.bounds.size.height;
    //绘制三角
  
    [path moveToPoint:CGPointMake(CGRectGetMidX(self.bounds) - _arrowWidth/2, labelHeight)];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(self.bounds) + _arrowWidth/2, labelHeight)];
  
    //绘制边缘
    
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds) - _radius, labelHeight)];
    [path addQuadCurveToPoint:CGPointMake(CGRectGetMaxX(self.bounds), labelHeight - _radius) controlPoint:CGPointMake(CGRectGetMaxX(self.bounds), labelHeight)];
          
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), _radius)];
    [path addQuadCurveToPoint:CGPointMake(CGRectGetMaxX(self.bounds) - _radius, 0) controlPoint:CGPointMake(CGRectGetMaxX(self.bounds), 0)];
          
    [path addLineToPoint:CGPointMake(_radius, 0)];
    [path addQuadCurveToPoint:CGPointMake(0, _radius) controlPoint:CGPointMake(0, 0)];
          
    [path addLineToPoint:CGPointMake(0, labelHeight - _radius)];
    [path addQuadCurveToPoint:CGPointMake(_radius, labelHeight) controlPoint:CGPointMake(0, labelHeight )];
    [path closePath];
//[path stroke];
    
    maskLayer.path = path.CGPath;
    
    maskLayer.fillColor = self.fillColor.CGColor;
    maskLayer.lineWidth = self.borderWidth;
    maskLayer.strokeColor = self.borderColor.CGColor;
    [self.layer addSublayer: maskLayer];
    [self bringSubviewToFront:_titleLabel];
}

@end
