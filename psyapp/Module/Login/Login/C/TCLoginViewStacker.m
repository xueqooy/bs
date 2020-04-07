//
//  TCLoginViewStacker.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/11.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCLoginViewStacker.h"
@interface TCLoginViewStacker ()
@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, strong) NSMutableArray *stacker;
@end

@implementation TCLoginViewStacker
- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    self.viewController = viewController;
    return self;
}

- (NSMutableArray *)stacker {
    if (_stacker == nil) {
        _stacker = @[].mutableCopy;
    }
    return _stacker;
}

- (UIView *)currentView {
    if (self.stacker.count > 0) {
        return _stacker.lastObject;
    }
    return nil;
}

- (void)pushView:(UIView *)view onCompletion:(void (^)(UIView * _Nonnull))completion {
    if (!view) return;
    if (self.currentView == view) return;
    
    [self.stacker addObject:view];
    view.hidden = NO;
    CGFloat w = view.width;
    CGFloat h = view.height;
    [view setFrame:CGRectMake(CGRectGetWidth(_viewController.view.frame), 0, w, h)];
    [_viewController.view bringSubviewToFront:view];
    [UIView animateWithDuration:0.3 animations:^{
        [view setFrame:CGRectMake(0, 0 , w, h)];
    } completion:^(BOOL finished) {
        if (completion) {
            completion(view);
        }
    }];
    
    [_viewController.view endEditing:YES];
    
    [self updateViewControllerLeftButtonItemHidden];
}

- (void)popViewOnCompletion:(void (^)(UIView * _Nonnull))completion {
    UIView *popedView = self.currentView;
    popedView.hidden = NO;
    CGFloat w = popedView.width;
    CGFloat h = popedView.height;
    [popedView setFrame:CGRectMake(0, 0, w, h)];

    [UIView animateWithDuration:0.3 animations:^{
        [popedView setFrame:CGRectMake(w, 0 , w, h)];
    } completion:^(BOOL finished) {
        popedView.hidden = YES;
        if (completion) {
            completion(popedView);
        }
    }];
    
    [self.stacker removeLastObject];
    [self updateViewControllerLeftButtonItemHidden];
}

- (void)replaceCurrentViewWithView:(UIView *)view {
    self.currentView.hidden = YES;
    [self.stacker removeLastObject];
    view.hidden = NO;
    CGFloat w = view.width;
    CGFloat h = view.height;
    [view setFrame:CGRectMake(0, 0, w, h)];
    [self.stacker addObject:view];
}

- (void)updateViewControllerLeftButtonItemHidden {
    if (_viewCountChangeHandler) {
        _viewCountChangeHandler(self.stacker.count);
    }
}

@end
