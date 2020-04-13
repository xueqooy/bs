//
//  FEBaseAlertView.m
//  smartapp
//
//  Created by mac on 2019/8/2.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseAlertView.h"
#import "UIView+DCAnimationKit.h"
@interface FEBaseAlertView() <UIGestureRecognizerDelegate>
@property(nonatomic, strong, readwrite) UIView *containerView;
@end


@implementation FEBaseAlertView

const NSInteger FEBaseAlertViewContainerTag = 11111;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.context = mKeyWindow;
        self.backgroundColor = mHexColorA(@"000000", 0);
    }
    return self;
}

- (void)showWithAnimated:(BOOL)animated {
    self.hidden = NO;
    _containerView = [self layoutContainer];
    _containerView.tag = FEBaseAlertViewContainerTag;
    [self addSubview:_containerView];
    
    if (_containerView == nil) {
        return;
    }
    
    if (!animated) {
        _containerView.layer.position = self.center;
        [self.context addSubview:self];
        self.backgroundColor = mHexColorA(@"000000", 0.4);
        return;
    }
    
    [self.context addSubview:self];
    
    CGPoint showAnimateStartPoint = CGPointMake(self.center.x, mScreenHeight);
    _containerView.layer.position = showAnimateStartPoint;
    _containerView.transform = CGAffineTransformMakeScale(0.70, 0.70);
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        _containerView.layer.position = self.center;
        _containerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backgroundColor = mHexColorA(@"000000", 0.4);
    
    } completion:^(BOOL finished) {
        if (!_backgroundTapDisable) {
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
            [self addGestureRecognizer:tapGestureRecognizer];
        }
        
    }];
    
}

- (void)hideWithAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (!animated) {
        self.hidden = YES;
        [_containerView removeFromSuperview];
        [self removeFromSuperview];
        
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = mHexColorA(@"000000", 0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [_containerView removeFromSuperview];
    }];
    
    [_containerView drop:^{
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

- (void)tapEvent:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self];
    if (!CGRectContainsPoint(_containerView.frame, point)) { //点击了背景
        [self hideWithAnimated:!_backgroundTapDisable completion:_extraHandlerForClickingBackground? _extraHandlerForClickingBackground: nil];
    }
}

- (UIView *)layoutContainer {
    return nil;
}
@end
