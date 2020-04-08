//
//  FESearchBar.m
//  smartapp
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FESearchBar.h"

@implementation FESearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.placeholder = @"搜文章/课程/测评";
    self.showsCancelButton = YES;
    self.clipsToBounds = YES;
    
    self.placeholder = @"搜文章/课程/测评";
    self.backgroundImage = [UIImage qmui_imageWithColor:UIColor.fe_backgroundColor];
    [self setImage:[UIImage imageNamed:@"share_clear"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
//    [self setImage:nil forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.qmui_textField.leftView = nil;
    self.qmui_textField.backgroundColor = UIColor.clearColor;
    self.qmui_textColor = UIColor.fe_mainTextColor;
    self.qmui_placeholderColor = UIColor.fe_placeholderColor;
    self.qmui_textFieldMargins = UIEdgeInsetsMake(0, 0, 0, -STWidth(30));
    [self.qmui_cancelButton setTitle:@"" forState:UIControlStateNormal];
    self.qmui_textField.font = mFont(18);
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height / 2;
}

@end
