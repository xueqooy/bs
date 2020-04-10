//
//  FEMyFollowsTableViewCell.m
//  smartapp
//
//  Created by mac on 2019/9/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FESchoolFollowsTableViewCell.h"
@interface FESchoolFollowsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIView *separator;

@end
@implementation FESchoolFollowsTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    _followButton.layer.borderColor = UIColor.fe_separatorColor.CGColor;
    [_followButton setTitleColor:UIColor.fe_auxiliaryTextColor forState:UIControlStateNormal];
    _titleLabel.textColor = UIColor.fe_titleTextColorLighten;
    _typeLabel.textColor = UIColor.fe_auxiliaryTextColor;
    _separator.backgroundColor = UIColor.fe_separatorColor;
}
- (IBAction)buttonClickAction:(UIButton *)sender {
    if (_clickHandler) {
        _clickHandler();
    }
}


- (void)updataWithName:(NSString *)name logoURL:(nonnull NSString *)logo tags:(nonnull NSString *)tags{
    _titleLabel.text = name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:logo]];
    _typeLabel.text = tags;

}

@end
