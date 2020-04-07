//
//  LoginPasswordView.m
//  smartapp
//
//  Created by mac on 2019/7/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "LoginPasswordView.h"
#import "SharedLabelHeaderView.h"
#import "SharedTextTableViewCell.h"
#import "SharedButtonTableViewCell.h"
#import "ThirdSignInFooterView.h"
#import "FastClickUtils.h"
#import "LoginCommon.h"

@interface LoginPasswordView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SharedLabelHeaderView *headerView;
@property (nonatomic, strong) UIImage *verifImage;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) CGFloat textCellHeight;
@property (nonatomic, assign) CGFloat buttonCellHeight;

@property (nonatomic, assign) BOOL phoneFill;
@property (nonatomic, assign) BOOL pswFill;
@property (nonatomic, assign) BOOL verifyFill;
@property (nonatomic, assign) BOOL registerType;
@property (nonatomic, assign) BOOL hasVerifImage;//是否出现验证码（登录错误3次出现验证码）

@end


#define UNVALID_ROW 999

@implementation LoginPasswordView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.fe_contentBackgroundColor;
        
        _textCellHeight = [SizeTool height:80];
        _buttonCellHeight = [SizeTool height:122];
        _registerType = NO;
        _hasVerifImage = NO;
        _verifyCode = @"";

        [self setUpViews];
    }
    return self;
}

- (void)reload {
    _hasVerifImage = NO;
    _verifyCode = @"";
    _password = @"";
    _account = @"";
    _phoneFill = NO;
    _pswFill = NO;
    _verifyFill = NO;
    [_tableView reloadData];
}

- (void)showVerificationCodeImage:(UIImage *)verfiImage {
    _hasVerifImage = YES;
    _verifImage = verfiImage;
    [_tableView reloadData];
    
}

- (void)dismissVerificationCodeImage {
    _hasVerifImage = NO;
    [_tableView reloadData];
}

- (BOOL)verificationCodeImageIsShown {
    return _hasVerifImage;
}

- (void)setRegisterType:(BOOL)type {
    _registerType = type;
    if (type) {
        [_headerView setHeadingText:@"注册账号"];
    } else {
        [_headerView setHeadingText:@"账号密码登录"];
    }
    [_tableView reloadData];
}

- (BOOL)isRegisterType {
  
    return _registerType;
}

- (void)setUpViews {
    _headerHeight = [SizeTool originHeight:135] - mNavBarAndStatusBarHeight;
    _footerHeight = [SizeTool height:135];
    [self addSubview:self.tableView];
    [self addFooterView];
}

- (void)reloadViews {
    if (_tableView) {
        _account = nil;
        [_tableView reloadData];
    }
}

- (void)setPhoneText:(NSString *)phone {
    if ([NSString isEmptyString:phone] || ![NSString validateContactNumber:phone]) {
        return;
    }
    _account = phone;
    SharedTextTableViewCell *accountCell = [_tableView viewWithTag:49999];
    if (accountCell) {
        [accountCell setText:phone];
        _phoneFill = YES;
    }
}

//暂时保留
- (void)setAccount:(NSString *)account {
    if ([NSString isEmptyString:account]) {
        return;
    }
    _account = account;
    SharedTextTableViewCell *accountCell = [_tableView viewWithTag:49999];
    if (accountCell) {
        [accountCell setText:account];
        _phoneFill = YES;
    }
    
}

- (void)addFooterView {
    ThirdSignInFooterView *thirdSignInFooterView = [[ThirdSignInFooterView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, _footerHeight)];
   
    thirdSignInFooterView.serviceButtonClickHandler = ^{
        [NSNotificationCenter.defaultCenter postNotificationName:nc_login_button_click object:@(LoginActionServiceAgreement)];
    };
    thirdSignInFooterView.secretButtonClickHandler = ^{
        [NSNotificationCenter.defaultCenter postNotificationName:nc_login_button_click object:@(LoginActionSecretAgreement)];
    };
    [self addSubview: thirdSignInFooterView];
    
    [thirdSignInFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-mBottomSafeHeight);
        make.height.mas_equalTo(self.footerHeight);
    }];
}
#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        CGRect frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight);
        _tableView.frame = frame;
        _tableView.backgroundColor = UIColor.fe_contentBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.allowsSelection = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addHeaderView];
    }
    return _tableView;
}

#pragma mark - private
- (void)addHeaderView {
    _headerView = [[SharedLabelHeaderView alloc] initWithHeadingText:@"登录" mainBodyText:@""];
    _headerView.frame = CGRectMake(0, 0, mScreenWidth, _headerHeight);
    self.tableView.tableHeaderView = _headerView;
}



#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_hasVerifImage) {
        return 4;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (_hasVerifImage) {
        if (section == 3) return _buttonCellHeight;
        return _textCellHeight;
    } else {
        if (section == 2) return _buttonCellHeight;
        return _textCellHeight;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [self createPhoneTextTableViewCellForTableView:tableView];
    } else if (indexPath.section == 1) {
        cell = [self createPasswordTextTableViewCellForTableView:tableView];
    } else if (indexPath.section == 2) {
        if (_hasVerifImage) {
            cell = [self createVerifyTextTableViewCellForTableView:tableView];
        } else {
            cell = [self createButtonTableViewCellForTableView:tableView];
        }
    } else if (indexPath.section == 3) {
        cell = [self createButtonTableViewCellForTableView:tableView];
    }
    
    return cell;
}

- (SharedTextTableViewCell *)createPhoneTextTableViewCellForTableView:(UITableView *)tableView {
    SharedTextTableViewCell *textCell = [[SharedTextTableViewCell alloc] init];
   
    textCell.tag = 49999;
    [textCell setPlaceholder:_registerType? @"请输入6位以上数字字母组合的账号":@"请输入账号"];
    
    [textCell buildComponent: SharedTextFieldComponentClearOrVisibleButton  usePhoneFormat:NO];
   
    if (![NSString isEmptyString:_account]) {
        [textCell setText:_account];
        _phoneFill = YES;
    }
    if (_hasVerifImage) {
        [textCell setText:_account];
        [textCell setFirstResponder:NO];
    }
    __weak typeof(self) weakSelf = self;
    textCell.stateChangedHandler = ^(BOOL completion, NSString *text) {
        SharedButtonTableViewCell *buttonCell = [tableView viewWithTag:2021];
        if (completion) {
            
           
            weakSelf.account = text;
            weakSelf.phoneFill = YES;
            
            if (weakSelf.hasVerifImage) {
                if (weakSelf.pswFill && weakSelf.verifyFill) {
                    [buttonCell setMainButtonEnabled:YES];
                } else {
                    [buttonCell setMainButtonEnabled:NO];
                }
            } else {
                if (weakSelf.pswFill) {
                    [buttonCell setMainButtonEnabled:YES];
                } else {
                    [buttonCell setMainButtonEnabled:NO];
                }
            }
            
           
        } else {
            if (text.length == 0) {
               weakSelf.account = @"";
            }
            weakSelf.phoneFill = NO;
            [buttonCell setMainButtonEnabled:NO];
        }
    };
    return textCell;
}

- (SharedTextTableViewCell *)createPasswordTextTableViewCellForTableView:(UITableView *)tableView {
    SharedTextTableViewCell *textCell = [[SharedTextTableViewCell alloc] init];
    textCell.tag = 50000;
    [textCell setPlaceholder:_registerType? @"请输入6位以上的密码" : @"请输入密码"];
    [textCell buildComponent: SharedTextFieldComponentClearOrVisibleButton  usePhoneFormat:NO];
    [textCell secureTextEntry:YES];

    if (_password && ![_password isEqualToString:@""] && _hasVerifImage) {
        [textCell setText:_password];
        [textCell setFirstResponder:NO];
    }
    if (_hasVerifImage) {
        [textCell setFirstResponder:YES];
    }
    @weakObj(self);
    textCell.stateChangedHandler = ^(BOOL completion, NSString *text) {
        SharedButtonTableViewCell *buttonCell = [tableView viewWithTag:2021];
        if (completion) {
            selfweak.password = text;
            selfweak.pswFill = YES;
            if (selfweak.phoneFill) {
                if (selfweak.hasVerifImage && selfweak.verifyFill) {//如果有验证码，并且已经填写，那么使能按钮
                    [buttonCell setMainButtonEnabled:YES];
                } else if (!selfweak.hasVerifImage) {
                    [buttonCell setMainButtonEnabled:YES];
                }
            }
        } else {
            selfweak.pswFill = NO;
            [buttonCell setMainButtonEnabled:completion];
        }
    };
    return textCell;
}

- (SharedTextTableViewCell *)createVerifyTextTableViewCellForTableView:(UITableView *)tableView {
    SharedTextTableViewCell *textCell = [[SharedTextTableViewCell alloc] init];
    [textCell setPlaceholder:@"请输入验证码"];
    [textCell buildComponent: SharedTextFieldComponentClearOrVisibleButton + SharedTextFieldComponentVerifyImage  usePhoneFormat:NO];
    if (_verifImage) {
        [textCell setVerificationImage:_verifImage];
        [textCell setFirstResponder:YES];
    }
    @weakObj(self);
    textCell.stateChangedHandler = ^(BOOL completion, NSString *text) {
        SharedButtonTableViewCell *buttonCell = [tableView viewWithTag:2021];
        if (completion) {
            selfweak.verifyCode = text;
            selfweak.verifyFill = YES;
            
            if (selfweak.phoneFill &&selfweak.pswFill) {
                [buttonCell setMainButtonEnabled:YES];
            } else {
                [buttonCell setMainButtonEnabled:completion];
            }
            
        } else {
            selfweak.verifyFill = NO;
            [buttonCell setMainButtonEnabled:completion];
        }
    };
    textCell.clickedVerifyImageHandler = ^{
        if ([FastClickUtils isFastClick]) {
            return;
        }
        //切换验证码图片
    
        [NSNotificationCenter.defaultCenter postNotificationName:nc_login_button_click object:@(LoginActionCaptchaImageChange)];
    };
    return textCell;
}

- (SharedButtonTableViewCell *)createButtonTableViewCellForTableView:(UITableView *)tableView {
    SharedButtonTableViewCell *buttonCell = [[SharedButtonTableViewCell alloc] init];
    buttonCell.tag = 2021;
//    if (_verifyLoginType) {
//        [buttonCell buildComponent:SharedButtonComponentRightButton ];
//    } else {
//        [buttonCell buildComponent:SharedButtonComponentRightButton + SharedButtonComponentLeftButton];
//    }
    [buttonCell buildComponent:SharedButtonComponentRightButton ];
    
    [buttonCell setMainButtonTitle:_registerType?@"完成": @"登录"];
    [buttonCell setRightButtonTitle:_registerType?@"登录": @"注册"];
//    [buttonCell setLeftButtonTitle:@"忘记密码"];
    @weakObj(self);
    buttonCell.buttonClickedHandler = ^(SharedButtonType type, UIButton * _Nonnull sender) {
        if (type == SharedButtonTypeRight) {
            [NSNotificationCenter.defaultCenter postNotificationName:nc_login_button_click object:@(LoginActionModeSwitch)];
        } else {
            if (selfweak.registerType) {
                [NSNotificationCenter.defaultCenter postNotificationName:nc_login_button_click object:@(LoginActionRegistrationCompletion)];
            } else {
                [NSNotificationCenter.defaultCenter postNotificationName:nc_login_button_click object:@(LoginActionLoginByPassword)];
            }
        }
    };
    return buttonCell;
}
@end
