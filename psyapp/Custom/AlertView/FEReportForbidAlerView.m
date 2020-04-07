//
//  FEReportForbidAlerView.m
//  smartapp
//
//  Created by mac on 2019/11/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportForbidAlerView.h"

@implementation FEReportForbidAlerView {
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UIButton *_confirmButton;
    
    NSString *_content;
    NSString *_title;
    void (^_buttonClicedExeHandler)(void);
}

- (void)showWithTitle:(NSString *)title content:(NSString *)content {
    [self showWithTitle:title content:content buttonClickedExeHandler:nil];
}

- (void)showWithTitle:(NSString *)title content:(NSString *)content buttonClickedExeHandler:(void (^)(void))handler {
    _buttonClicedExeHandler = handler;
    _title = title;
    _content = content;
    [self showWithAnimated:YES];
}

- (UIView *)layoutContainer {
    UIView *container = [UIView new];
    container.layer.masksToBounds = YES;
    [container setBackgroundColor:[UIColor whiteColor]];
    container.layer.cornerRadius = STWidth(4);
    CGFloat contentHeight = [_content getHeightForFont:STFontRegular(16) width:STWidth(255)];
    
    container.frame = CGRectMake(0, 0, STWidth(285), contentHeight + STWidth(100));
    
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = mHexColor(@"#18181A");
    _titleLabel.text = _title;
    _titleLabel.font = STFontBold(18);
    [container addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(STWidth(15));
    }];
    
    _contentLabel = [UILabel new];
    _contentLabel.textColor = mHexColor(@"#606266");
    _contentLabel.text = _content;
    _contentLabel.font = STFontRegular(16);
    _contentLabel.numberOfLines = 0;
    [container addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(STWidth(15));
        make.top.equalTo(_titleLabel.mas_bottom).offset(STWidth(15));
        make.right.offset(STWidth(-15));

    }];
    
    _confirmButton = [UIButton new];
    [_confirmButton setTitle:@"我知道了" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:mHexColor(@"#306DFE") forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = STFontRegular(14);
    _confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [container addSubview:_confirmButton];
    [_confirmButton addTarget:self action:@selector(hiddenAnimation:) forControlEvents:UIControlEventTouchUpInside];

    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(STSize(60, 20));
        make.right.bottom.offset(-STWidth(15));
    }];
    
    return container;
}

-(void)hiddenAnimation:(UIButton *)sender{
    if (_buttonClicedExeHandler) {
        _buttonClicedExeHandler();
    }
    [self hideWithAnimated:YES completion:nil];
}

@end
