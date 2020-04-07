//
//  FECheckUpdateTableViewCell.m
//  smartapp
//
//  Created by mac on 2019/9/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FECheckUpdateTableViewCell.h"
@interface FECheckUpdateTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *currentVersionLabel;

@property (weak, nonatomic) IBOutlet UILabel *versionNewTipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentVersionRightContraint;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;

@end

@implementation FECheckUpdateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.fe_contentBackgroundColor;
    _currentVersionLabel.textColor = UIColor.fe_mainTextColor;
    _versionNewTipLabel.backgroundColor = UIColor.fe_warningColor;
    _versionNewTipLabel.fe_adjustTextColorAutomatically = YES;
    _leftTitleLabel.textColor = UIColor.fe_titleTextColor;
}

- (void)hasNewVersionTip:(BOOL)has {
    if (has) {
        _versionNewTipLabel.hidden = NO;
        _currentVersionRightContraint.constant = STWidth(78);
    } else {
        _versionNewTipLabel.hidden = YES;
        _currentVersionRightContraint.constant = STWidth(15);
    }
}

- (void)setVersionCode:(NSString *)version {
    if ([version isEqualToString:@""]) {
        _currentVersionLabel.text = @"";
    } else {
        _currentVersionLabel.text = [NSString stringWithFormat:@"当前版本：%@", version];
    }
}
@end
