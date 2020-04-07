//
//  TCImageHeaderScrollingAnimator.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/6.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCImageHeaderScrollingAnimator.h"

@implementation TCImageHeaderScrollingAnimator {
    UIView *_container;
    UIImageView *_imageView;
}

- (instancetype)init {
    self = [super init];
    _size = CGSizeMake(mScreenWidth, mScreenWidth/2);
    _relativeOffsetFactor = 0.5;
    _adjustsScrollIndicatorInsets = YES;
    [self didInitialize];
    return self;
}

- (void)dealloc {
    [_container removeFromSuperview];
}

- (void)didInitialize {
    _container = UIView.new;
    _container.clipsToBounds = YES;
    _container.frame = CGRectMake(0, -_size.height, _size.width, _size.height);
    _imageView = UIImageView.new;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.frame = CGRectMake(0, 0, _size.height, _size.width);
    [_container addSubview:_imageView];
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (@available(iOS 13.0, *)) {
        _scrollView.automaticallyAdjustsScrollIndicatorInsets = NO;
    }
    _scrollView.qmui_multipleDelegatesEnabled = YES;
    _scrollView.delegate = self;
    if (_adjustsScrollIndicatorInsets) {
        if (@available(iOS 11.1, *)) {
            _scrollView.verticalScrollIndicatorInsets = UIEdgeInsetsMake(_size.height, 0, 0, 0);
        } else {
            _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_size.height, 0, 0, 0);
        }
    }
    _scrollView.contentInset = UIEdgeInsetsMake(_size.height, 0, 0, 0);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _scrollView.contentOffset = CGPointMake(0, -_size.height);
    });
    
    [_scrollView addSubview:_container];
}

- (void)setAdjustScrollIndicatorInsets:(BOOL)adjustScrollIndicatorInsets {
    _adjustsScrollIndicatorInsets = adjustScrollIndicatorInsets;
    if (@available(iOS 11.1, *)) {
        _scrollView.verticalScrollIndicatorInsets = adjustScrollIndicatorInsets? UIEdgeInsetsMake(_size.height, 0, 0, 0) : UIEdgeInsetsZero;
    } else {
        _scrollView.scrollIndicatorInsets = adjustScrollIndicatorInsets? UIEdgeInsetsMake(_size.height, 0, 0, 0) : UIEdgeInsetsZero;
    }
}

- (void)setSize:(CGSize)size {
    [self setSize:size animated:NO];
}

- (void)setSize:(CGSize)size animated:(BOOL)animated {
    _size = size;
    [UIView qmui_animateWithAnimated:animated duration:.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        [self updateFrame];
        if (_adjustsScrollIndicatorInsets) {
            _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_size.height, 0, 0, 0);
        }
        _scrollView.contentInset = UIEdgeInsetsMake(_size.height, 0, 0, 0);
    } completion:nil];
    
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

- (CGFloat)scrollViewActualOffsetY {
    CGFloat offsetY = _scrollView.contentOffset.y;
    //contentInsets影响contentOffst
    CGFloat actualOffsetY = offsetY + _size.height;
    return actualOffsetY;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//     NSLog(@"offsetY - %f",self.scrollViewActualOffsetY);
    if (_adjustsScrollIndicatorInsets) {
        _scrollView.showsVerticalScrollIndicator = self.scrollViewActualOffsetY >= 0;
    }
    [self updateFrame];
}

- (void)updateFrame {
    CGFloat offsetY = self.scrollViewActualOffsetY;
    if (offsetY < 0) {
        _container.frame = CGRectMake(0, -_size.height + offsetY, _size.width, _size.height - offsetY);
        _imageView.frame = CGRectMake(0, 0, _size.width, _size.height - offsetY);
    } else{
        _container.frame = CGRectMake(0, -_size.height, _size.width, _size.height);
        _imageView.frame  = CGRectMake(0,  offsetY * _relativeOffsetFactor, _size.width, _size.height);
    }
}
@end
