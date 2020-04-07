//
//  TCPopupContainerView.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/6.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCPopupContainerView.h"

@interface TCPopupContainerMaskControl : UIControl
@property (nonatomic, weak) TCPopupContainerView *popupContainerView;
@end

@implementation TCPopupContainerView {
    UIView *_contentView;
    UILabel *_titleLabel;
    UIView *_titleLabelContainer;
    UIButton *_hideButton;
    UIView *_displayViewContainer;
    
    CGFloat _titleContainerHeight;
    CGFloat _hideButtonHeight;
    
    CGFloat _finalheight;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _limitedMaxHeight = STWidth(316);
    _limitedMinHeight = STWidth(280);
    _titleContainerHeight = STWidth(56);
    _hideButtonHeight = STWidth(48);
    [self initializeUI];
    return self;
}

- (void)initializeUI {
    TCPopupContainerMaskControl *maskControl = TCPopupContainerMaskControl.new;
    maskControl.popupContainerView = self;
    [self addSubview:maskControl];
    [maskControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    _contentView = UIView.new;
    
    _titleLabelContainer = UIView.new;
    _titleLabelContainer.backgroundColor = UIColor.fe_contentBackgroundColor;
    _titleLabelContainer.qmui_borderWidth = STWidth(0.5);
    _titleLabelContainer.qmui_borderPosition = QMUIViewBorderPositionBottom;
    _titleLabelContainer.qmui_borderColor = UIColor.fe_separatorColor;
//    CAShapeLayer *shapeLayer = CAShapeLayer.layer;
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, mScreenWidth, _titleContainerHeight + STWidth(1)) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(STWidth(16), STWidth(16))];
//    shapeLayer.path = path.CGPath;
//    _titleLabelContainer.layer.mask = shapeLayer;
    [_contentView addSubview:_titleLabelContainer];
    [_titleLabelContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.mas_equalTo(_titleContainerHeight);
    }];
    
    _titleLabel = [UILabel.alloc qmui_initWithFont:STFontBold(18) textColor:UIColor.fe_titleTextColor];
    [_titleLabelContainer addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(STWidth(15));
        make.centerY.offset(0);
    }];
    
    _hideButton = UIButton.new;
    _hideButton.titleLabel.font = STFontRegular(14);
    _hideButton.backgroundColor = UIColor.fe_contentBackgroundColor;
    [_hideButton setTitle:@"取消" forState:UIControlStateNormal];
    [_hideButton setTitleColor:UIColor.fe_mainColor forState:UIControlStateNormal];
    [_hideButton setTitleColor:[UIColor.fe_mainColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//    _hideButton.qmui_borderWidth = STWidth(0.5);
//    _hideButton.qmui_borderPosition = QMUIViewBorderPositionTop;
//    _hideButton.qmui_borderColor = UIColor.fe_separatorColor;
    [_hideButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_hideButton];
    [_hideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(-mBottomSafeHeight);
        make.height.mas_equalTo(_hideButtonHeight);
    }];
    
    _displayViewContainer = UIView.new;
    _displayViewContainer.backgroundColor = UIColor.fe_contentBackgroundColor;
    [_contentView addSubview:_displayViewContainer];
    [_displayViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(_titleLabelContainer.mas_bottom);
        make.bottom.equalTo(_hideButton.mas_top);
    }];
    
    if (mBottomSafeHeight > 0) {
        UIView *placeholderView = UIView.new;
        placeholderView.backgroundColor = UIColor.fe_contentBackgroundColor;
        [_contentView addSubview:placeholderView];
        [placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.offset(0);
            make.height.mas_equalTo(mBottomSafeHeight);
        }];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setPrefersHideButtonHidden:(BOOL)prefersHideButtonHidden {
    if (_prefersHideButtonHidden == prefersHideButtonHidden) return;
    _prefersHideButtonHidden = prefersHideButtonHidden;
    if (_prefersHideButtonHidden) {
        _hideButtonHeight = 0;
        _hideButton.hidden = YES;
        [_hideButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_hideButtonHeight);
        }];
    } else {
        //TODO:
    }
}

- (void)setPrefersHideTitle:(BOOL)prefersHideTitle {
    if (_prefersHideTitle == prefersHideTitle) return;
    _prefersHideTitle = prefersHideTitle;
    if (_prefersHideTitle) {
        _titleContainerHeight = 0;
        _titleLabelContainer.hidden = YES;
        [_titleLabelContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_titleContainerHeight);
        }];
    } else {
        //TODO:
    }
}

- (void)setDisplayedView:(UIView <TCPopupContainerViewProtocol>*)displayedView {
    if (displayedView == nil) return;
    _displayedView = displayedView;
    @weakObj(self);
    if ([_displayedView respondsToSelector:@selector(hideBlock)]) {
        _displayedView.hideBlock = ^{
            [selfweak hideWithCompletion:nil];
        };
    }
    CGFloat height = MIN(_displayedView.height + _displayedView.margins.top + _displayedView.margins.bottom + _hideButtonHeight + _titleContainerHeight, _limitedMaxHeight);
    height = MAX(height, _limitedMinHeight);
    _finalheight = height + mBottomSafeHeight;
    [_displayViewContainer addSubview:_displayedView];
    [_displayedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_displayedView.margins);
    }];

    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.size.mas_equalTo(CGSizeMake(mScreenWidth, _finalheight));
    }];
    
}


- (void)showWithCompletion:(void (^)(void))completion {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self _showToView:keyWindow withCompletion:completion];
}

- (void)showToVisibleControllerViewWithCompletion:(void (^)(void))completion {
    UIViewController *visibleViewController = [QMUIHelper visibleViewController];
    [self _showToView:visibleViewController.view withCompletion:completion];
}

- (void)_showToView:(UIView *)view withCompletion:(void (^)(void))completion {
    if (!_displayedView || !view) {
           return;
       }
    
       [view addSubview:self];
       [self mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.mas_equalTo(UIEdgeInsetsZero);
       }];
       self.alpha = 0;
       _contentView.transform = CGAffineTransformMakeTranslation(0, _finalheight);
       [UIView qmui_animateWithAnimated:YES duration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
           self.alpha = 1;
           _contentView.transform = CGAffineTransformIdentity;
       } completion:^(BOOL finished) {
           if (finished && completion) {
               completion();
           }
       }];
}

- (void)actionForButton:(UIButton *)sender {
    [self hideWithCompletion:nil];
}

- (void)hideWithCompletion:(void (^)(void))completion {
    [UIView qmui_animateWithAnimated:YES duration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _contentView.transform = CGAffineTransformMakeTranslation(0, _finalheight);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ( completion) {
            completion();
        }
    }];
}

@end

@implementation TCPopupContainerMaskControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)action {
    [self.popupContainerView hideWithCompletion:nil];
}
@end
