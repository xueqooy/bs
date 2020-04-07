//
//  ThirdSignInFooterView.m
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/16.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import "ThirdSignInFooterView.h"

@implementation ThirdSignInFooterView
{
    BOOL qqInstall;
    BOOL wxInstall;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //qq、微信是否安装
//        qqInstall = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"mqqapi://"]];
//        wxInstall = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]];
    
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews {
    UILabel *label = [UILabel new];
    label.text = @"其他登录方式";
    label.font = STFont(9);
    label.textColor = mHexColor(@"949494");
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    
    UIView *topLeftLine = [UIView new];
    topLeftLine.backgroundColor = mHexColor(@"E7E7E7");
    [self addSubview:topLeftLine];
    [topLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self).offset(STWidth(15));
        make.right.equalTo(label.mas_left).offset(-STWidth(5));
        make.centerY.equalTo(label);
    }];
    
    UIView *topRightLine = [UIView new];
    topRightLine.backgroundColor = mHexColor(@"E7E7E7");
    [self addSubview:topRightLine];
    [topRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.right.equalTo(self).offset(-STWidth(15));
        make.left.equalTo(label.mas_right).offset(STWidth(5));
        make.centerY.equalTo(label);
    }];
    
    if(!qqInstall && !wxInstall) {
        label.hidden = YES;
        topLeftLine.hidden = YES;
        topRightLine.hidden = YES;
    }
    
    //(3: -0.3 0 0.3)  (2: -2 2)  (1: 0.5)
    __block CGFloat centerOffScale;
    if (qqInstall) {
        UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [qqButton setImage:[[UIImage imageNamed:@"qq"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        qqButton.tag = 10001;
        [qqButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:qqButton];
        [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
            centerOffScale =  wxInstall? -0.2 : 0;
            make.top.equalTo(topLeftLine.mas_bottom).offset(STWidth(22));
            make.size.mas_equalTo(STSize(40, 40));
            make.centerX.equalTo(self).offset(self.width * centerOffScale);
        }];
        
        UILabel *qqLabel = [UILabel new];
        qqLabel.text = @"QQ";
        qqLabel.font = STFont(12);
        qqLabel.textAlignment = NSTextAlignmentCenter;
        qqLabel.textColor = mHexColor(@"949494");
        [self addSubview:qqLabel];
        [qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(qqButton);
            make.top.equalTo(qqButton.mas_bottom).offset(STWidth(6));
        }];
    }
    
    if (wxInstall) {
        UIButton *wechatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [wechatButton setImage:[[UIImage imageNamed:@"wechat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        wechatButton.tag = 10002;
        [wechatButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:wechatButton];
        [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            centerOffScale = qqInstall? 0.2 : 0;
            make.top.equalTo(topLeftLine.mas_bottom).offset(STWidth(22));
            make.size.mas_equalTo(STSize(40, 40));
            make.centerX.equalTo(self).offset(self.width * centerOffScale);
        }];
        
        UILabel *wechatLabel = [UILabel new];
        wechatLabel.text = @"微信";
        wechatLabel.font = STFont(12);
        wechatLabel.textAlignment = NSTextAlignmentCenter;
        wechatLabel.textColor = mHexColor(@"949494");
        [self addSubview:wechatLabel];
        [wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wechatButton);
            make.top.equalTo(wechatButton.mas_bottom).offset(STWidth(6));
        }];
    }
    
//    UIButton *vistorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [vistorButton setImage:[[UIImage imageNamed:@"login_vistor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    vistorButton.tag = 10003;
//    [vistorButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self addSubview:vistorButton];
//    if (qqInstall && wxInstall) {
//        centerOffScale = 0.3;
//    } else if (!qqInstall && !wxInstall) {
//        centerOffScale = 0;
//    } else {
//        centerOffScale = 0.2;
//    }
//    [vistorButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(topLeftLine.mas_bottom).offset(STWidth(22));
//        make.size.mas_equalTo(STSize(40, 40));
//        make.centerX.equalTo(self).offset(self.width * centerOffScale);
//    }];
    
//    UILabel *vistorLabel = [UILabel new];
//    vistorLabel.text = @"游客";
//    vistorLabel.font = STFont(12);
//    vistorLabel.textAlignment = NSTextAlignmentCenter;
//    vistorLabel.textColor = mHexColor(@"949494");
//    [self addSubview:vistorLabel];
//    [vistorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(vistorButton);
//        make.top.equalTo(vistorButton.mas_bottom).offset(6);
//    }];

    
    UILabel *warningLabel = [UILabel new];
    warningLabel.text = @"登录注册，即表示已阅读并同意";
    warningLabel.font = STFont(11);
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.textColor = mHexColor(@"949494");
    
    UILabel *serviceLabel = [UILabel new];
    serviceLabel.textAlignment = NSTextAlignmentCenter;
    serviceLabel.font = STFont(11);
    serviceLabel.textColor = UIColor.fe_textColorHighlighted;
    NSString *serviceString = @"《服务协议》";
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtString = [[NSMutableAttributedString alloc]initWithString:serviceString attributes:attribtDic];
    serviceLabel.attributedText = attribtString;
    
    UILabel *andLabel = [UILabel new];
    andLabel.text = @"及";
    andLabel.font = STFont(11);
    andLabel.textAlignment = NSTextAlignmentCenter;
    andLabel.textColor = mHexColor(@"949494");
    
    UILabel *secretLabel = [UILabel new];
    secretLabel.textAlignment = NSTextAlignmentCenter;
    secretLabel.font = STFont(11);
    secretLabel.textColor = UIColor.fe_textColorHighlighted;
    NSString *secretString = @"《隐私政策》";
    NSMutableAttributedString *sattribtString = [[NSMutableAttributedString alloc]initWithString:secretString attributes:attribtDic];
    secretLabel.attributedText = sattribtString;
    
    [self addSubview:warningLabel];
    CGFloat warningLabelWidth = [warningLabel getTextWidthForFontSize:STWidth(12) height:STWidth(12)];
    CGFloat serviceLabelWidth = [serviceLabel getTextWidthForFontSize:STWidth(12) height:STWidth(12)];
    CGFloat andLabelWidth = [andLabel getTextWidthForFontSize:STWidth(12) height:STWidth(12)];
    CGFloat secrectLabelWidth = [secretLabel getTextWidthForFontSize:STWidth(12) height:STWidth(12)];
    CGFloat centerOffset =  warningLabelWidth/2 - (warningLabelWidth - serviceLabelWidth - secrectLabelWidth - andLabelWidth)/2 - STWidth(10);
    [warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(- centerOffset);
        make.bottom.mas_equalTo(-STWidth(15));
    }];
    
    [self addSubview:serviceLabel];
    [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(warningLabel.mas_right);
        make.centerY.equalTo(warningLabel);
    }];
    
    [self addSubview:andLabel];
    [andLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(serviceLabel.mas_right);
        make.centerY.equalTo(warningLabel);
    }];
    
    [self addSubview:secretLabel];
    [secretLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(andLabel.mas_right);
        make.centerY.equalTo(warningLabel);
    }];
    
    UIButton *serviceButton = [UIButton new];
    serviceButton.tag = 10004;
    [serviceButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:serviceButton];
    [serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(serviceLabel);
        make.size.equalTo(serviceLabel);
    }];
    
    UIButton *secretButton = [UIButton new];
    secretButton.tag = 10005;
    [secretButton addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:secretButton];
    [secretButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(secretLabel);
        make.size.equalTo(secretLabel);
    }];
}

- (void)clickEvent:(UIControl *)sender {
    mLog(@"click");
    if (sender.tag == 10001) {//qq
        if (_qqButtonClickHandler) {
            _qqButtonClickHandler();
        }
    } else if (sender.tag == 10002) {//wechat
        if (_wechatButtonClickHandler) {
            _wechatButtonClickHandler();
        }
    } else if (sender.tag == 10003){
        if (_vistorButtonClickHandler) {
            _vistorButtonClickHandler();
        }
    } else if (sender.tag == 10004) {
        if (_serviceButtonClickHandler) {
            _serviceButtonClickHandler();
        }
    } else  {
        if (_secretButtonClickHandler) {
            _secretButtonClickHandler();
        }
    }
}



- (UIButton *)createButtonWithImage:(NSString *)image title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:mHexColor(@"949494") forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    return button;
}

@end
