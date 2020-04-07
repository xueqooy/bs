//
//  TCCashierPaymentMethodTableViewCell.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/14.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCCashierPaymentMethodTableViewCell.h"
@interface TCCashierPaymentMethodTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIView *separator;
@end
@implementation TCCashierPaymentMethodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    _nameLabel.textColor = UIColor.fe_titleTextColor;
  
    _checkButton.layer.cornerRadius = STWidth(9);
    _checkButton.layer.borderWidth = 1;
    _checkButton.layer.borderColor = UIColor.fe_placeholderColor.CGColor;
    [_checkButton setImageEdgeInsets:UIEdgeInsetsMake(STWidth(4), STWidth(3), STWidth(4), STWidth(3))];
    _separator.backgroundColor = UIColor.fe_separatorColor;
}

- (void)setSeparatorHidden:(BOOL)hidden {
    _separator.hidden = hidden;
}

- (void)setIconImage:(UIImage *)image name:(NSString *)name checked:(BOOL)checked {
    [_iconImageView setImage:image];
    _nameLabel.text = name;
    self.checked = checked;
}

- (void)setChecked:(BOOL)checked {
    if (_checked == checked) return;
    _checked = checked;
    _checkButton.backgroundColor = checked? UIColor.fe_mainColor : UIColor.clearColor;
    [_checkButton setImage:checked? [[UIImage imageNamed:@"checked_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]: nil forState:UIControlStateNormal];
    _checkButton.layer.borderWidth = checked? 0: 1;
}

- (IBAction)buttonAction:(UIButton *)sender {
//    self.checked = !_checked;
}


@end
