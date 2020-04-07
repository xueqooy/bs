//
//  TCVisiotorBindingViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/25.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCDeviceLoginAlertViewController.h"
#import "TCDeviceLoginInfoPerfectionViewController.h"
#import "FELoginViewController.h"

#import "TCDeviceLoginAlertView.h"
@interface TCDeviceLoginAlertViewController ()

@property (nonatomic, assign) BOOL needPerfectionAfterRegister;
@property (nonatomic, copy) void (^registerSuccessHandler)(void);
@property (nonatomic, copy) void (^perfectionSuccessHandler)(void);
@end

@implementation TCDeviceLoginAlertViewController

- (instancetype)init {
    self = [super init];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
 
}

+ (void)showWithPresentedViewController:(UIViewController *)viewController needPerfectInfoAfterRegister:(BOOL)need onRegisterSuccess:(void (^)(void))registerSuccess perfectionSuccess:(void (^)(void))perfectionSuccess{
    TCDeviceLoginAlertViewController *selfObject = TCDeviceLoginAlertViewController.new;
    selfObject.needPerfectionAfterRegister = need;
    selfObject.registerSuccessHandler = registerSuccess;
    if (need) {
        selfObject.perfectionSuccessHandler = perfectionSuccess;
    }
    [viewController presentViewController:selfObject animated:NO completion:^{
        [selfObject showsAlertView];
    }];
}

- (void)showsAlertView {
    @weakObj(self);
    TCDeviceLoginAlertView *alertView = TCDeviceLoginAlertView.new;
    alertView.context = self.view;
    @weakObj(alertView);
    alertView.deviceLoginHandler = ^{
        //注册并登录设备账号
        [UCManager registerDeviceUUIDOnSuccess:^{
            [alertViewweak hideWithAnimated:YES completion:^{
                if (selfweak.registerSuccessHandler) {
                    selfweak.registerSuccessHandler();
                }
                if (selfweak.needPerfectionAfterRegister) {
                    [selfweak perfectInfo];
                } else {
                    [selfweak dismissViewControllerAnimated:YES completion:^{
                    }];
                }
            }];
        } failure:^{
        }];
    };
    alertView.accountLoginHandler = ^{
        [NSNotificationCenter.defaultCenter postNotificationName:nc_window_root_switch object:WINDOW_ROOT_LOGIN];
    };
    
    alertViewweak.extraHandlerForClickingBackground = ^{
        [selfweak dismissViewControllerAnimated:NO completion:nil];
    };
    
    [alertView showWithAnimated:YES];
}


- (void)perfectInfo {
    @weakObj(self);
    [TCDeviceLoginInfoPerfectionViewController showWithPresentedViewController:self onPerfectionSuccess:^{
        [selfweak dismissViewControllerAnimated:NO completion:^{
            if (selfweak.perfectionSuccessHandler) selfweak.perfectionSuccessHandler();
        }];
    }];
}

@end
