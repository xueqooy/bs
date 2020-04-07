//
//  LoginVerifyView.m
//  smartapp
//
//  Created by mac on 2019/7/19.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "LoginVerifyView.h"
#import "SharedLabelHeaderView.h"
#import "VerifyCodeTableViewCell.h"
#import "SharedTextTableViewCell.h"
#import "SharedButtonTableViewCell.h"
#import "LoginCommon.h"

@interface LoginVerifyView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SharedLabelHeaderView *headerView;
@property (nonatomic, strong) VerifyCodeTableViewCell *codeCell;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat textCellHeight;
@property (nonatomic, assign) CGFloat buttonCellHeight;
@property (nonatomic, assign) CGFloat verifyCellHeight;

@property (nonatomic, assign) BOOL pswFill;
@property (nonatomic, assign) BOOL verifyFill;
@end


@implementation LoginVerifyView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.fe_contentBackgroundColor;

        _isLoginVerify = NO;
        [self setUpViews];
    }
    return self;
}

- (void)beginEditing {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_codeCell setFirstResponder:YES];
    });
}

- (void)setIsLoginVerify:(BOOL)isLoginVerify {
    if (_isLoginVerify != isLoginVerify) {
        _isLoginVerify = isLoginVerify;
        [_tableView reloadData];
    }
}

- (void)setAccount:(NSString *)account {
    _account = account;
    NSString *displayMobileString = [NSString stringWithFormat:@"验证码已发送至%@ %@ %@",
                                     [account substringToIndex:3],
                                     [account substringWithRange:NSMakeRange(3, 4)], [account substringFromIndex:7]];
    [_headerView setMainBodyText:displayMobileString];
}

- (void)setUpViews {
    _headerHeight = [SizeTool originHeight:135] - mNavBarAndStatusBarHeight;
    _textCellHeight = [SizeTool height:60];
    _buttonCellHeight = [SizeTool height:105];
    _verifyCellHeight = STWidth(114);
    [self addSubview:self.tableView];
}


- (void)reloadViews {
    if (_tableView) {
       [_tableView reloadData];
    }
}

- (void)startCountDown {
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_codeCell startCountDown];
    });
    
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
    _headerView = [[SharedLabelHeaderView alloc] initWithHeadingText:@"请输入验证码" mainBodyText:@""];
    _headerView.frame = CGRectMake(0, 0, mScreenWidth, _headerHeight);
    self.tableView.tableHeaderView = _headerView;
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isLoginVerify) {
        return 1;
    } else {
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return _verifyCellHeight;
    } else if (indexPath.section == 2) {
        return _buttonCellHeight;
    }
    return _textCellHeight;
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return [UIView new];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        _codeCell = [[VerifyCodeTableViewCell alloc] init];
        _codeCell.retransmissionTimeInterval = 63;
       // [_codeCell setFirstResponder:YES];
        __weak typeof(self) weakSelf = self;
        _codeCell.completionHandler = ^(BOOL fill, NSString *code) {
            if (fill) {
                weakSelf.smsVerifyCode = code;
                weakSelf.verifyFill = YES;
                if (weakSelf.isLoginVerify) {//短信登录验证
                    [NSNotificationCenter.defaultCenter postNotificationName:nc_login_button_click object:@(LoginActionLoginSmsCodeInputCompletion)];
                    
                } else {
                    [weakSelf.codeCell setFirstResponder:NO];
                    SharedTextTableViewCell *textCell = [weakSelf viewWithTag:99999] ;
                    [textCell setFirstResponder:YES];
                }
            } else {
                weakSelf.verifyFill = NO;
            }
            
            SharedButtonTableViewCell *buttonCell = [tableView viewWithTag:2021];
            if (!_isLoginVerify && _pswFill) {
                [buttonCell setMainButtonEnabled:YES];
            } else {
                [buttonCell setMainButtonEnabled:NO];
            }
        };
    
        _codeCell.retransmissionHandler = ^{
            [NSNotificationCenter.defaultCenter postNotificationName:nc_login_button_click object:@(LoginActionSmsCodeResend)];
        };
        cell = _codeCell;
    } else if (indexPath.section == 1) {
        SharedTextTableViewCell *textCell = [[SharedTextTableViewCell alloc] init];
        textCell.tag = 99999;
        [textCell setPlaceholder:@"请输入密码"];
        [textCell buildComponent: SharedTextFieldComponentClearOrVisibleButton usePhoneFormat:NO];
        [textCell secureTextEntry:YES];
        textCell.stateChangedHandler = ^(BOOL completion, NSString *text) {
            _password = text;
            if (completion) {
                _pswFill = YES;
            } else {
                _pswFill = NO;
            }
            SharedButtonTableViewCell *buttonCell = [tableView viewWithTag:2021];
            if (completion && _verifyFill) {
                [buttonCell setMainButtonEnabled:YES];
            } else {
                [buttonCell setMainButtonEnabled:NO];
            }
        };
        cell = textCell;
    } else if (indexPath.section == 2) {
        SharedButtonTableViewCell *buttonCell = [[SharedButtonTableViewCell alloc] init];
        buttonCell.tag = 2021;
        [buttonCell setMainButtonTitle:@"注册"];
        buttonCell.buttonClickedHandler = ^(SharedButtonType type, UIButton * _Nonnull sender) {
            [NSNotificationCenter.defaultCenter postNotificationName:nc_login_button_click object:@(LoginActionRegistrationCompletion)];
        };
        cell = buttonCell;
    }
    return cell;
}


@end
