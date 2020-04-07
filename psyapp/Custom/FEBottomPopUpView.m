//
//  FEBottomPopUpView.m
//  smartapp
//
//  Created by mac on 2019/12/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBottomPopUpView.h"

@implementation FEBottomPopUpView {
    UITapGestureRecognizer *_tapGestureRecognizer;
    UIView *_bottomSafeAreaPlaceHolderView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = mHexColorA(@"000000", 0.4);
    
    if (mBottomSafeHeight != 0) {
        _bottomSafeAreaPlaceHolderView = [UIView new];
        _bottomSafeAreaPlaceHolderView.frame = CGRectMake(0, mScreenHeight - mBottomSafeHeight, mScreenWidth, mBottomSafeHeight);
        [self addSubview:_bottomSafeAreaPlaceHolderView];
        
    }
    return self;
}

- (void)setClickBackgroundToHideEnable:(BOOL)clickBackgroundToHideEnable {
    if (clickBackgroundToHideEnable) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        _tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:_tapGestureRecognizer];
    } else {
        if (_tapGestureRecognizer) {
            [self removeGestureRecognizer:_tapGestureRecognizer];
            _tapGestureRecognizer = nil;
        }
    }
}

- (void)setContainerView:(UIView<FEBottomPopUpViewContainer> *)containerView {
    _containerView = containerView;
    @weakObj(self);
    if ([_containerView respondsToSelector:@selector(setHideAction:)]) {
        _containerView.hideAction = ^{
            @strongObj(self);
            [self hide];
        };
    }
    
}

- (void)show{
    if (!_containerView) {
        return;
    }
    
    if (_bottomSafeAreaPlaceHolderView) {
        _bottomSafeAreaPlaceHolderView.backgroundColor = UIColor.whiteColor;
    }
    
    [self addSubview:_containerView];
    CGRect frame = _containerView.frame;
    frame.origin.x = (mScreenWidth - frame.size.width) / 2;
    frame.origin.y = mScreenHeight - mBottomSafeHeight;
    _containerView.frame = frame;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    if ([_containerView respondsToSelector:@selector(willShow)]) {
        [_containerView willShow];
    }
    self.alpha = 0;

    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        _containerView.frame = CGRectMake(frame.origin.x, mScreenHeight - mBottomSafeHeight - frame.size.height, frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {
        if ([_containerView respondsToSelector:@selector(didShow)]) {
            [_containerView didShow];
        }
    }];
}

- (void)hide {
    CGRect frame = _containerView.frame;
    frame.origin.x = (mScreenWidth - frame.size.width) / 2;
    frame.origin.y = mScreenHeight - mBottomSafeHeight;

    [UIView animateWithDuration:0.15 animations:^{
        _containerView.frame = frame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if ([_containerView respondsToSelector:@selector(didHide)]) {
            [_containerView didHide];
        }
        [_containerView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.containerView]) {
        return NO;
    } else {
        return YES;
    }
}
@end
