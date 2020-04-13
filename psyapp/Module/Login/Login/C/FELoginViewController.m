//
//  FELoginViewController.m
//  smartapp
//
//  Created by lafang on 2018/8/21.
//  Copyright © 2018年 jeyie0. All rights reserved.
//
#import "FELoginViewController.h"
#import "AppDelegate.h"
#import "UCManager.h"
#import "QSToast.h"
#import "UserService.h"
#import "HttpErrorManager.h"
#import "ConstantConfig.h"

#import "StringUtils.h"
#import "HttpConfig.h"
#import "LoginCommon.h"

#import "LoginPasswordView.h"
#import "LoginForgetView.h"
#import "LoginVerifyView.h"
#import "LoginSMSView.h"
#import "LoginInfoPerfectionView.h"
#import "QSWebViewBaseController.h"
#import "LoginHttpManager.h"
#import "UIImage+Utils.h"
#import "FECommonAlertView.h"
#import "FETextInputAlertView.h"


#import "TCLoginViewStacker.h"

@interface FELoginViewController ()
@property(nonatomic,strong) QMUIButton *customButton;
//密码登录界面
@property(nonatomic,strong) LoginPasswordView *LoginPasswordView;

//注册界面
@property (nonatomic, strong) LoginPasswordView *registerView;

//信息完善界面
@property (nonatomic, strong) LoginInfoPerfectionView *loginInfoPerfectionView;

@property (nonatomic, strong) TCLoginViewStacker *viewStacker;
@property (nonatomic, strong) LoginHttpManager *httpManager;


@property (nonatomic, weak) id observer ;

@end

@implementation FELoginViewController

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = UIColor.fe_contentBackgroundColor;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [TCUserDataRestter reset1];
    self.navigationController.navigationBar.translucent = NO;
    _httpManager = [[LoginHttpManager alloc] init];;

    [self initNavigationBarLeftButton];
    
    self.viewStacker = [[TCLoginViewStacker alloc] initWithViewController:self];
    @weakObj(self);
    self.viewStacker.viewCountChangeHandler  = ^(NSInteger viewCount) {
        if (viewCount <= 1) {
            [selfweak.customButton setImage:nil forState:UIControlStateNormal];
            [selfweak.customButton setTitle:@"返回" forState:UIControlStateNormal];
            selfweak.customButton.titleLabel.font = mFontBold(17);
            [selfweak.customButton setTitleColor:UIColor.fe_titleTextColorLighten forState:UIControlStateNormal];
            selfweak.customButton.tag = 10001;
        } else {
            [selfweak.customButton setImage:[UIImage imageNamed:@"share_back"] forState:UIControlStateNormal];
            [selfweak.customButton setTitle:@"" forState:UIControlStateNormal];
            selfweak.customButton.tag = 10000;
        }
    } ;
    
    [UIView performWithoutAnimation:^{
        [self.viewStacker pushView:self.LoginPasswordView onCompletion:nil];
    }];
    
    [self initLoginActionObserver];//监听按钮点击的通知
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationBarShadowHidden = YES;
    self.navigationBarColor = UIColor.whiteColor;

}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view endEditing:YES];
}

- (void)initNavigationBarLeftButton {
    _customButton = [QMUIButton buttonWithType:UIButtonTypeCustom];
    _customButton.frame =CGRectMake(0,0, 44, 44);
    _customButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 16);
    [_customButton setImage:UIImage.fe_navigationBarBackButtonImage forState:UIControlStateNormal];
    [_customButton addTarget:self action:@selector(barLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButLeft = [[UIBarButtonItem alloc] initWithCustomView:_customButton];
    self.navigationItem.leftBarButtonItem = barButLeft;
}

- (void)initLoginActionObserver {
    __weak typeof (self)weakSelf = self;
    _observer = [NSNotificationCenter.defaultCenter addObserverForName:nc_login_button_click object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        NSNumber *number = note.object;
        LoginAction type = [number integerValue];
        [weakSelf actionForType:type];
    }];
}



- (void)barLeftButtonAction:(UIButton *)sender {
    if (sender.tag == 10001) {
        //这里返回有2种情况
        //非正式账号点击登录后返回（没有注册新账号）
        //注册后位完善信息，返回
        //对于第二种情况，需要清除正式账号的token，否者会误人正式账号已登录
        if (UCManager.sharedInstance.didFormalAccountLogin) {
            [UCManager.sharedInstance clearFormalAccount];
        }
        [self dissmissViewController];
    } else {
        [self popView];
    }
}
- (void)dissmissViewController {
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (void)popView {
    @weakObj(self);
    [self.viewStacker popViewOnCompletion:^(UIView * _Nonnull view) {
        @strongObj(self);
        if (view == self->_loginInfoPerfectionView) {
            self.title = @"";
            [[UCManager sharedInstance] clearFormalAccount];
        }
    }];
}

#pragma mark -- lazy


- (LoginPasswordView *)LoginPasswordView {
    if (!_LoginPasswordView) {
        _LoginPasswordView = [[LoginPasswordView alloc] init];
        // self.LoginPasswordView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_LoginPasswordView];
        [_LoginPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.leading.equalTo(self.view);
            make.width.equalTo(self.view);
        }];
        _LoginPasswordView.hidden = YES;
    }
    return _LoginPasswordView;
}

- (LoginPasswordView *)registerView {
    if (!_registerView) {
        _registerView = [[LoginPasswordView alloc] init];
        [_registerView setRegisterType:YES];
        // self.LoginPasswordView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_registerView];
        [_registerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.leading.equalTo(self.view);
            make.width.equalTo(self.view);
        }];
        _registerView.hidden = YES;
    }
    return _registerView;
}

- (LoginInfoPerfectionView *)loginInfoPerfectionView {
    if (!_loginInfoPerfectionView) {
        _loginInfoPerfectionView = [LoginInfoPerfectionView new];
        [self.view addSubview:_loginInfoPerfectionView];
        [_loginInfoPerfectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.leading.offset(0);
            make.size.equalTo(self.view);
        }];
        _loginInfoPerfectionView.hidden = YES;
    }
    
    return _loginInfoPerfectionView;
}

- (void)actionForType:(LoginAction)type{//jump:btn
    [self.view endEditing:YES];
    if (type == LoginActionModeSwitch) { //切换登录方式
        [self startLoginModeSwitchProcess];
    } else if (type == LoginActionLoginByPassword) {//账号密码登录
        [self startLoginProcessByPassword];
    } else  if (type == LoginActionRegistrationCompletion) {
        [self startCompleteRegistrationProcess];
    } else if (type == LoginActionPerfectUserinfo) {//完善信息
        [self startInfoPerfectionSubmitProcess];
    } else if (type == LoginActionServiceAgreement) {
        QSWebViewBaseController *vc = [[QSWebViewBaseController alloc] init];
        vc.filePathURL = [NSBundle.mainBundle URLForResource:@"service-agreement" withExtension:@"html"];
        vc.shouldDisableLongPressAction = YES;
        vc.shouldDisableZoom = YES;
        vc.navigationItem.title = @"服务协议";
        [self.navigationController pushViewController:vc animated:YES];
       
        self.navigationController.navigationBar.hidden = NO;
    } else if (type == LoginActionSecretAgreement) {
        QSWebViewBaseController *vc = [[QSWebViewBaseController alloc] init];
        vc.filePathURL = [NSBundle.mainBundle URLForResource:@"secret-policy" withExtension:@"html"];
        vc.shouldDisableLongPressAction = YES;
        vc.shouldDisableZoom = YES;
        vc.navigationItem.title = @"隐私政策";
        [self.navigationController pushViewController:vc animated:YES];
              
        self.navigationController.navigationBar.hidden = NO;
    } else if(type == LoginActionCaptchaImageChange) {
        [self startCaptchaImageChangeProcess];
    }
}

#pragma mark 密码登录流程
- (void)startLoginProcessByPassword {
    @weakObj(self);
    
    [QSLoadingView show];

    
    [selfweak.httpManager loginWithAccount:selfweak.LoginPasswordView.account password:selfweak.LoginPasswordView.password verifyCode:@"" onSuccess:^{
        [QSLoadingView dismiss];
        [selfweak swithToMainForLoginByVisitor:NO];
    } failure:^(LoginErrorType type){
        [QSLoadingView dismiss];
        if (type == LoginErrorTypeAccountDoesNotExist) {
            [selfweak showAlertForNonexistentAccount:selfweak.LoginPasswordView.account];
        } else if (type == LoginErrorTypeInfoDoseNotPerfect) {
            [QSToast toastWithMessage:@"需要先完善信息"];
            [selfweak gotoPerfectUserInfo];
        }
    }];
}



- (void)showAlerForCaptchaImage:(UIImage *)image onConfirm:(void (^)(NSString *content))onConfrim{
    FETextInputAlertView *exsitAlertView= [[UIApplication sharedApplication].keyWindow viewWithTag:3232];
    if (exsitAlertView) {
        [exsitAlertView updateCaptcha:image];
        return;
    }
    
    FETextInputAlertView *alertView = [[FETextInputAlertView alloc] initWithTitle:@"图形验证码" placeholder:@"请输入图形验证码" cancleText:@"取消" confirmText:@"验证" captcha:image];
    alertView.tag = 3232;
    [alertView show];
    
    alertView.result = ^(BOOL isConfirm, NSString *content) {
        if (isConfirm) {
            if (onConfrim) {
                onConfrim(content);
            }
        }
    };
    alertView.touch = ^{
        //切换图片验证码
        [self actionForType:LoginActionCaptchaImageChange];
    };
}


#pragma mark 账号密码登录和重置密码时，出现不存在的账号时调用，提示去注册账号
- (void)showAlertForNonexistentAccount:(NSString *)account {
    FECommonAlertView *alertView = [[FECommonAlertView alloc] initWithTitle:@"该账号并未注册，是否立即注册?" leftText:@"取消" rightText:@"立即注册" icon:nil];
    @weakObj(self);
    alertView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            if (selfweak.viewStacker.currentView == selfweak.LoginPasswordView) {
                //切换到注册
                [selfweak actionForType:LoginActionModeSwitch];
            }
        }
    };
    [alertView showCustomAlertView];
}

#pragma mark 完成注册流程，不包括信息完善
- (void)startCompleteRegistrationProcess {
    if ([self checkPassword:_registerView.password]) {
        //第三方绑定未注册账号和普通注册同接口
        @weakObj(self);
        [_httpManager registerWithAccount:self.registerView.account password:self.registerView.password onSuccess:^{
            //登录账号
            
            [selfweak gotoPerfectUserInfo];
        } failure:^(LoginErrorType type) {

        }];
    }
}

#pragma mark 去完善信息

- (void)gotoPerfectUserInfo {
    @weakObj(self);
    [self.viewStacker pushView:self.loginInfoPerfectionView onCompletion:^(UIView * _Nonnull view) {
        selfweak.title = @"完善个人信息";
        [selfweak.loginInfoPerfectionView reloadData];
    }];
}

#pragma mark 完善信息提交流程
- (void)startInfoPerfectionSubmitProcess {
    PIModel *userInfo = _loginInfoPerfectionView.userInfo;
    NSString *nickName = userInfo.nick;
    NSString *childName = userInfo.name;
    
    NSString *regex = @"^[A-Za-z\u4E00-\u9FA5][A-Za-z0-9\u4E00-\u9FA5]{1,11}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if([NSString isEmptyString:nickName]){
        [QSToast toastWithMessage:@"昵称不能为空"];
        return;
    }else if(nickName.length>12 || nickName.length<2){
        [QSToast toastWithMessage:@"昵称要求2-12位数字、英文、或者中文,不能以数字开头" duration:2];
        return;
    }else if(![pred evaluateWithObject:nickName]){
        [QSToast toastWithMessage:@"昵称要求2-12位数字、英文、或者中文,不能以数字开头" duration:2];
        return;
    }
    
    NSString *regex1 = @"^[A-Za-z\u4E00-\u9FA5]{2,12}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];

    if([NSString isEmptyString:childName]){
        [QSToast toastWithMessage:@"姓名不能为空"];
        return;
    }else if(childName.length>12 || childName.length<2){
        [QSToast toastWithMessage:@"姓名要求2-12位英文或者中文" duration:2];
        return;
    }else if(![pred1 evaluateWithObject:childName]){
        [QSToast toastWithMessage:@"姓名要求2-12位英文或者中文" duration:2];
        return;
      }
    
    NSParameterAssert(userInfo);

    if ([self nickNameCheck:userInfo.nick]) {
        [_httpManager perfectUserInfoByNickname:userInfo.nick childName:userInfo.name gradeNum:[NSString stringWithFormat:@"%@", userInfo.grade] gender:userInfo.gender OnSuccess:^{
            //内部调用获取用户和孩子信息自动登录
        } failure:^(LoginErrorType type) {
        }];
    }
}



#pragma mark 更换图形验证码
- (void)startCaptchaImageChangeProcess {
    @weakObj(self);
    if (_viewStacker.currentView == _LoginPasswordView) {
        [self.httpManager getCaptchaImageBySessionId:_httpManager.currentSessionId onCompletion:^(UIImage * _Nonnull image) {
            [selfweak.LoginPasswordView showVerificationCodeImage:image];
        }];
    }
}


#pragma mark 登录切换
- (void)startLoginModeSwitchProcess {
    if (self.viewStacker.currentView == self.registerView) {
        [self.viewStacker replaceCurrentViewWithView:self.LoginPasswordView];
        [self.LoginPasswordView setAccount:self.registerView.account];
    } else {
        [self.viewStacker replaceCurrentViewWithView:self.registerView];
        [self.registerView setAccount:self.LoginPasswordView.account];
    }
}

- (void)swithToMainForLoginByVisitor:(BOOL)isVisitor{
//    UCManager.sharedInstance.isVisitorPattern = isVisitor;
    if (isVisitor) {
        [UCManager.sharedInstance clearFormalAccount];
    }
    [NSNotificationCenter.defaultCenter postNotificationName:nc_window_root_switch object:WINDOW_ROOT_MAIN];
}

//检查手机格式
-(BOOL)checkMobileNum:(NSString *)mobileNum{
    
    if(!mobileNum || [mobileNum isEqualToString:@""]){
        [QSToast toast:self.view message:@"手机号不能为空"];
        return NO;
    }
    
    if(mobileNum.length!=11 || ![[mobileNum substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]){
        [QSToast toast:self.view message:@"手机号格式不正确"];
        return NO;
    }
    
    return YES;
}

//检查密码
-(BOOL)checkPassword:(NSString *)firstPass{
    if([firstPass isEqualToString:@""]){
        [QSToast toast:self.view message:@"密码不能为空"];
        return NO;
    }
    
    if(firstPass.length<6 || firstPass.length>24){
        [QSToast toast:self.view message:@"密码长度为6-24个字符，可以是数字、字母等任意字符" offset:CGPointMake(0, 100) duration:1.5];
        return NO;
    }
    
    return YES;
}

//昵称校验
-(BOOL)nickNameCheck:(NSString *)nickname{
    //中文，英文，数字正则
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if([nickname isEqualToString:@""]){
        [QSToast toast:self.view message:@"昵称不能为空"];
        return NO;
    }
    if(nickname.length>8 || nickname.length<2){
        [QSToast toast:self.view message:@"昵称长度为2-8位字符"];
        return NO;
    }
    if(![pred evaluateWithObject:nickname]){
        [QSToast toast:self.view message:@"昵称只能由数字/英文/中文组成"];
        return NO;
    }
    return YES;
}


@end
