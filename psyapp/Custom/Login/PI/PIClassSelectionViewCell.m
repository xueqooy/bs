//
//  PIClassSelectionViewCell.m
//  ClassSelection
//
//  Created by xueqooy on 2019/10/30.
//  Copyright © 2019年 cheers-genius. All rights reserved.
//

#import "PIClassSelectionViewCell.h"
#import "PIClassSelectionView.h"
#import "FastClickUtils.h"

NSString * const PIClassSelectionCellSelectedNotificationName = @"PIClassSelectionCellSelectedNotificationName";
@implementation PIClassSelectionViewCell {
    UIButton *_button;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.contentView addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        _button.backgroundColor = UIColor.fe_contentBackgroundColor;
        [_button setTitleColor:UIColor.fe_titleTextColorLighten forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:STWidth(16) weight:UIFontWeightBold];
        _button.layer.cornerRadius = STWidth(20);
        _button.layer.borderWidth = STWidth(1);
        _button.layer.borderColor = UIColor.fe_separatorColor.CGColor;
        [_button addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)touchAction:(id)sender {
    if ([FastClickUtils isFastClick]) {
        return;
    }
    UIButton *button = (UIButton *)sender;
    [self setState:YES];
    if (_touchHandler) {
        _touchHandler(button.titleLabel.text);
    }
   
}

- (void)setState:(BOOL)seleted {
    _button.backgroundColor = seleted? [UIColor.fe_mainColor colorWithAlphaComponent:0.05] : UIColor.fe_contentBackgroundColor ;
    _button.layer.borderColor = seleted? UIColor.fe_mainColor.CGColor :  UIColor.fe_separatorColor.CGColor;
}


- (void)setTitle:(NSString *)title{
    [_button setTitle:title forState:UIControlStateNormal];
}

- (NSString *)title {
    return _button.titleLabel.text;
}
@end
