//
//  TCSearchAppearanceButton.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/26.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCSearchAppearanceButton.h"

@implementation TCSearchAppearanceButton {
    UIImageView *_iconImageView;
    UILabel *_placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
     self.backgroundColor = UIColor.fe_contentBackgroundColor;
    
    UIView *centerContainer = UIView.new;
    _iconImageView = UIImageView.new;
    _iconImageView.image = [UIImage imageNamed: @"search_gray"];
    _iconImageView.userInteractionEnabled = NO;
    [centerContainer addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.top.bottom.centerY.offset(0);
    }];
    
    _placeholderLabel = [UILabel.alloc qmui_initWithFont:mFont(12) textColor:UIColor.fe_placeholderColor];
    _placeholderLabel.text = @"搜文章/课程/测评";
    _placeholderLabel.userInteractionEnabled = NO;
    [centerContainer addSubview:_placeholderLabel];
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(STWidth(13));
        make.right.centerY.offset(0);
    }];
    
    [self addSubview:centerContainer];
    [centerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    return self;
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    _iconImageView.image = icon;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _placeholderLabel.text = placeholder;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isDescendantOfView:view]) {
        return self;
    }
    return view;
}

@end
