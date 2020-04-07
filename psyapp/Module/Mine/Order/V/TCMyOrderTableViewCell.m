//
//  TCMyOrderTableViewCell.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCMyOrderTableViewCell.h"

@implementation TCMyOrderTableViewCell {
    UIImageView *_iconImageView;
    UILabel *_nameLabel;
    UILabel *_dateLabel;
    UILabel *_costLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    UIView *container = UIView.new;
    [self.contentView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(STWidth(10), STWidth(15), STWidth(10), STWidth(15)));
    }];
    
    _iconImageView = UIImageView.new;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds = YES;
    [container addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.equalTo(_iconImageView.mas_height);
    }];
    
    _nameLabel = UILabel.new;
    _nameLabel.textColor = UIColor.fe_titleTextColorLighten;
    _nameLabel.font = STFontBold(16);
    _nameLabel.numberOfLines = 2;
    [container addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(STWidth(15));
        make.right.top.offset(0);
    }];
    
    _dateLabel = UILabel.new;
    _dateLabel.textColor = UIColor.fe_auxiliaryTextColor;
    _dateLabel.font = STFontRegular(12);
    [container addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.bottom.offset(0);
    }];
    
    _costLabel = UILabel.new;
    _costLabel.textColor = UIColor.fe_textColorHighlighted;
    _costLabel.font = STFontBold(14);
    _costLabel.textAlignment = NSTextAlignmentRight;
    [container addSubview:_costLabel];
    [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
    }];
}

- (void)setIconImageURLString:(NSString *)imageURLString name:(NSString *)name date:(NSString *)date price:(CGFloat)price isEMoney:(BOOL)isEMoney {
    if (!isEMoney) {
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[UIImage imageNamed:@"default_11"]];
    } else {
        [_iconImageView setImage:[UIImage imageNamed:@"emoney"]];
    }
    
    if (!isEMoney) {
        _nameLabel.text = name;
    } else {
        _nameLabel.text = [NSString stringWithFormat:@"%.0f测点",price];
    }
    if (date.length > 10) {
        date = [date substringToIndex:10];
    }
    _dateLabel.text = [NSString stringWithFormat:@"订单时间：%@", date];
    if (!isEMoney) {
        _costLabel.text = [NSString stringWithFormat:@"实付%.2f测点", price ];
    } else {
        _costLabel.text = [NSString stringWithFormat:@"实付￥%.2f", price ];
    }
}
@end
