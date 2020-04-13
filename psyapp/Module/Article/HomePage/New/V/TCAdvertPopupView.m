//
//  TCAdvertPopupView.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/30.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCAdvertPopupView.h"

@implementation TCAdvertPopupView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _maximumWidth = mScreenWidth - STWidth(30);
    _maximumHeight = mScreenHeight - mNavBarAndStatusBarHeight - mTabBarHeight;
    _spacingBetweenImageAndButton = STWidth(30);
    _buttonSize = STSize(32, 32);
    _hideWhenTapImage = YES;
    _hideAnimated = YES;
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = UIImageView.new;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction)];
        [_imageView addGestureRecognizer:tapRecognizer];

    }
    return _imageView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton new];
        [_closeButton setImage:[UIImage imageNamed:@"alert_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(hiddenAnimation:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeButton;
}

- (UIView *)layoutContainer {
    if (_imageView.image == nil) return nil;
    if (_imageView.image.size.width <= 0) return  nil;

    UIView *container = [UIView new];

    CGFloat originalHeight = _imageView.image.size.height;
    CGFloat originalWidth = _imageView.image.size.width;
    CGFloat adjustedHeight, adjustedWidth;
    if (originalWidth >= originalHeight) {
        adjustedWidth = _maximumWidth;
        adjustedHeight = originalHeight / originalWidth * adjustedWidth;
    } else {
        adjustedHeight = _maximumHeight - _spacingBetweenImageAndButton - _buttonSize.height;
        adjustedWidth = originalWidth/ originalHeight * adjustedHeight;
        CGFloat ratio = adjustedHeight / adjustedWidth;
        if(adjustedWidth > _maximumWidth) {
            adjustedWidth = _maximumWidth;
            adjustedHeight = adjustedWidth * ratio;
        }
    }

    container.frame = CGRectMake(0, 0, adjustedWidth, adjustedHeight + _spacingBetweenImageAndButton + _buttonSize.height);
    
    [container addSubview:self.imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(adjustedWidth, adjustedHeight));
        make.top.centerX.offset(0);
    }];
    
    [container addSubview:self.closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_buttonSize);
        make.bottom.centerX.offset(0);
    }];
    
    return container;
}


- (void)imageTapAction {
    if (self.didTapImage) {
        self.didTapImage();
    }
    if (_hideWhenTapImage) {
        [self hideWithAnimated:_hideAnimated completion:nil];
    }
}

- (void)hiddenAnimation:(UIButton *)sender {
    [self hideWithAnimated:_hideAnimated completion:nil];
}


@end
