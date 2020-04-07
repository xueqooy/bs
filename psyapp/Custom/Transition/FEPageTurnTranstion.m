//
//  FEPageTurnTranstion.m
//  smartapp
//
//  Created by mac on 2020/1/9.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import "FEPageTurnTranstion.h"

@implementation FEPageTurnTranstion

+ (instancetype)transitionWithType:(FEPageTurnTranstionType)type {
    FEPageTurnTranstion *selfObject = [FEPageTurnTranstion new];
    selfObject->_type = type;
    return selfObject;
}

- (instancetype)init {
    self = [super init];
    self.duration = 0.25;
    _type = FEPageTurnTranstionNext;
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_type == FEPageTurnTranstionNext) {
        [self doTransitionForNextWithContext:transitionContext];
    } else {
        [self doTranstionForPreviousWithContext:transitionContext];
    }
}
 
- (void)doTransitionForNextWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    
    toView.transform = CGAffineTransformMakeTranslation(mScreenWidth, 0);
    
    [UIView animateWithDuration:self.duration animations:^{
        fromView.transform = CGAffineTransformMakeTranslation(-mScreenWidth, 0);
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:YES];
    }];
}

- (void)doTranstionForPreviousWithContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    
    toView.transform = CGAffineTransformMakeTranslation(-mScreenWidth, 0);
    
    [UIView animateWithDuration:self.duration animations:^{
        fromView.transform = CGAffineTransformMakeTranslation(mScreenWidth, 0);
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:YES];
    }];
}
@end
