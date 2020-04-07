//
//  FEReportMoreButton.m
//  smartapp
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEReportMoreButton.h"
#import "TCCommonButton.h"
@implementation FEReportMoreButton {
    NSString *_buttonTitle;
}

- (instancetype)initWithButtonTitle:(NSString *)buttonTitle {
    self = [super init];
    _buttonTitle = buttonTitle;
    [self build];
    return self;
}

- (void)build {
    TCCommonButton *moreButton = [TCCommonButton new];
    moreButton.fe_adjustTitleColorAutomatically = YES;
    [moreButton setTitle:_buttonTitle forState:UIControlStateNormal];
    moreButton.titleLabel.font = STFontBold(14);
    moreButton.backgroundColor = UIColor.fe_buttonBackgroundColorActive;
    moreButton.layer.cornerRadius = STWidth(16);
    [self addSubview:moreButton];
    CGFloat buttonWidth = [_buttonTitle getWidthForFont:STFontBold(14)] + STWidth(30);
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.bottom.offset(0);
        make.size.mas_equalTo(CGSizeMake(buttonWidth, STWidth(32)));
    }];
    [moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonAction:(UIButton *)sender {
    if (_buttonClickHandler) {
        _buttonClickHandler();
    }
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [super setUserInteractionEnabled:userInteractionEnabled];
    if (userInteractionEnabled) {
        self.alpha = 1.0;
    } else {
        self.alpha = 0.5;
    }
}

@end
