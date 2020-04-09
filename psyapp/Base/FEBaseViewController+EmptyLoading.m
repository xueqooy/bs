//
//  FEBaseViewController+EmptyLoading.m
//  smartapp
//
//  Created by mac on 2020/1/15.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import "FEBaseViewController+EmptyLoading.h"
#import <QMUIRuntime.h>
#import <QMUILab.h>

@implementation FEBaseViewController (EmptyLoading)

QMUISynthesizeIdWeakProperty(emptyView, setEmptyView)
QMUISynthesizeIdStrongProperty(loadingPlaceholderView, setLoadingPlaceholderView)
QMUISynthesizeUIEdgeInsetsProperty(emptyViewInsets, setEmptyViewInsets)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        ExtendImplementationOfNonVoidMethodWithoutArguments([self class], @selector(init), FEBaseViewController *, ^FEBaseViewController *(FEBaseViewController *selfObject, FEBaseViewController *originReturnValue) {
            selfObject.emptyViewInsets = UIEdgeInsetsZero;
            return originReturnValue;
        });
    });
}

- (void)showEmptyViewInView:(UIView *)view type:(FEErrorType)type {
    if (view != self.view && ![view isDescendantOfView:self.view]) {
        return;
    }
   
    if (self.emptyView) {
        [self.emptyView removeFromSuperview];
    }
    __weak typeof(self) weakSelf = self;
    EmptyErrorView *emptyView = [[EmptyErrorView alloc] initWithType:type fatherView:view insets:self.emptyViewInsets];

    if (type == FEErrorType_Vistor) {
        emptyView.refreshIndex = ^(NSInteger index) {
            if(UCManager.sharedInstance.isVisitorPattern){
                [NSNotificationCenter.defaultCenter postNotificationName:nc_window_root_switch object:WINDOW_ROOT_LOGIN];
            }
        };
    }
    
    emptyView.extraHandler = ^{
        [weakSelf hideEmptyView];
    };
    
    self.emptyView = emptyView;
}

- (void)showEmptyViewForNoNetInView:(UIView *)view refreshHandler:(void (^)(void))handler {

    [self showEmptyViewInView:view type:FEErrorType_NoNet];
    
    self.emptyView.refreshIndex = ^(NSInteger index) {
        if (handler) {
            handler();
        }
    };
}

- (void)hideEmptyView {
    if (self.emptyView) {
        //使用tempView,防止在hide动画结束前，再次创建出一个实例，导致新的实例被移除
        UIView *tempView = self.emptyView;
        [UIView animateWithDuration:0.25 animations:^{
            tempView.alpha = 0;
        } completion:^(BOOL finished) {
            [tempView removeFromSuperview];
        }];
    }
}

- (void)showLoadingPlaceHolderViewInView:(UIView *)view type:(FESketonType)type{
    NSString *sketonName = type == FESketonTypeArticle ? @"article_sketon" : @"test_detail_sketon";
    self.loadingPlaceholderView = [FELoadingPlaceholderView new];
    self.loadingPlaceholderView.GIFImageName = sketonName;
    self.loadingPlaceholderView.frame = view.bounds;
    [view addSubview:self.loadingPlaceholderView];
}

- (void)hideLoadingPlaceholderView {
    if (self.loadingPlaceholderView) {
        [UIView animateWithDuration:0.25 animations:^{
            self.loadingPlaceholderView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.loadingPlaceholderView removeFromSuperview];
            self.loadingPlaceholderView = nil;
        }];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.loadingPlaceholderView && self.loadingPlaceholderView.superview && !self.emptyView) {
        [self.loadingPlaceholderView.superview bringSubviewToFront:self.loadingPlaceholderView];
    }
    
    if (self.emptyView && self.emptyView.superview) {
        [self.emptyView.superview bringSubviewToFront:self.emptyView];
        [self.emptyView updateLayoutWithInsets:self.emptyViewInsets];
    }
}

@end
