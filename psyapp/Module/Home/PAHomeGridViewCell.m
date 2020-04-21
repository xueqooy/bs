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
    QMUIButton *_imageView;
    UILabel *_label;
    
    QMUIGhostButton *_button;
    UIImageView *_statusImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    
    _container = QMUIButton.new;
    _container.backgroundColor = UIColor.fe_contentBackgroundColor;
    _container.layer.cornerRadius = STWidth(16);
    _container.layer.shadowColor = UIColor.blackColor.CGColor;
    _container.layer.shadowOpacity = 0.1;
    _container.layer.shadowOffset = CGSizeMake(0, 0);
    [_container addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, STWidth(5), 0));
    }];
    
    
    _imageView = QMUIButton.new;
    _imageView.userInteractionEnabled = NO;
    _imageView.adjustsImageTintColorAutomatically = YES;
    _imageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_container addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(STSize(64, 64));
        make.centerX.offset(0);
        make.top.offset(STWidth(14));
    }];
    
    _label = [UILabel.alloc qmui_initWithFont:STFontBold(16) textColor:UIColor.fe_titleTextColorLighten];
    _label.textAlignment = NSTextAlignmentCenter;
    [_container addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom).offset(STWidth(10));
        make.centerX.offset(0);
    }];
    
    _statusImageView = UIImageView.new;
    _statusImageView.image = [UIImage imageNamed:@"complete"];
    [_container addSubview:_statusImageView];
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.offset(0);

        make.size.mas_equalTo(STSize(50, 50));
    }];
    
    _button = [[QMUIGhostButton alloc] initWithGhostType:QMUIGhostButtonColorBlue];
    [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitle:@"开始测评" forState:UIControlStateNormal];
    _button.titleLabel.font = STFontRegular(14);
    [_container addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(STWidth(-10));
        make.centerX.offset(0);
        make.width.equalTo(_container).multipliedBy(0.5);
        make.height.mas_equalTo(STWidth(25));
    }];
    
    return self;
}

- (void)buttonAction {
    if (_onButtonClick) {
        _onButtonClick();
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _label.text = title;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [_imageView setImage:_image forState:UIControlStateNormal];
}

- (void)setCompleted:(BOOL)completed {
    _completed = completed;
    _statusImageView.hidden = !completed;
    [_button setTitle:completed? @"重测" : @"开始测评" forState:UIControlStateNormal];
}

- (void)tintColorDidChange {
    _imageView.tintColor = self.tintColor;
}


- (void)actionForButton:(UIButton *)sender {
    if (_onTouch) _onTouch();
}
@end
