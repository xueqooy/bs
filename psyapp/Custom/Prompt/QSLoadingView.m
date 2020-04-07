//
//  QSLoadingView.m
//  app
//
//  Created by linjie on 17/3/25.
//  Copyright © 2017年 jeyie0. All rights reserved.
//

#import "QSLoadingView.h"

@implementation QSLoadingView
static QSLoadingView *instance = nil;

+ (instancetype)reusableInstance {
    if (instance) {
        if (instance.parentView != mKeyWindow) {
            [instance removeFromSuperview];
            instance = [[QSLoadingView alloc] initWithView:mKeyWindow];
        }
    } else {
        instance = [[QSLoadingView alloc] initWithView:mKeyWindow];
    }
    return instance;
}

+ (void)show {
    QSLoadingView *loadingView = [QSLoadingView reusableInstance];
    if (!loadingView.superview) {
        [loadingView.parentView addSubview:loadingView];
    }
    [loadingView.parentView bringSubviewToFront:loadingView];
    [loadingView showLoading];
}

+ (void)dismiss {
    if (instance) {
        [instance hideAnimated:YES];
    }
}

@end
