//
//  TCMyAccountViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCMyAccountViewController.h"
#import "TCMyAccountControllerView.h"
#import "TCDeviceLoginAlertViewController.h"
#import "TCDeviceLoginInfoPerfectionViewController.h"
#import "TCMyOrderListViewController.h"

#import "TCMyAccountDataManager.h"
#import "TCCashierManager.h"

#import "PresentVCAnimation.h"
#import "DismissVCAnimation.h"
#import "SwipeUpInteractiveTransition.h"
@interface TCMyAccountViewController () <TCMyAccountControllerView, UIViewControllerTransitioningDelegate>
@property (nonatomic, weak) TCMyAccountDataManager *dataManager;
@property (nonatomic, weak) id rechargeObserver;

@property (nonatomic, strong) SwipeUpInteractiveTransition *interactiveTransition;

//设备账号注册成功后赋值，等待充值完成执行
@property (nonatomic, copy) void (^perfectionInfoHandler)(BOOL rechargeSuccess);
@end

@implementation TCMyAccountViewController

BindControllerView(TCMyAccountControllerView)

- (instancetype)init {
    self = [super init];
    self.dataManager = TCMyAccountDataManager.sharedInstance;
    if (mIsIOS13) {
        //iOS13自带全屏下滑Automatic
    } else {
        self.transitioningDelegate = self;
        self.interactiveTransition = [[SwipeUpInteractiveTransition alloc] initWithGestureViewController:self];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:_rechargeObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的账户";
  
    [self loadEmoneyProductList];
    [self updateBalance];
    [self addRechargeObserver];
    @weakObj(self);
    self.rechargeHandler = ^(TCEmoneyModel * _Nonnull emoney) {
        [selfweak rechargeForEmoney:emoney];
    };
    self.rechargeHistoryBlock = ^{
        TCMyOrderListViewController *historyViewController = [[TCMyOrderListViewController alloc] initWithOrderType:TCMyOrderTypeEmoney];
        historyViewController.title = @"充值记录";
        [selfweak.navigationController pushViewController:historyViewController animated:YES];
    };
    if (mIsIOS13) {
    } else {
        self.view.clipsToBounds = YES;
        CAShapeLayer *shapeLayer = CAShapeLayer.layer;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:STSize(7, 7)];
        shapeLayer.path = path.CGPath;
        self.view.layer.mask = shapeLayer;
    }
}

- (void)loadEmoneyProductList {
    @weakObj(self);
    [self.dataManager getEmoneyProductListOnSuccess:^{
        selfweak.emoneyList = selfweak.dataManager.emoneyProductList.items;
    } failure:^{
    }];
}


- (void)updateBalance {
    @weakObj(self);
    [self.dataManager getMyEmoneyBalanceOnSuccess:^{
        selfweak.emoneyBalance = selfweak.dataManager.myEmoneyBalance.balanceCount;
    } failure:^{
    }];
}

- (void)rechargeForEmoney:(TCEmoneyModel *)emoney {
    if (emoney == nil) {
        [QSToast toastWithMessage:@"请选择充值面额"];
        return ;
    }
    

    if (UCManager.sharedInstance.isVisitorPattern) {
        //等充值后再完善信息
        @weakObj(self);
        [TCDeviceLoginAlertViewController showWithPresentedViewController:self needPerfectInfoAfterRegister:NO onRegisterSuccess:^{

            [selfweak rechargeForEmoney:emoney];
            //充值完成后执行，无论成功或失败
            selfweak.perfectionInfoHandler = ^(BOOL rechargeSuccess){
                [TCDeviceLoginInfoPerfectionViewController showWithPresentedViewController:selfweak onPerfectionSuccess:^{
                    if (selfweak.backIfRechargeSuccess && rechargeSuccess) {
                        if (selfweak.navigationController) {
                            [QMUIHelper executeAnimationBlock:^{
                                [selfweak.navigationController popViewControllerAnimated:YES];
                            } completionBlock:^{
                                if (selfweak.rechargeSuccessAndBackHandler) selfweak.rechargeSuccessAndBackHandler();
                            }];
                        } else {
                            [selfweak dismissViewControllerAnimated:YES completion:^{
                                if (selfweak.rechargeSuccessAndBackHandler) selfweak.rechargeSuccessAndBackHandler();
                            }];
                        }
                    }
                }];
            };
        } perfectionSuccess:nil];
    } else {
        [TCCashierManager.sharedInstance createEmoneyOrderAndPurchByPaymentType:TCPaymentTypeIAP productId:emoney.productId.stringValue];
    }
}

- (void)addRechargeObserver {
    @weakObj(self);
    _rechargeObserver = [NSNotificationCenter.defaultCenter addObserverForName:nc_emoney_purchase_result object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        TCCashierPaymentNotice *notice = note.object;
        if (notice.code == TCCashierNoticeSuccess) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [selfweak updateBalance];
            });
            
            if (selfweak.backIfRechargeSuccess) {
                if (selfweak.perfectionInfoHandler == nil) {
                    //如果不需要完善信息（设备账号），直接dismiss，否则完善后再dismiss
                    if (selfweak.navigationController) {
                        [QMUIHelper executeAnimationBlock:^{
                            [selfweak.navigationController popViewControllerAnimated:YES];
                        } completionBlock:^{
                            if (selfweak.rechargeSuccessAndBackHandler) selfweak.rechargeSuccessAndBackHandler();
                        }];
                    } else {
                        [selfweak dismissViewControllerAnimated:YES completion:^{
                            if (selfweak.rechargeSuccessAndBackHandler) selfweak.rechargeSuccessAndBackHandler();
                        }];
                    }
                }
            }
            TCCashierManager.sharedInstance.currentEmoneyOrder = nil;
        }
        
        //设备账号注册后无论充值失败都需要完善信息
        if (selfweak.perfectionInfoHandler) {
            //
            selfweak.perfectionInfoHandler(notice.code == TCCashierNoticeSuccess);
            selfweak.perfectionInfoHandler = nil;
        };
    }];
}

#pragma mark - transition delegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if (mIsIOS13) {
        return nil;
    } else {
        return [[PresentVCAnimation alloc] init];
    }
    
}

/// 设置Dismiss返回的动画设置
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (mIsIOS13) {
        return nil;
    } else {
        return [[DismissVCAnimation alloc] init];
    }
}

/// 设置过场动画
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return (self.interactiveTransition.isInteracting ? self.interactiveTransition : nil);
}

@end
