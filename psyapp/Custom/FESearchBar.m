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
    self.placeholder = @"请输入关键词";
    self.showsCancelButton = YES;
    self.backgroundColor = [UIColor clearColor];
    [self setImage:[UIImage imageNamed:@"share_clear"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    
    [self setQmui_placeholderColor:UIColor.fe_placeholderColor];

    UITextField *searchTextField;
    if(mIsIOS13) {
        searchTextField = self.searchTextField;
    } else {
        searchTextField = [self valueForKey:@"_searchField"];
    }
 
    searchTextField.backgroundColor = UIColor.clearColor;
    searchTextField.font = mFont(18);
    searchTextField.textColor = UIColor.fe_titleTextColorLighten;
    searchTextField.leftView = nil;
    searchTextField.tintColor = UIColor.whiteColor;
    
    searchTextField.qmui_borderPosition = QMUIViewBorderPositionBottom;
    searchTextField.qmui_borderLocation = QMUIViewBorderLocationInside;
    searchTextField.qmui_borderColor = mHexColor(@"#EBEDF0");
    searchTextField.qmui_borderWidth = 1;
    
    
    UIButton *cancelBtn = [self valueForKey:@"cancelButton"];
    [cancelBtn setTitle:@"" forState:UIControlStateNormal];
    
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (mIsIOS13) {
        self.searchTextField.frame = CGRectMake(CGRectGetMinX(self.searchTextField.frame) , CGRectGetMinY(self.searchTextField.frame), STWidth(265), CGRectGetHeight(self.searchTextField.frame));
    } else {
        UITextField *textField = [self valueForKey:@"_searchField"];
           
           if (textField) {
               textField.frame = CGRectMake(CGRectGetMinX(textField.frame) , CGRectGetMinY(textField.frame), STWidth(265), CGRectGetHeight(textField.frame));
           }
    }
}

@end
