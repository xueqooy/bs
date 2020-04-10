//
//  TCNestedScrollingAnimator.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/28.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCNestedScrollingAnimator.h"
@implementation TCNestedSimultaneousScrollView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([_mutexViews containsObject: otherGestureRecognizer.view]) {
        return NO;
    }
    return YES;
}

@end

@implementation TCNestedSimultaneousTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end

@implementation TCNestedScrollingAnimator  {
    BOOL _primaryScrollEnabled;
    BOOL _secondaryScrollEnabled;
    
    BOOL _primaryShowsVerticalScrollIndicator;
    BOOL _secondaryShowsVerticalScrollIndicator;
}
- (instancetype)init {
    self = [super init];
    _offsetYToEnableSecondaryScroll = 100;
    return self;
}

- (void)setPrimaryScrollView:(UIScrollView *)primaryScrollView {
    if (_primaryScrollView == primaryScrollView) return;
    if (_primaryScrollView && _primaryScrollView.qmui_multipleDelegatesEnabled) {
        [_primaryScrollView qmui_removeDelegate:self];
    }
    _primaryScrollView = primaryScrollView;
    _primaryShowsVerticalScrollIndicator = primaryScrollView.showsVerticalScrollIndicator;
    if (_secondaryScrollView.qmui_multipleDelegatesEnabled == NO) {
        _secondaryScrollView.qmui_multipleDelegatesEnabled = YES;
    }
    _primaryScrollView.delegate = self;
    [self checkSimultaneous:_primaryScrollView];
    _primaryScrollEnabled = YES;
}

- (void)setSecondaryScrollView:(UIScrollView *)secondaryScrollView {
    if (_secondaryScrollView == secondaryScrollView) return;
    if (_secondaryScrollView && _secondaryScrollView.qmui_multipleDelegatesEnabled) {
        [_secondaryScrollView qmui_removeDelegate:self];
    }
    _secondaryScrollView = secondaryScrollView;
    _secondaryShowsVerticalScrollIndicator = _secondaryScrollView.showsVerticalScrollIndicator;
    if (_secondaryScrollView.qmui_multipleDelegatesEnabled == NO) {
        _secondaryScrollView.qmui_multipleDelegatesEnabled = YES;
    }
    _secondaryScrollView.delegate = self;
}

- (void)setPrimaryScrollEnabled:(BOOL)enabled {
    if (_primaryScrollEnabled == enabled) return;
    _primaryScrollEnabled = enabled;
    if (_primaryScrollEnabled) {
        _secondaryScrollView.contentOffset = CGPointZero;
    }
    
    if (_primaryScrollableBlock) {
        _primaryScrollableBlock();
    }
}

- (void)setSecondaryScrollEnabled:(BOOL)enabled {
    if (_secondaryScrollEnabled == enabled) return;
    _secondaryScrollEnabled = enabled;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _primaryScrollView) {
        if (_primaryScrollEnabled == NO) {
            self.secondaryScrollEnabled = YES;
            scrollView.contentOffset = CGPointMake(0, _offsetYToEnableSecondaryScroll);

        } else if (scrollView.contentOffset.y >= _offsetYToEnableSecondaryScroll) {
            self.primaryScrollEnabled = NO;
            self.secondaryScrollEnabled = YES;
            scrollView.contentOffset = CGPointMake(0, _offsetYToEnableSecondaryScroll);
        }
        if (_primaryShowsVerticalScrollIndicator) {
            _primaryScrollView.showsVerticalScrollIndicator = _primaryScrollEnabled;
        }
    } else if (scrollView == _secondaryScrollView){
       //设置-1，防止与primaryScrollView交互时向下方向锁死
        if (_secondaryScrollViewTopBounces == NO) {
            scrollView.bounces = scrollView.contentOffset.y > -1;
        }
        

        if (_secondaryScrollEnabled == NO) {
            scrollView.contentOffset = CGPointZero;
            
        } else if (scrollView.contentOffset.y <= 0) {
            self.secondaryScrollEnabled = NO;
            self.primaryScrollEnabled = YES;
        }
        if (_secondaryShowsVerticalScrollIndicator) {
            _secondaryScrollView.showsVerticalScrollIndicator = _secondaryScrollEnabled;
        }
    }
}

- (void)checkSimultaneous:(UIScrollView *)scrollView {
    if ([scrollView respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        
        NSAssert([scrollView performSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:) withObject:nil withObject:nil], @"%@ is not simultaneous", scrollView);
    } else {
        NSAssert(NO, @"%@ is not simultaneous", scrollView);
    }
}

@end
