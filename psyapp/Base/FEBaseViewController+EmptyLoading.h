//
//  FEBaseViewController+EmptyLoading.h
//  smartapp
//
//  Created by mac on 2020/1/15.
//  Copyright © 2020 jeyie0. All rights reserved.
//

#import "FEBaseViewController.h"
#import "EmptyErrorView.h"
#import "FELoadingPlaceholderView.h"

@interface FEBaseViewController (EmptyLoading)
@property (nonatomic, weak) EmptyErrorView *emptyView;
@property (nonatomic, strong) FELoadingPlaceholderView *loadingPlaceholderView;

- (void)showEmptyViewInView:(UIView *)view type:(FEErrorType)type;
- (void)showEmptyViewForNoNetInView:(UIView *)view refreshHandler:(void(^)(void))handler;
- (void)hideEmptyView;

- (void)showLoadingPlaceHolderViewInView:(UIView *)view;
- (void)hideLoadingPlaceholderView;
@end

