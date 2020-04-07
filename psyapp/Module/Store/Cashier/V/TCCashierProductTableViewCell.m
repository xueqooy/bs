//
//  TCCashierProductTableViewCell.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/14.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCCashierProductTableViewCell.h"
@interface TCCashierProductTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end
@implementation TCCashierProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    _nameLabel.textColor = UIColor.fe_titleTextColorLighten;
    _priceLabel.textColor = UIColor.fe_textColorHighlighted;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setIconImageURL:(NSURL *)imageURL name:(NSString *)name price:(CGFloat)price {
    [_iconImageView sd_setImageWithURL:imageURL placeholderImage:nil];
    _nameLabel.text = name;
    _priceLabel.text = PriceEmoneyYuanString(price);
}

@end
