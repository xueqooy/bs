//
//  FESwitch.m
//  smartapp
//
//  Created by mac on 2019/8/21.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FESwitch.h"
#import "FastClickUtils.h"

@implementation FESwitch {
    CAShapeLayer *thumbLayer;
    CAShapeLayer *trackLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _onTintColor = mHexColor(@"ffc342");
    _offTintColor = mHexColor(@"f0f2f5");
    _thumbTintColor = mHexColor(@"ffffff");
    _thumbShadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    _switchAnimationDuration =  0.25;
    _on = NO;
    [self setupSubviews];
    [self addTapGesture];
    [self registeThemeColorProperty];
    return self;
}

- (void)registeThemeColorProperty {
    [self qmui_registerThemeColorProperties:@[NSStringFromSelector(@selector(onTintColor)),
                                              NSStringFromSelector(@selector(offTintColor)),
                                              NSStringFromSelector(@selector(thumbTintColor)),
                                              NSStringFromSelector(@selector(thumbShadowColor))
    ]];
}

- (void)setupSubviews {
    trackLayer = [CAShapeLayer layer];
    trackLayer.frame = CGRectMake(0, CGRectGetHeight(self.frame) * 7.5/44.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * 15.0/22.0);
    trackLayer.fillColor = _offTintColor.CGColor;
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:trackLayer.bounds cornerRadius:CGRectGetHeight(self.frame) * 15.0/44.0];
    trackLayer.path = path1.CGPath;
    [self.layer addSublayer:trackLayer];
    
    thumbLayer = [CAShapeLayer layer];
    thumbLayer.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
    thumbLayer.fillColor = _thumbTintColor.CGColor;
    //绘制形状
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:thumbLayer.bounds cornerRadius:CGRectGetHeight(self.frame)/2];
    thumbLayer.path = path2.CGPath;
    //绘制阴影
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:thumbLayer.bounds];
    thumbLayer.shadowPath = shadowPath.CGPath;
    thumbLayer.shadowColor = _thumbShadowColor.CGColor;
    thumbLayer.shadowOffset = CGSizeMake(0,2);
    thumbLayer.shadowOpacity = 1;
    thumbLayer.shadowRadius = 5;
    [self.layer addSublayer:thumbLayer];
    
}

- (void)addTapGesture {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self  action: @selector(tapAction:)]];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (![FastClickUtils isFastClick]) {
       [TCSystemFeedbackHelper impactLight];
        [self setOn:!_on];
    }
}

- (void)setOn:(BOOL)on hasHandler:(BOOL)has {
    if (has) {
        [self setOn:on];
    } else {
        if (_on != on) {
            _on = on;
            
            [UIView animateWithDuration:_switchAnimationDuration animations:^{
                if (_on) {
                    thumbLayer.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
                    trackLayer.fillColor = _onTintColor.CGColor;
                } else {
                    thumbLayer.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
                    trackLayer.fillColor = _offTintColor.CGColor;
                }
            } completion:nil];

        }
    }
}

- (void)setOn:(BOOL)on {
    if (_on != on) {
        _on = on;
        
        [UIView animateWithDuration:_switchAnimationDuration animations:^{
            if (_on) {
                thumbLayer.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame) + STWidth(1), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
                trackLayer.fillColor = _onTintColor.CGColor;
            } else {
                thumbLayer.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
                trackLayer.fillColor = _offTintColor.CGColor;
            }
        } completion:^(BOOL finished) {
            if (_switchHandler) {
                _switchHandler(_on);
            }
        }];
        
    }
}

- (void)setOffTintColor:(UIColor *)offTintColor {
    if (_offTintColor != offTintColor) {
        _offTintColor = offTintColor;
        if (!_on) {
            trackLayer.fillColor = offTintColor.CGColor;
        }
    }
}

- (void)setOnTintColor:(UIColor *)onTintColor {
    if (_onTintColor != onTintColor) {
        _onTintColor = onTintColor;
        if (_on) {
            trackLayer.fillColor = onTintColor.CGColor;
        }
    }
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor {
    if (_thumbTintColor != thumbTintColor) {
        _thumbTintColor = thumbTintColor;
        thumbLayer.fillColor = thumbTintColor.CGColor;
    }
}

- (void)setThumbShadowColor:(UIColor *)thumbShadowColor {
    if (_thumbShadowColor != thumbShadowColor) {
        _thumbShadowColor = thumbShadowColor;
        thumbLayer.shadowColor = thumbShadowColor.CGColor;
    }
}

- (void)setAttachView:(UIView *)attachView {
    if (attachView) {
        if (_attachView) {
            [_attachView removeFromSuperview];
        }
        _attachView = attachView;
        [self addSubview:_attachView];
        //放置在左边
        _attachView.transform = CGAffineTransformTranslate(_attachView.transform, - CGRectGetWidth(_attachView.frame), 0);
    }
}
@end
