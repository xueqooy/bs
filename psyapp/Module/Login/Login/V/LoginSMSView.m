//
//  LoginSMSView.m
//  smartapp
//
//  Created by mac on 2019/7/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "LoginSMSView.h"
#import "SharedLabelHeaderView.h"
#import "SharedTextTableViewCell.h"
#import "SharedButtonTableViewCell.h"
#import "ThirdSignInFooterView.h"
#import "FastClickUtils.h"
#import "LoginCommon.h"
@interface LoginSMSView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImage *verifImage;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) CGFloat textCellHeight;
@property (nonatomic, assign) CGFloat buttonCellHeight;

@property (nonatomic, assign) BOOL phoneFill;
@property (nonatomic, assign) BOOL verifyFill;
@property (nonatomic, assign) BOOL hasVerifImage;//是否出现验证码（登录错误3次出现验证码）

@property (nonatomic, strong) UIButton *backButton;
@end


@implementation LoginSMSView
{
    SharedLabelHeaderView *headerView ;
    ThirdSignInFooterView *thirdSignInFooterView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.fe_contentBackgroundColor;

        _hasVerifImage = NO;
        _verifyCode = @"";
        [self setUpViews];
    }
    return self;
}

- (void)setHeading:(NSString *)heading mainBody:(NSString *)mainBody {
    [headerView setMainBodyText:mainBody];
    [headerView setHeadingText:heading];
}

- (void)setUpViews {
    _headerHeight = [SizeTool originHeight:135] - mNavBarAndStatusBarHeight;
    _footerHeight = [SizeTool height:135.f];
    _textCellHeight = [SizeTool height:80];
    _buttonCellHeight = [SizeTool height:122];
    

    [self addSubview:self.tableView];
    
    
}

- (void)backButtonAction:(UIButton *)sender {
    
}

- (void)reloadViews {
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

- (void)setPhoneText:(NSString *)phone {
    if ([NSString isEmptyString:phone] || ![NSString validateContactNumber:phone]) {
        return;
    }
    _account = phone;
    __weak typeof (self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SharedTextTableViewCell *textCell = [weakSelf viewWithTag:11404];
        [textCell setText:phone];//确保textCell已经加载
        [textCell setFirstResponder:NO];
        [textCell setFirstResponder:YES];
        //赋值并不能响应textChanged,需要手动使能按钮
        SharedButtonTableViewCell *buttonCell = [weakSelf viewWithTag:2021];
        [buttonCell setMainButtonEnabled:YES];
    });
}

- (void)setBindingType:(BOOL)isBinding {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isBindingType = isBinding;
        SharedButtonTableViewCell *buttonCell = [self viewWithTag:2021];
        if (!isBinding) {
            [self setHeading:@"欢迎来到心知鹿" mainBody:@"若该手机号未注册，我们将自动为您注册"];
            thirdSignInFooterView.hidden = NO;
            _backButton.hidden = NO;
            [buttonCell setHidden:NO forButton:SharedButtonTypeRight];
        } else {
            [self setHeading:@"绑定手机号" mainBody:@"若该手机号未注册，我们将自动为您注册"];
            thirdSignInFooterView.hidden = YES;
            _backButton.hidden = YES;
            [buttonCell setHidden:YES forButton:SharedButtonTypeRight];
        }
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
    headerView = [[SharedLabelHeaderView alloc] initWithHeadingText:@"欢迎来到心知鹿" mainBodyText:@"若该手机号未注册，我们将自动为您注册"];
    headerView.frame = CGRectMake(0, 0, mScreenWidth, _headerHeight);
    self.tableView.tableHeaderView = headerView;
}


#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_hasVerifImage) return 3;
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_hasVerifImage) {
        if (indexPath.section == 2) return _buttonCellHeight;
    } else {
        if (indexPath.section == 1) return _buttonCellHeight;
    }
    return _textCellHeight;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (_hasVerifImage) {
//        if (section == 0 || section == 1) {
//            return 50.f;
//        }
//    } else {
//        if (section == 0) {
//            return 50.f;
//        }
//    }
//    return 30.f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return [UIView new];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UITableViewCell *cell;
    
    if (_hasVerifImage) {
        if (indexPath.section == 0) {
            cell = [self createPhoneTextTableViewCellForTableView:tableView];
        } else if (indexPath.section == 1) {
            cell = [self createVerifyTextTableViewCellForTableView:tableView];
        } else {
            cell = [self createButtonTableViewCellForTableView:tableView];
        }
    } else {
        if (indexPath.section == 0) {
            cell = [self createPhoneTextTableViewCellForTableView:tableView];
        } else {
            cell = [self createButtonTableViewCellForTableView:tableView];
        }
    }
    return cell;
}

- (SharedTextTableViewCell *)createPhoneTextTableViewCellForTableView:(UITableView *)tableView {
    SharedTextTableViewCell *textCell = [[SharedTextTableViewCell alloc] init];
    textCell.tag = 11404;
    [textCell setPlaceholder:@"请输入手机号"];
    [textCell buildComponent: SharedTextFieldComponentClearOrVisibleButton|SharedTextFieldComponentAreaCode usePhoneFormat:YES];
    if (_hasVerifImage) {
        [textCell setText:_account];
        _phoneFill = YES;
        [textCell setFirstResponder:NO];
    }
    @weakObj(self);
    textCell.stateChangedHandler = ^(BOOL completion, NSString *text) {
        @strongObj(self);
        SharedButtonTableViewCell *buttonCell = [tableView viewWithTag:2021];
        if (self.hasVerifImage) {
            if (self.verifyFill && completion) {
                self.account = text;
                [buttonCell setMainButtonEnabled:YES];
            } else {
                [buttonCell setMainButtonEnabled:NO];
            }
        } else {
            if (completion) {
                self.account = text;

                [buttonCell setMainButtonEnabled:YES];
            } else {
                [buttonCell setMainButtonEnabled:NO];
            }
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
            @strongObj(self);
            self.verifyCode = text;
            self.verifyFill = YES;
            if (self.phoneFill) {
                [buttonCell setMainButtonEnabled:YES];
            } else {
                [buttonCell setMainButtonEnabled:NO];
            }
        } else {
            self.verifyFill = NO;
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
    [buttonCell buildComponent:SharedButtonComponentRightButton];
    buttonCell.tag = 2021;
    [buttonCell setMainButtonTitle:@"下一步"];
    [buttonCell setRightButtonTitle:@"账号密码登录"];
    @weakObj(self);
    buttonCell.buttonClickedHandler = ^(SharedButtonType type, UIButton * _Nonnull sender) {
        NSNumber *number;
        if (type == SharedButtonTypeRight) {
            number = @(LoginActionModeSwitch);
        } else  {
            if (selfweak.isBindingType) {
                number = @(LoginActionThirdBinding);
            } else {
                number = @(LoginActionLoginBySmsCode);
            }
        }
        [NSNotificationCenter.defaultCenter postNotificationName:nc_login_button_click object:number];
    };
    return buttonCell;
}

@end
