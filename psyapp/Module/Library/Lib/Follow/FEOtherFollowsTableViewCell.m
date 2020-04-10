//
//  FEOtherFollowsTableViewCell.m
//  smartapp
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEOtherFollowsTableViewCell.h"
@interface FEOtherFollowsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIView *separator;

@end

@implementation FEOtherFollowsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    _followButton.layer.borderColor = UIColor.fe_separatorColor.CGColor;
    [_followButton setTitleColor:UIColor.fe_auxiliaryTextColor forState:UIControlStateNormal];
    _titleLabel.textColor = UIColor.fe_titleTextColorLighten;
    _separator.backgroundColor = UIColor.fe_separatorColor;
}


- (IBAction)buttonClickAction:(UIButton *)sender {
    if (_clickHandler) {
        _clickHandler();
    }
}

- (void)updataWithName:(NSString *)name {
    _titleLabel.text = name;
}
@end
