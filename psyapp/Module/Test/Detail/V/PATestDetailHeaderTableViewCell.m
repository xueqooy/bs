//
//  PATestDetailHeaderTableViewCell.m
//  psyapp
//
//  Created by mac on 2020/3/16.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "PATestDetailHeaderTableViewCell.h"
#import "TCProductPriceView.h"
#import "FEDimensionFiveScoreView.h"
@implementation PATestDetailHeaderTableViewCell {
    UILabel *_titleLabel;
    UILabel *_descLabel;
    TCProductPriceView *_priceView;
    FEDimensionFiveScoreView *_scoreView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    UIView *container = UIView.new;
    [self.contentView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(STWidth(20), STWidth(15), STWidth(16), STWidth(15)));
    }];
    
    _titleLabel = [UILabel.alloc qmui_initWithFont:STFontBold(20) textColor:UIColor.fe_titleTextColorLighten];
    _titleLabel.numberOfLines = 0;
    [container addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
    }];
    
    _priceView = TCProductPriceView.new;
    _priceView.presentPriceTextColor = mHexColor(@"#FC674F");
    [container addSubview:_priceView];
    [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(STWidth(10));
        make.left.offset(0);
    }];
    
    _descLabel = [[UILabel alloc] qmui_initWithFont:STFontRegular(14) textColor:UIColor.fe_auxiliaryTextColor];
    [container addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceView.mas_bottom).offset(STWidth(10));
        make.left.right.offset(0);
    }];
    
    _scoreView = FEDimensionFiveScoreView.new;
    [container addSubview:_scoreView];
    [_scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(_descLabel.mas_bottom).offset(STWidth(10));
        make.height.mas_equalTo(STWidth(40));
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setDesc:(NSString *)desc {
    _desc = desc;
    _descLabel.text = desc;
}

- (void)setPresentPrice:(CGFloat)presentPrice {
    _presentPrice = presentPrice;
    _priceView.presentPrice = _presentPrice;
}

- (void)setOriginPrice:(CGFloat)originPrice {
    _originPrice = originPrice;
    _priceView.originalPrice = _originPrice;
}

- (void)setRecommendIndex:(CGFloat)recommendIndex {
    _recommendIndex = recommendIndex;
    _scoreView.index = _recommendIndex;
}

@end
