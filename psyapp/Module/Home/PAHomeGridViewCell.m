//
//  PAHomeGridViewCell.m
//  psyapp
//
//  Created by mac on 2020/3/14.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "PAHomeGridViewCell.h"

@implementation PAHomeGridViewCell {
    QMUIButton *_container;
    UIImageView *_imageView;
    UILabel *_label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _container = QMUIButton.new;
    _container.layer.cornerRadius = STWidth(16);
    [_container addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, STWidth(5), 0));
    }];
    
    
    _imageView = UIImageView.new;
    [_container addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(STSize(64, 64));
        make.centerX.offset(0);
        make.top.offset(STWidth(14));
    }];
    
    _label = [UILabel.alloc qmui_initWithFont:STFontBold(16) textColor:UIColor.fe_mainColor];
    _label.textAlignment = NSTextAlignmentCenter;
    [_container addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(STWidth(-10));
        make.centerX.offset(0);
    }];
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _label.text = title;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

- (void)tintColorDidChange {
    UIColor *tintColor = self.tintColor;
    _label.textColor = tintColor;
    _container.backgroundColor = [tintColor colorWithAlphaComponent:0.05];
}

- (void)actionForButton:(UIButton *)sender {
    if (_onTouch) _onTouch();
}
@end
