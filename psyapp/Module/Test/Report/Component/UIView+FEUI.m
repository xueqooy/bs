//
//  UIView+FEUI.m
//  smartapp
//
//  Created by mac on 2019/12/16.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UIView+FEUI.h"
#import "FEUIColumn.h"
#import "FEUIRow.h"

@implementation UIView (FEUI)
- (void)feui_addRootContainer:(FEUIContainer *)container padding:(UIEdgeInsets)padding{
    [self addSubview:container];
   
    if ([self isKindOfClass:UIScrollView.class]) {
        if ([container isKindOfClass:FEUIColumn.class]) {
            CGFloat width = CGRectGetWidth(self.frame) - padding.left - padding.right;
            [container mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(padding.top);
                make.left.offset(padding.left);
                make.width.mas_equalTo(width);
                make.bottom.offset(-padding.bottom);
            }];
        } else {
           CGFloat height = CGRectGetHeight(self.frame) - padding.top - padding.bottom;
           [container mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.offset(padding.top);
               make.left.offset(padding.left);
               make.right.offset(-padding.right);
               make.height.mas_equalTo(height);
           }];
        }
        
    } else {
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(padding);
        }];
    }
}
@end
