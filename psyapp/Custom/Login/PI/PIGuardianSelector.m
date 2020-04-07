//
//  PIGuardianSelector.m
//  smartapp
//
//  Created by mac on 2019/11/2.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "PIGuardianSelector.h"
#import "PICommonInfo.h"
@interface PIGuardianSelector ()
@property (strong, nonatomic) UIView *buttonContainer;
@property (nonatomic, strong) UIView *safeAreaPlaceholderView;

@property (nonatomic, weak) UIButton *lastSelectedButton;

@end
@implementation PIGuardianSelector
@synthesize pi_selectedHandler = _pi_selectedHandler;
@synthesize pi_hiddenHandler = _pi_hiddenHandler;
- (instancetype)initWithFrame:(CGRect)frame {
    CGRect _frame  = CGRectMake(0, 0, mScreenWidth, mScreenHeight);
    self = [super initWithFrame:_frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupViews];
        _buttonContainer.transform = CGAffineTransformMakeTranslation(0, STWidth(300));

        @weakObj(self);
        [self addTapGestureWithBlock:^{
            @strongObj(self);
            [self _hide];
        }];
    }
    return self;
}

- (void)setupViews {
    _buttonContainer = [UIView new];
    _buttonContainer.frame = CGRectMake(0, mScreenHeight - mBottomSafeHeight - STWidth(300), mScreenWidth, STWidth(300));
    [self addSubview:_buttonContainer];
    
    _safeAreaPlaceholderView = [UIView new];
    _safeAreaPlaceholderView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _safeAreaPlaceholderView.frame = CGRectMake(0, CGRectGetMaxY(_buttonContainer.frame), mScreenWidth, mBottomSafeHeight);
    [self addSubview:_safeAreaPlaceholderView];
    
    UIButton *fatherButton      = [self createButtonWithTitle:PIGuardianFather];
    UIButton *motherButton      = [self createButtonWithTitle:PIGuardianMother];
    UIButton *grandfatherButton = [self createButtonWithTitle:PIGuardianGrandFather];
    UIButton *grandmotherButton = [self createButtonWithTitle:PIGuardianGrandMother];
    UIButton *otherButton       = [self createButtonWithTitle:PIGuardianOther];

    fatherButton.frame      = CGRectMake(0, 0, mScreenWidth, STWidth(60));
    motherButton.frame      = CGRectMake(0, STWidth(60), mScreenWidth, STWidth(60));
    grandfatherButton.frame = CGRectMake(0, STWidth(120), mScreenWidth, STWidth(60));
    grandmotherButton.frame = CGRectMake(0, STWidth(180), mScreenWidth, STWidth(60));
    otherButton.frame       = CGRectMake(0, STWidth(240), mScreenWidth, STWidth(60));

    [_buttonContainer addSubview:fatherButton];
    [_buttonContainer addSubview:motherButton];
    [_buttonContainer addSubview:grandfatherButton];
    [_buttonContainer addSubview:grandmotherButton];
    [_buttonContainer addSubview:otherButton];

}

- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = UIColor.fe_contentBackgroundColor;
    button.titleLabel.font = STFontRegular(16);
    [button setTitleColor:UIColor.fe_titleTextColorLighten forState:UIControlStateNormal];

    if (![title isEqualToString:PIGuardianOther]) {
        UIView *lineView = [UIView new];
        lineView.backgroundColor = UIColor.fe_separatorColor;
        lineView.frame = CGRectMake(0, STWidth(59), mScreenWidth, STWidth(1));
        [button addSubview:lineView];
    }

    [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)_hide {
    [UIView animateWithDuration:0.25 animations:^{
        _buttonContainer.transform = CGAffineTransformMakeTranslation(0, STWidth(300));
        self.backgroundColor =  [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.pi_hiddenHandler) {
            self.pi_hiddenHandler();
        }
    }];
}

- (void)touchDownAction:(UIButton *)sender {
    sender.backgroundColor = UIColor.fe_backgroundColor;
    _lastSelectedButton = sender;
    if (_pi_selectedHandler) {
        _pi_selectedHandler(sender.titleLabel.text);
        [self _hide];
    }
}

- (void)pi_showSelector {
    _lastSelectedButton.backgroundColor = UIColor.fe_contentBackgroundColor;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        _buttonContainer.transform = CGAffineTransformIdentity;
         self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }];
}


@end
