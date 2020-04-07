//
//  FERectSpreadTransition.m
//  TransitionTest
//
//  Created by xueqooy on 2019/12/25.
//  Copyright © 2019年 GraduationpProject. All rights reserved.
//

#import "FERectSpreadTransition.h"

@implementation FERectSpreadTransition {
    FERectSpreadTransitionType _type;
    
    UIView *_targetViewTempView;
}

+ (instancetype)transitionWithType:(FERectSpreadTransitionType)type {
    FERectSpreadTransition *selfObject = [FERectSpreadTransition new];
    selfObject->_type = type;
    return selfObject;
}

- (instancetype)init {
    self = [super init];
    self.duration = 0.5;
    _type = FERectSpreadTransitionPresent;
    return self;
}

- (void)setTargetView:(UIView *)targetView {
    _targetView = targetView;
    _targetViewTempView = [_targetView snapshotViewAfterScreenUpdates:NO];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    
    if (_type == FERectSpreadTransitionPresent) {
        [self presentTransition:transitionContext fromViewController:fromVC toViewController:toVC containerView:containerView];
    } else {
        [self dismissTransition:transitionContext fromViewController:fromVC toViewController:toVC containerView:containerView];
    }
    
}

- (void)presentTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC containerView:(UIView *)containerView {
    [containerView addSubview:_targetViewTempView];
    [containerView addSubview:toVC.view];
    
    _targetViewTempView.frame = [_targetView convertRect:_targetView.bounds toView:containerView];
    _targetView.hidden = YES;
    toVC.view.alpha = 0;
    
    [UIView animateWithDuration:self.duration animations:^{
        toVC.view.alpha = 1.0;
        _targetViewTempView.frame = containerView.bounds;
        _targetViewTempView.alpha = 0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        _targetView.hidden = NO;

        if (self.didEndTransition) {
            self.didEndTransition(self.type);
        }
    }];
}

- (void)dismissTransition:(id<UIViewControllerContextTransitioning>)transitionContext  fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC  containerView:(UIView *)containerView {
    containerView.backgroundColor = UIColor.clearColor;
    [containerView addSubview: _targetViewTempView];
    [containerView addSubview:fromVC.view];
    
    _targetViewTempView.frame = containerView.bounds;
    _targetViewTempView.alpha = 0;

    [UIView animateWithDuration:self.duration animations:^{
        fromVC.view.alpha = 0;
        _targetViewTempView.frame = [_targetView convertRect:_targetView.bounds toView:toVC.view];
        _targetViewTempView.alpha = 1;
        
    } completion:^(BOOL finished) {
        [_targetViewTempView removeFromSuperview];
        [transitionContext completeTransition:YES];
        if (self.didEndTransition) {
            self.didEndTransition(self.type);
        }
    }];
}
@end
