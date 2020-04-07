//
//  LoginForgetView.m
//  smartapp
//
//  Created by mac on 2019/7/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "LoginForgetView.h"
#import "SharedLabelHeaderView.h"
#import "SharedTextTableViewCell.h"
#import "SharedButtonTableViewCell.h"
#import "LoginCommon.h"

@interface LoginForgetView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) SharedTextTableViewCell *phoneCell;

//@property (nonatomic, strong) UIImage *verifImage;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat textCellHeight;
@property (nonatomic, assign) CGFloat buttonCellHeight;

@property (nonatomic, assign) BOOL phoneFill;
@property (nonatomic, assign) BOOL smsVerifyFill;
@property (nonatomic, assign) BOOL nPasswordFill;
//@property (nonatomic, assign) BOOL imgVerifyFill;

//@property (nonatomic, assign) BOOL hasVerifImage;//是否出现验证码（登录错误3次出现验证码）
@end



@implementation LoginForgetView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.fe_contentBackgroundColor;

        
        [self setUpViews];
    }
    return self;
}

- (void)startCountDown {
    [_phoneCell startCountDown];
}

- (void)setUpViews {
    _headerHeight = [SizeTool originHeight:135] - mNavBarAndStatusBarHeight;
    _textCellHeight = [SizeTool height:80];
    _buttonCellHeight = [SizeTool height:122];
    [self addSubview:self.tableView];
}

- (void)reloadViews {
    if (_tableView) {
        [_tableView reloadData];
    }
}

- (void)setAccount:(NSString *)account {
    if ([NSString isEmptyString:account] || ![NSString validateContactNumber:account]) {
        _account = @"";
        return;
    }
    _account = account;
    SharedTextTableViewCell *accountCell = [_tableView viewWithTag:49999];
    if (accountCell) {
        [accountCell setText:account];
        _phoneFill = YES;
    }
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

//- (void)showVerificationCodeImage:(UIImage *)verfiImage {
//    _hasVerifImage = YES;
//    _verifImage = verfiImage;
//    [_tableView reloadData];
//    
//}
//
//- (void)dismissVerificationCodeImage {
//    _hasVerifImage = NO;
//    [_tableView reloadData];
//}
//
//- (BOOL)verificationCodeImageIsShown {
//    return _hasVerifImage;
//}

#pragma mark - private
- (void)addHeaderView {
    SharedLabelHeaderView *headerView = [[SharedLabelHeaderView alloc] initWithHeadingText:@"重置密码" mainBodyText:@""];
    headerView.frame = CGRectMake(0, 0, mScreenWidth, _headerHeight);
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (_hasVerifImage) {
//        return 4;
//    }
//    return 3;
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (_hasVerifImage) {
//        if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) return kTextCellHeight;
//        if (indexPath.section == 3) return kButtonCellHeight;
//    } else {
//        if (indexPath.section == 0 || indexPath.section == 1) return kTextCellHeight;
//        if (indexPath.section == 2) return kButtonCellHeight;
//    }
//    return 0;
    if (indexPath.section != 3) {
        return _textCellHeight;
    } else {
        return _buttonCellHeight;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
////    if (_hasVerifImage) {
////        if (section == 3) return 0;
////    } else {
////        if (section == 2) return 0;
////    }
////  return 50.f;
//    if (section == 3) return 0;
//    return 50.f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return [UIView new];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        SharedTextTableViewCell *textCell = [[SharedTextTableViewCell alloc] init];
        [textCell setPlaceholder:@"请输入手机号"];
        [textCell buildComponent: SharedTextFieldComponentClearOrVisibleButton + SharedTextFieldComponentVerifyButton + SharedTextFieldComponentAreaCode usePhoneFormat:YES];
        [textCell setAutoCountDown:NO];
        [textCell setRetransmissionTimeInterval:63];
         
        if (_account) {
            [textCell setText:_account];
            _phoneFill = YES;
        }
        textCell.stateChangedHandler = ^(BOOL completion, NSString *text) {
            SharedButtonTableViewCell *buttonCell = [tableView viewWithTag:2021];
            if (completion) {
                _account = text;
                _phoneFill = YES;

                if (_smsVerifyFill && _nPasswordFill) {
                    [buttonCell setMainButtonEnabled:YES];
                } else {
                    [buttonCell setMainButtonEnabled:NO];
                }
            } else {
                _phoneFill = NO;
                [buttonCell setMainButtonEnabled:NO];
            }
        };
        textCell.clickedVerifyButtonHandler = ^{
            [NSNotificationCenter.defaultCenter postNotificationName:nc_login_button_click object:@(LoginActionPasswordResttingSmsCodeRequest)];
        };
        _phoneCell = textCell;
        cell = textCell;
    } else if (indexPath.section == 1) {
        SharedTextTableViewCell *textCell = [[SharedTextTableViewCell alloc] init];
        [textCell setReceiveSmsCodeEnabled:YES];
        [textCell setPlaceholder:@"请输入验证码"];
        [textCell buildComponent: SharedTextFieldComponentClearOrVisibleButton  usePhoneFormat:NO];
       
        textCell.stateChangedHandler = ^(BOOL completion, NSString *text) {
            SharedButtonTableViewCell *buttonCell = [tableView viewWithTag:2021];
            if (completion) {
                _smsVerifyCode = text;
                _smsVerifyFill = YES;

                if (_phoneFill && _nPasswordFill) {
                    [buttonCell setMainButtonEnabled:YES];
                } else {
                    [buttonCell setMainButtonEnabled:NO];
                }
            } else {
                _smsVerifyFill = NO;
                [buttonCell setMainButtonEnabled:NO];
            }
        };
        cell = textCell;
    }

    else if (indexPath.section == 2) {
        SharedTextTableViewCell *textCell = [[SharedTextTableViewCell alloc] init];
        [textCell setPlaceholder:@"请输入6位以上的密码"];
        [textCell buildComponent: SharedTextFieldComponentClearOrVisibleButton  usePhoneFormat:NO];
        [textCell secureTextEntry:YES];
        textCell.stateChangedHandler = ^(BOOL completion, NSString *text) {
            SharedButtonTableViewCell *buttonCell = [tableView viewWithTag:2021];
            if (completion) {
                _nPassword = text;
                _nPasswordFill = YES;
           
                if (_phoneFill && _smsVerifyFill) {
                    [buttonCell setMainButtonEnabled:YES];
                } else {
                    [buttonCell setMainButtonEnabled:NO];
                }
            } else {
                _nPasswordFill = NO;
                [buttonCell setMainButtonEnabled:NO];
            }
        };
        cell = textCell;
    } else {
        SharedButtonTableViewCell *buttonCell = [self createButtonCellFor:tableView];
        cell = buttonCell;
    }
    return cell;
}

- (SharedButtonTableViewCell *)createButtonCellFor:(UITableView *)tableView {
    SharedButtonTableViewCell *buttonCell = [[SharedButtonTableViewCell alloc] init];
    buttonCell.tag = 2021;
    [buttonCell setMainButtonTitle:@"完成"];
    buttonCell.buttonClickedHandler = ^(SharedButtonType type, UIButton * _Nonnull sender) {
        [NSNotificationCenter.defaultCenter postNotificationName:nc_login_button_click object:@(LoginActionPasswordResttingNext)];
    };

    return buttonCell;
}


@end
