//
//  TCProductPriceView.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/1.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCProductPriceView.h"

@implementation TCProductPriceView {
    UILabel *_presentPriceLabel;
    QMUILinkButton *_originalPriceLabelButton;
    
    MASConstraint *_spacingContraint;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _presentPriceTextColor = UIColor.fe_mainColor;
    _originalPriceTextColor = UIColor.fe_placeholderColor;
    _presentPriceTextFont = STFontBold(16);
    _originalPriceTextFont = STFontRegular(12);
    _presentPrice = -1;
    _originalPrice = -1;
    _spacing = STWidth(6);
    _presentPricePosition = TCPresentPircePositionLeft;
    [self setupSuviews];
    return self;
}

- (void)setupSuviews {
    _presentPriceLabel = [UILabel new];
    _presentPriceLabel.textAlignment = NSTextAlignmentRight;
    _presentPriceLabel.textColor = _presentPriceTextColor;
    _presentPriceLabel.font = _presentPriceTextFont;
    [self addSubview:_presentPriceLabel];
    [_presentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
    }];
    
    _originalPriceLabelButton = [QMUILinkButton new];
    _originalPriceLabelButton.titleLabel.font = _originalPriceTextFont;
    _originalPriceLabelButton.underlineColor = _originalPriceTextColor;
    _originalPriceLabelButton.underlineWidth = 0;
    _originalPriceLabelButton.underlineInsets = UIEdgeInsetsMake(STWidth(-4), STWidth(-2), STWidth(4), STWidth(-2));
    [_originalPriceLabelButton setTitleColor:_originalPriceTextColor forState:UIControlStateNormal];
    [self addSubview:_originalPriceLabelButton];
    [_originalPriceLabelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_presentPriceLabel);
        _spacingContraint = make.left.equalTo(_presentPriceLabel.mas_right).offset(_originalPrice >= 0? _spacing : 0);
        make.right.offset(0);
    }];
    
}

- (void)setPresentPrice:(CGFloat)presentPrice {
    if (presentPrice < 0) return;
    _presentPrice = presentPrice;
    _presentPriceLabel.text = PriceEmoneyYuanString(presentPrice);
}

- (void)setOriginalPrice:(CGFloat)originalPrice {
    if (originalPrice < 0) return;
    _originalPrice = originalPrice;
    _originalPriceLabelButton.underlineWidth = 1;
    [_originalPriceLabelButton setTitle:PriceEmoneyYuanString(originalPrice) forState:UIControlStateNormal];
    
    if (_presentPricePosition == TCPresentPircePositionRight) {
       _spacingContraint.offset(_originalPrice >= 0? -_spacing: 0);

    } else {
        _spacingContraint.offset(_originalPrice >= 0? _spacing: 0);

    }
}

- (void)setPresentPriceTextColor:(UIColor *)presentPriceTextColor {
    _presentPriceTextColor = presentPriceTextColor;
    _presentPriceLabel.textColor = presentPriceTextColor;
}

- (void)setOriginalPriceTextColor:(UIColor *)originalPriceTextColor {
    _originalPriceTextColor = originalPriceTextColor;
    [_originalPriceLabelButton setTitleColor:_originalPriceTextColor forState:UIControlStateNormal];
}

- (void)setPresentPriceTextFont:(UIFont *)presentPriceTextFont {
    _presentPriceTextFont = presentPriceTextFont;
    _presentPriceLabel.font = _presentPriceTextFont;
}

- (void)setOriginalPriceTextFont:(UIFont *)originalPriceTextFont {
    _originalPriceTextFont = originalPriceTextFont;
    _originalPriceLabelButton.titleLabel.font = _originalPriceTextFont;
}

- (void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
  
    if (_presentPricePosition == TCPresentPircePositionRight) {
       _spacingContraint.offset(_originalPrice >= 0? -_spacing: 0);

    } else {
        _spacingContraint.offset(_originalPrice >= 0? _spacing: 0);

    }
}

- (void)setPresentPricePosition:(TCPresentPircePosition)presentPricePosition{
    if (_presentPricePosition == presentPricePosition) return;
    _presentPricePosition = presentPricePosition;
    
    if (_presentPricePosition == TCPresentPircePositionLeft) {
        [_originalPriceLabelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_presentPriceLabel);
            _spacingContraint = make.left.equalTo(_presentPriceLabel.mas_right).offset(_originalPrice >= 0? _spacing: 0);
            make.right.offset(0);
        }];
        [_presentPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.offset(0);
        }];
    } else if (_presentPricePosition == TCPresentPircePositionRight) {
        [_originalPriceLabelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_presentPriceLabel);
            make.left.offset(0);
            _spacingContraint =  make.right.equalTo(_presentPriceLabel.mas_left).offset(_originalPrice >= 0? -_spacing : 0);
        }];
        [_presentPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.offset(0);
        }];
    } else {
        [_originalPriceLabelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            _spacingContraint =  make.top.equalTo(_presentPriceLabel.mas_bottom).offset(_originalPrice >= 0? _spacing : 0);
            make.centerX.equalTo(_presentPriceLabel);
            make.bottom.offset(0);
        }];
        [_presentPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
        }];
    }
  
    
}
@end
