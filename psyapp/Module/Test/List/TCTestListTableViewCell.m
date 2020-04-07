//
//  TCTestListTableViewCell.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/13.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCTestListTableViewCell.h"
#import "UIImage+Category.h"

@implementation TCTestListTableViewCell {
    UILabel *_titleLabel;
    UILabel *_participantsCountLabel;
    UIImageView *_iconImageView;
    
    UILabel *_priceLabel;
    QMUILinkButton *_originPriceLabelButton;
    
    UILabel *_statusLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    self.clipsToBounds = YES;
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    UIView *container = [UIView new];
    [self.contentView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(STWidth(10), STWidth(15), STWidth(10), STWidth(15)));
    }];
    
    
    
    _iconImageView = [UIImageView new];
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = STWidth(4);
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [container addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_iconImageView.mas_height);
        make.top.bottom.right.offset(0);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = STFontBold(16);
    _titleLabel.textColor = UIColor.fe_titleTextColorLighten;
    _titleLabel.numberOfLines = 2;
    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [container addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.right.equalTo(_iconImageView.mas_left).offset(STWidth(-15));
    }];
    
    UIImageView *gradientImageView = UIImageView.new;
    UIImage *gradientImage = [UIImage gradientImageWithWithColors:@[mHexColorA(@"000000", 0), mHexColorA(@"000000", 0.5)] locations:@[@0, @1] startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) size:STSize(80, 20)];
    gradientImageView.image = gradientImage;
    [_iconImageView addSubview:gradientImageView];
    [gradientImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.mas_equalTo(STWidth(20));
    }];
    
    _participantsCountLabel = [UILabel new];
    _participantsCountLabel.font = STFontRegular(10);
    _participantsCountLabel.textColor = UIColor.whiteColor;
    [gradientImageView addSubview:_participantsCountLabel];
    [_participantsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-STWidth(6));
        make.centerY.offset(0);
    }];
}

- (void)setTitleText:(NSString *)titleText participantsCount:(NSUInteger)count iconImageURL:(NSURL *)imageURL alreadyPurchase:(BOOL)purchased presentPrice:(CGFloat)presentPrice originPrice:(CGFloat)originPrice {
    _titleLabel.text = titleText;
    [_iconImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"default_32"]];
    NSString *countString = [NSString stringWithFormat:@"%li人已测", count];
    _participantsCountLabel.text = countString;
    
    if (purchased) {
        //显示完成状态
        if (_priceLabel) {
            [_priceLabel removeFromSuperview];
            _priceLabel = nil;
        }
        
        if (_originPriceLabelButton) {
            [_originPriceLabelButton removeFromSuperview];
            _originPriceLabelButton = nil;
        }
        
    } else {
        if (_statusLabel) {
            [_statusLabel removeFromSuperview];
            _statusLabel = nil;
        }
        
        //显示价格
        if (_priceLabel == nil) {
            _priceLabel = [UILabel new];
            _priceLabel.textAlignment = NSTextAlignmentRight;
            _priceLabel.textColor = mHexColor(@"#FC674F");
            _priceLabel.font = STFontBold(16);
            UIView *container = _titleLabel.superview;
            [container addSubview:_priceLabel];
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.offset(0);
            }];
        }
       
        _priceLabel.text = PriceEmoneyYuanString(presentPrice);
        
        //显示原价
        if (originPrice > 0) {
            if (_originPriceLabelButton == nil) {
                _originPriceLabelButton = [QMUILinkButton new];
                _originPriceLabelButton.titleLabel.font = STFontRegular(12);
                _originPriceLabelButton.underlineColor = UIColor.fe_placeholderColor;
                _originPriceLabelButton.underlineWidth = 1;
                _originPriceLabelButton.underlineInsets = UIEdgeInsetsMake(STWidth(-4), STWidth(-2), STWidth(4), STWidth(-2));
                [_originPriceLabelButton setTitleColor:UIColor.fe_placeholderColor forState:UIControlStateNormal];
                [_originPriceLabelButton setTitle:PriceEmoneyYuanString(originPrice) forState:UIControlStateNormal];
                UIView *container = _titleLabel.superview;
                [container addSubview:_originPriceLabelButton];
                [_originPriceLabelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(_priceLabel);
                    make.left.equalTo(_priceLabel.mas_right).offset(STWidth(5));
                }];
            }
        }
    }
}

- (void)setCompleted:(BOOL)completed {
    if (_statusLabel == nil) {
        _statusLabel = [UILabel new];
        _statusLabel.textColor = mHexColor(@"#909399");
        _statusLabel.font = STFontRegular(9);
        _statusLabel.backgroundColor = UIColor.fe_buttonBackgroundColorActive;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.layer.cornerRadius = STWidth(7.5);
        _statusLabel.clipsToBounds = YES;
        UIView *container = _titleLabel.superview;
        [container addSubview:_statusLabel];
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.offset(0);
            make.size.mas_equalTo(STSize(47, 15));
        }];
       _statusLabel.fe_adjustTextColorAutomatically = YES;
    }
    
    if (_priceLabel) {
        [_priceLabel removeFromSuperview];
        _priceLabel = nil;
    }
    
    if (_originPriceLabelButton) {
        [_originPriceLabelButton removeFromSuperview];
        _originPriceLabelButton = nil;
    }
    
    _statusLabel.backgroundColor = completed? UIColor.fe_safeColor: UIColor.fe_buttonBackgroundColorActive;
    _statusLabel.text = completed? @"已完成" : @"进行中";
}

- (void)setPrefersWiderCellStyle:(BOOL)prefersWiderCellStyle {
    if (prefersWiderCellStyle == _prefersWiderCellStyle) return;
    _prefersWiderCellStyle = prefersWiderCellStyle;
//    [UIView animateWithDuration:0.25 animations:^{
        if (self->_prefersWiderCellStyle) {
            [self->_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self->_iconImageView.mas_height).multipliedBy(1.5);
                make.top.bottom.right.offset(0);
            }];
        } else {
            [self->_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self->_iconImageView.mas_height);
                make.top.bottom.right.offset(0);
            }];
        }
//        [self layoutIfNeeded];
//    }];
}
@end
