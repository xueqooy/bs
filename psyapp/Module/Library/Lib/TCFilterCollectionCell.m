//
//  TCFilterCollectionCell.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/3.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCFilterCollectionCell.h"
#import "TCCommonButton.h"
@implementation TCFilterCollectionCell {
    TCCommonButton *_button;
}



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _button = TCCommonButton.new;
        _button.adjustCornerRound = YES;
        _button.qmui_borderLocation = QMUIViewBorderLocationInside;
        _button.qmui_borderColor = [UIColor.fe_mainColor colorWithAlphaComponent:0.05];
        _button.qmui_borderWidth = 1;
        [self.contentView addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        _button.backgroundColor = UIColor.fe_backgroundColor;
        [_button setTitleColor:UIColor.fe_mainTextColor forState:UIControlStateNormal];
        _button.titleLabel.font = STFontRegular(12);
        _button.layer.borderWidth = STWidth(1);
        _button.layer.borderColor = UIColor.fe_backgroundColor.CGColor;
        [_button addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)touchAction:(id)sender {
    if (_touchHandler) {
        _touchHandler();
    }
   
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
//    _button.backgroundColor = selected? [UIColor.fe_mainColor colorWithAlphaComponent:0.05] : UIColor.fe_backgroundColor ;
//    _button.layer.borderColor = selected? UIColor.fe_mainColor.CGColor :  UIColor.fe_backgroundColor.CGColor;
    if (selected) {
        [_button setTitleColor:UIColor.fe_placeholderColor forState:UIControlStateNormal];
    }  else {
        [_button setTitleColor:UIColor.fe_mainTextColor forState:UIControlStateNormal];

    }
}


- (void)setTitle:(NSString *)title{
    [_button setTitle:title forState:UIControlStateNormal];
}

- (NSString *)title {
    return _button.titleLabel.text;
}
@end
