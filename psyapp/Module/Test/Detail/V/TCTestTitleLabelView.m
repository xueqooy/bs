//
//  TCRoundTitleLabel.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/1.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCTestTitleLabelView.h"

@implementation TCTestTitleLabelView {
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
    UILabel *_mainLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.fe_backgroundColor;
    self.clipsToBounds = NO;
    [self setupSubviews];
    return self;
}

- (void)setPrefersMainTextWidth:(CGFloat)prefersMainTextWidth {
    _mainLabel.preferredMaxLayoutWidth = prefersMainTextWidth;
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    _titleLabel.text = _titleText;
}

- (void)setMainText:(NSString *)mainText {
    _mainText = mainText;
    [_mainLabel setHtmlText:mainText lineSpacing:STWidth(7)];
}

- (void)setupSubviews {
    UIView *container = UIView.new;
    [self addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(STWidth(10), STWidth(15), STWidth(10), STWidth(15)));
    }];
    
    _iconImageView = UIImageView.new;
    _iconImageView.image = [UIImage imageNamed:@"title_icon"];
    [container addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.size.mas_equalTo(CGSizeMake(STWidth(16), STWidth(17)));
    }];
    
    _titleLabel = [[UILabel alloc] qmui_initWithFont:STFontBold(16) textColor:UIColor.fe_titleTextColorLighten];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconImageView);
        make.left.equalTo(_iconImageView.mas_right).offset(STWidth(6));
    }];
    
    _mainLabel = UILabel.new;
    _mainLabel.text = @"适合谁测";
    _mainLabel.textAlignment = NSTextAlignmentLeft;
    _mainLabel.textColor = UIColor.fe_mainTextColor;
    _mainLabel.font = STFontRegular(14);
    _mainLabel.numberOfLines = 0;
    _mainLabel.adjustsFontSizeToFitWidth = YES;
    _mainLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [container addSubview:_mainLabel];
    [_mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(STWidth(32));
        make.left.right.bottom.offset(0);
    }];
}


@end
