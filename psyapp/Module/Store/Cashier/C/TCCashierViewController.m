//
//  TCCashierViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/14.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCCashierViewController.h"
#import "TCCashierControllerView.h"
#import "TCMyAccountViewController.h"

#import "TCOrderModel.h"
#import "TCCashierManager.h"
#import "TCIAPManager.h"
#import "TCMyAccountDataManager.h"
@interface TCCashierViewController () <TCCashierControllerView>

@property (nonatomic, weak) TCCashierManager *cashier;

@property (nonatomic, strong) TCProductItemBaseModel *productModel;

@property (nonatomic, weak) id productExchangeObserver;
//@property (nonatomic, weak) id emoneyPurchaseObserver;


@property (nonatomic, assign) BOOL errorOccured; //记录数据异常发生（传进来的商品数据问题或余额问题）
@end

@implementation TCCashierViewController
BindControllerView(TCCashierControllerView)
- (instancetype)init {
    self = [super init];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.cashier = TCCashierManager.sharedInstance;
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:_productExchangeObserver];
//    [NSNotificationCenter.defaultCenter removeObserver:_emoneyPurchaseObserver];
}

+ (void)handleExchangeWithProductModel:(TCProductItemBaseModel *)productModel presentedViewController:(UIViewController *)presentedViewController delegate:(id<TCCashierViewControllerDelegate> _Nullable)delegate{
    TCCashierViewController *selfObject = TCCashierViewController.new;
    selfObject.productModel = productModel;
    selfObject.delegate = delegate;
    [presentedViewController presentViewController:selfObject animated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    @weakObj(self);
    self.onBackgroundClick = ^{
        [selfweak makeDismissed];
    };
    self.onButtonClick = ^{
        [selfweak handleButtonClicked];
    };
    self.productPrice = self.productModel.priceYuan;
    self.productName = self.productModel.name;
    
    [self initContainerPosition];
    [self initObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateEmoneyBalanceWithCompletion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self doShowAnimation];
}

- (void)updateEmoneyBalanceWithCompletion:(void(^)(void))completion {
    [TCMyAccountDataManager.sharedInstance getMyEmoneyBalanceOnSuccess:^{
        self.emoneyBalance = TCMyAccountDataManager.sharedInstance.myEmoneyBalance.balanceCount;
        if (completion) completion();
    } failure:^{
    }];
}

- (void)makeDismissed {
    @weakObj(self);
    [self doHideAnimationWithCompletion:^(BOOL finish) {
        [selfweak dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)initObserver {
    @weakObj(self);
    _productExchangeObserver = [NSNotificationCenter.defaultCenter addObserverForName:nc_product_exchange_result object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [selfweak handleProductExchangeResultWithNotice:note.object];
    }];
    
//    _emoneyPurchaseObserver = [NSNotificationCenter.defaultCenter addObserverForName:nc_emoney_purchase_result object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
//        [selfweak handleEmoneyPurchaseResultWithNotice:note.object];
//    }];
}


- (void)handleButtonClicked {
    if (self.emoneyBalance < self.productModel.priceYuan) {
        //代币余额不足
        @weakObj(self);
        TCMyAccountViewController *accountViewController = TCMyAccountViewController.new;
        accountViewController.backIfRechargeSuccess = YES;
        accountViewController.rechargeSuccessAndBackHandler = ^{
            [selfweak updateEmoneyBalanceWithCompletion:^{
                if (selfweak.emoneyBalance < selfweak.productModel.priceYuan) {
                    //充值成功但余额仍然不足
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [QSToast toastWithMessage:@"余额不足，无法购买商品"];
                    });
                } else {
                    //充值成功，余额充足
                    [selfweak.cashier createProductOrderAndExchangeByProductId:selfweak.productModel.productId.stringValue price:selfweak.productModel.priceYuan productType:selfweak.productModel.productType];
                }
            }];
        };
        [self presentViewController:accountViewController animated:YES completion:^{
        }];
    } else {
        //代币余额足够兑换
        [self.cashier createProductOrderAndExchangeByProductId:self.productModel.productId.stringValue price:self.productModel.priceYuan productType:self.productModel.productType];
        
    }
}


- (void)handleProductExchangeResultWithNotice:(TCCashierPaymentNotice *)notice {
    if ([notice.productId isEqualToString:self.productModel.productId.stringValue]) {
        if (notice.code == TCCashierNoticeSuccess) {
            [QSLoadingView show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self makeDismissed];
                [QSLoadingView dismiss];
                [QSToast toastWithMessage:@"购买成功"];
            });
        } else if (notice.code == TCCashierNoticeBalanceNotEnough) {
            //数据异常，传进来的数据可能有或者余额错误
            if (self.errorOccured == NO) {
                //再次获取余额
                [self updateEmoneyBalanceWithCompletion:nil];
                self.productPrice = self.productModel.priceYuan;
                self.errorOccured = YES;
            } else {
                //重复发生错误，返回
                [self makeDismissed];
                if (_delegate) {
                    [_delegate cashierDataErrorOccuredWithProductModel:self.productModel];
                }
            }
        }
    }
}

//- (void)handleEmoneyPurchaseResultWithNotice:(TCCashierPaymentNotice *)notice {
//    if (notice.code == TCCashierNoticeSuccess) {
//        [self updateEmoneyBalanceWithCompletion:^{
//            if (self.emoneyBalance < self.productModel.priceYuan) {
//                //充值成功但余额仍然不足
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [QSToast toastWithMessage:@"余额不足，无法购买商品"];
//                });
//            } else {
//                //充值成功，余额充足
//                [self.cashier createProductOrderAndExchangeByProductId:self.productModel.productId.stringValue price:self.productModel.priceYuan productType:self.productModel.productType];
//            }
//        }];
//    }
//}
@end
