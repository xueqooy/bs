//
//  PITableViewBaseCell.m
//  smartapp
//
//  Created by mac on 2019/10/31.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "PITableViewXibBaseCell.h"


@implementation PITableViewXibBaseCell
 
- (instancetype)initWithFrame:(CGRect)frame {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].firstObject;
    if (self) {
    }
    return self;
}

- (void)postInformationSubmissionNoticeWithModel:(PIModel *)model {
    [[NSNotificationCenter defaultCenter] postNotificationName:nc_login_info_perfect object:model];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
