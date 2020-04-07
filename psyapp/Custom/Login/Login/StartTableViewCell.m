//
//  StartTableViewCell.m
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/15.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import "StartTableViewCell.h"
#import "FastClickUtils.h"
@interface StartTableViewCell()<CAAnimationDelegate>
@end
@implementation StartTableViewCell
{
    UIButton *accountButton;
}
- (void)setUpSubviews {
    self.backgroundColor = [UIColor clearColor];
    accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    accountButton.fe_adjustTitleColorAutomatically = YES;
    accountButton.titleLabel.font = STFontBold(17);
    accountButton.backgroundColor = UIColor.fe_mainColor;
    accountButton.layer.cornerRadius = STWidth(2);
    [accountButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:accountButton];
    [accountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(STSize(315, 60));
    }];
}

- (void)setTilte:(NSString *)title registerType:(BOOL)type{
    [accountButton setTitle:title forState:UIControlStateNormal];
    if (type) {
        accountButton.backgroundColor = UIColor.fe_contentBackgroundColor;
        accountButton.layer.borderWidth = 0.5;
        accountButton.layer.borderColor = [UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0].CGColor;
        accountButton.layer.cornerRadius = STWidth(2);
    } 
}

- (void)click {
    if ([FastClickUtils isFastClick]) return;

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@0.99,@0.98,@0.97,@0.96,@.97,@0.98,@0.99,@1.0];
    animation.duration = 0.15;
    animation.calculationMode = kCAAnimationCubic;
    animation.delegate = self;
    [accountButton.layer addAnimation:animation forKey:nil];
    accountButton.alpha = 0.8f;
    if (_callBack) {
        _callBack();
    }
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    accountButton.alpha = 1.f;
}
@end
