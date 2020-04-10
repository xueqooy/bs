//
//  TCTitleHeaderView.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/24.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCTitleHeaderView.h"

@implementation TCTitleHeaderView {
    UIView *_imageTitleContainer;
    
    UILabel *_titleLabel;
    QMUIButton *_button;
    UIImageView *_imageView;
//    UIVisualEffectView *_titleEffectView;
//    UIVisualEffectView *_buttonEffectView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    _section = -1;
    _insets = UIEdgeInsetsZero;
    _spacingBetweenImageAndTitle = STWidth(6);
    return self;
}

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    _tableView.qmui_multipleDelegatesEnabled = YES;
    _tableView.delegate = self;
}

- (void)setInsets:(UIEdgeInsets)insets {
    _insets = insets;
    if (_titleLabel) {
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(_insets.left);
            make.top.offset(_insets.top);
            make.bottom.offset(-_insets.bottom);
        }];
    }
    if (_button) {
        [_button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(_insets.top);
            make.right.offset(-_insets.right);
            make.bottom.offset(-_insets.bottom);
        }];
    }
}

- (UIView *)imageTitleContainer {
    if (!_imageTitleContainer) {
        _imageTitleContainer = UIView.new;
        UITapGestureRecognizer *tapReconizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToSectionOn)];
        [_imageTitleContainer addGestureRecognizer:tapReconizer];
        [self addSubview:_imageTitleContainer];
        [_imageTitleContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(_insets.left);
            make.top.offset(_insets.top);
            make.bottom.offset(-_insets.bottom);
        }];
    }
    return _imageTitleContainer;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel.alloc qmui_initWithFont:STFontBold(20) textColor:UIColor.fe_titleTextColor];
        _titleLabel.userInteractionEnabled = YES;
        [self.imageTitleContainer addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (_imageView) {
                make.left.equalTo(_imageView.mas_right).offset(_spacingBetweenImageAndTitle);
            } else {
                make.left.offset(0);
            }
            make.right.offset(0);
            make.centerY.offset(0);
        }];
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = UIImageView.new;
        [self.imageTitleContainer addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.offset(0);
            make.width.mas_equalTo(_imageView.mas_height);
        }];
        if (_titleLabel) {
            [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_imageView.mas_right).offset(_spacingBetweenImageAndTitle);
                make.right.offset(0);
                make.centerY.offset(0);
            }];
        }
    }
    return _imageView;
}

- (QMUIButton *)button {
    if (!_button) {
        _button = QMUIButton.new;
        _button.tintColorAdjustsTitleAndImage = UIColor.fe_auxiliaryTextColor;
//        [_button setTitleColor:UIColor.fe_auxiliaryTextColor forState:UIControlStateNormal];
        _button.titleLabel.font = STFontRegular(12);
        _button.spacingBetweenImageAndTitle = STWidth(6);
        _button.imagePosition = QMUIButtonImagePositionRight;
        [_button setImage:[UIImage imageNamed:@"button_more"] forState:UIControlStateNormal];
        [self addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(_insets.top);
            make.right.offset(-_insets.right);
            make.bottom.offset(-_insets.bottom);
        }];
        
//        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        _buttonEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        _buttonEffectView.alpha = 0.7;
//        _buttonEffectView.layer.cornerRadius = STWidth(2);
//        _buttonEffectView.clipsToBounds = YES;
//        [self addSubview:_buttonEffectView];
//        [_buttonEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_button).offset(-STWidth(2));
//            make.right.equalTo(_button).offset(STWidth(2));
//            make.bottom.equalTo(_button).offset(STWidth(2));
//            make.top.equalTo(_button).offset(-STWidth(2));
//        }];
//
//        [self sendSubviewToBack:_buttonEffectView];
    }
    return _button;
}


- (void)scrollToSectionOn {
    if (_tableView == nil) return;
    if (_section == -1) return;
    [_tableView qmui_scrollToRowFittingOffsetY:0 atIndexPath:[NSIndexPath indexPathForRow:0 inSection:_section] animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (_tableView.style != UITableViewStylePlain) return;
//    if (_section == -1) return;
//    if ([_tableView qmui_isHeaderPinnedForSection:_section]) {
////        self.backgroundColor = UIColor.clearColor;
////        _button.tintColorAdjustsTitleAndImage = UIColor.fe_titleTextColorLighten;
//    } else {
//        
////        self.backgroundColor = UIColor.fe_contentBackgroundColor;
////        _button.tintColorAdjustsTitleAndImage = UIColor.fe_auxiliaryTextColor;
//    }
}
@end
