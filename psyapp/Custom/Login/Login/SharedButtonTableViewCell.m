//
//  SharedButtonTableViewCell.m
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/17.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import "SharedButtonTableViewCell.h"
#import "TCCommonButton.h"
#import "FastClickUtils.h"
@interface SharedButtonTableViewCell ()<CAAnimationDelegate>
@end
@implementation SharedButtonTableViewCell
{
    TCCommonButton *mainButton;
    UIButton *leftButton;
    UIButton *rightButton;
    MASConstraint *mainButtonBottomConstrait;
}

#pragma mark - public
- (void)buildComponent:(SharedButtonComponent)comp {
    if (comp & SharedButtonComponentLeftButton) {
        [self buildLeftButton];
    }
    if (comp & SharedButtonComponentRightButton) {
        [self buildRightButton];
    }
}

- (void)setHidden:(BOOL)hidden forButton:(SharedButtonType)type {
    if (type == SharedButtonTypetMain) {
        mainButton.hidden = hidden;
    } else if (type == SharedButtonTypeLeft) {
        leftButton.hidden = hidden;
    } else if (type == SharedButtonTypeRight) {
        rightButton.hidden = hidden;
    }
}

- (void)setMainButtonTitle:(NSString *)title {
    [mainButton setTitle:title forState:UIControlStateNormal];
}

- (void)setLeftButtonTitle:(NSString *)title {
    if (leftButton) {
        [leftButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setRightButtonTitle:(NSString *)title {
    if (rightButton) {
        [rightButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setMainButtonEnabled:(BOOL)enabled{
    mainButton.enabled = enabled;
    if (enabled) {
        mainButton.backgroundColor = UIColor.fe_mainColor;
    } else {
        mainButton.backgroundColor = [UIColor.fe_mainColor colorWithAlphaComponent:0.4];
    }
}
#pragma mark - private
- (void)setUpSubviews {
    mainButton = [TCCommonButton new];
//    mainButton.fe_adjustTitleColorAutomatically = YES;
    mainButton.backgroundColor = [UIColor.fe_mainColor colorWithAlphaComponent:0.4];
    [mainButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    mainButton.layer.cornerRadius = STWidth(4);
    mainButton.titleLabel.font = STFontBold(17);
    mainButton.enabled = NO;
    mainButton.tag = 3000;
    [mainButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:mainButton];
    
    [mainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(STWidth(15));
        make.right.equalTo(self.contentView).offset(-STWidth(15));
        make.height.mas_equalTo(STHeight(48));
       // make.top.equalTo(self).offset(STWidth(30)).priorityLow();
        mainButtonBottomConstrait = make.bottom.mas_equalTo(STWidth(-27));
    }];
}

- (void)buildRightButton {
    rightButton = [UIButton new];
    [rightButton setTitleColor:UIColor.fe_textColorHighlighted forState:UIControlStateNormal];
    rightButton.titleLabel.font = STFont(12);
    rightButton.tag = 3002;
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:rightButton];
    
   // [mainButtonBottomConstrait uninstall];
    mainButtonBottomConstrait.mas_equalTo(STWidth(-45));
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.top.equalTo(self->mainButton.mas_bottom).offset(STWidth(14)).priorityLow();
        make.right.equalTo(self.contentView).offset(-STWidth(15));
       // make.size.mas_equalTo(CGSizeMake(STWidth(80), STWidth(30)));
        make.bottom.mas_equalTo(0);
    }];
}

- (void)buildLeftButton {
    leftButton = [UIButton new];
    [leftButton setTitleColor:UIColor.fe_textColorHighlighted forState:UIControlStateNormal];
    leftButton.titleLabel.font = STFont(12);
    leftButton.tag = 3001;
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:leftButton];
    
     mainButtonBottomConstrait.mas_equalTo(STWidth(-45));
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.top.equalTo(self->mainButton.mas_bottom).offset(STWidth(19)).priorityLow();
        make.left.equalTo(self.contentView).offset(STWidth(15));
        //make.size.mas_equalTo(STSize(80, 30));
        make.bottom.mas_equalTo(0);
    }];
}

- (void)buttonClicked:(UIButton *)sender {

    SharedButtonType type = sender.tag %3000;
    if (_buttonClickedHandler) {
        _buttonClickedHandler(type, sender);
    }
}



@end
