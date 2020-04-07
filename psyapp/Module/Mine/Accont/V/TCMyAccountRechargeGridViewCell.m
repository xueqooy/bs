//
//  TCMyAccountRechargeGridViewCell.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCMyAccountRechargeGridViewCell.h"

@implementation TCMyAccountRechargeGridViewCell {
    UILabel *_emoneyCountLabel;
    UILabel *_priceLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.fe_backgroundColor;
    self.layer.cornerRadius = STWidth(4);
    @weakObj(self);
    [self addTapGestureWithBlock:^{
        if (selfweak.onTap) {
            selfweak.onTap();
        }
    }];
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    _emoneyCountLabel = UILabel.new;
    _emoneyCountLabel.font = STFontRegular(18);
    _emoneyCountLabel.textColor = UIColor.fe_titleTextColorLighten;
    _emoneyCountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_emoneyCountLabel];
    [_emoneyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(STWidth(15));
    }];
    [self addSubview:_emoneyCountLabel];
    
    _priceLabel = UILabel.new;
    _priceLabel.font = STFontRegular(14);
    _priceLabel.textColor = UIColor.fe_auxiliaryTextColor;
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(STWidth(-15));
    }];
    [self addSubview:_priceLabel];
}

- (void)setSelected:(BOOL)selected {
    if (_selected == selected) return;
    _selected = selected;
    self.backgroundColor = _selected? UIColor.fe_mainColor : UIColor.fe_backgroundColor;
    _priceLabel.textColor = _selected? UIColor.whiteColor : UIColor.fe_auxiliaryTextColor;
    _emoneyCountLabel.textColor = _selected? UIColor.whiteColor : UIColor.fe_titleTextColorLighten;
}

- (void)setEmoneyCount:(NSInteger)emoneyCount {
    _emoneyCount = emoneyCount;
    _emoneyCountLabel.text = [NSString stringWithFormat:@"%li测点", (long)emoneyCount];
}

- (void)setPrice:(NSInteger)price{
    _price = price;
    _priceLabel.text = [NSString stringWithFormat:@"￥%li", (long)price];
}
@end
