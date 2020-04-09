//
//  TCTestDetailViewController.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/1.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCTestDetailViewController.h"
#import "TCCashierViewController.h"
#import "FEAnswerViewController.h"
#import "TCDeviceLoginAlertViewController.h"
#import "FEEvaluationReportViewController.h"

#import "TCTestDetailControllerView.h"
#import "TCTestHistoryRecordView.h"

#import "TCAppraisalHelper.h"
#import "FEDimensionDetailManager.h"
#import "TCCashierManager.h"
#import "TCHTTPService.h"
@interface TCTestDetailViewController () <TCTestDetailControllerView>

@property (nonatomic, copy) NSString *dimensionId;
@property (nonatomic, copy) NSString *childExamId;
@property (nonatomic, strong) FEDimensionDetailManager *dataManager;
@property (nonatomic, strong) TCAppraisalHelper *appraisalHelper;
@property (nonatomic, weak) id observer;
@end

@implementation TCTestDetailViewController {
    BOOL _needUpdate;
}
BindControllerView(TCTestDetailControllerView)

- (instancetype)initWithDimensionId:(NSString *)dimensionId childExamId:(NSString *)childExamId{
    self = [super init];
    self.childExamId = childExamId;
    self.dimensionId = dimensionId;
    self.dataManager = [[FEDimensionDetailManager alloc] initWithDimensionId:self.dimensionId childExamId:self.childExamId];
    self.appraisalHelper = [[TCAppraisalHelper alloc] initWithUniqueId:self.dimensionId type:FEAppraisalTypeTest];
    return self;
}

- (instancetype)initWithDimensionId:(NSString *)dimensionId {
    return  [self initWithDimensionId:dimensionId childExamId:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:_observer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测评详情";
    [self showLoadingPlaceHolderViewInView:self.view type:FESketonTypeTestAndCourse];
    self.loadingPlaceholderView.imageInsets = UIEdgeInsetsMake(-STWidth(80), 0, 0, 0);
    [self configViewAction];
    [self addObserverIfNeeded];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.qmui_previousViewController isKindOfClass:NSClassFromString(@"FEEvaluationReportViewController")]) {
        self.fd_interactivePopDisabled = YES;
    }
    [self loadDetailDataIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    _needUpdate = YES;
}

- (void)configViewAction {
    @weakObj(self);
   
    selfweak.mainButtonAction = self.mainButtonActionBlock;
    selfweak.retestButtonAction = ^{
        [selfweak startTest];
    };
    selfweak.historyButtonAction = self.historyButtonActionBlock;
    selfweak.appraisalButtonAction = ^{
        [selfweak.appraisalHelper showAppraisalViewIfNotAppraisedWithCompletion:^(BOOL shown) {
            selfweak.currentPopupContainer = selfweak.appraisalHelper.popupView;
        }];
    };
    selfweak.appraisalHelper.appraiseSuccessBlock = ^{
        selfweak.didAppraise = YES;
        [QSToast toastWithMessage:@"感谢你的评价"];
    };
}


- (void)addBarRightButtonIfOwned {
    if (self.dataManager.dimensionDetail.isOwn && self.dataManager.dimensionDetail.isOwn.boolValue == YES) {
        self.navigationItem.rightBarButtonItem = self.barRightButtonItem;
    }
}

- (void)addObserverIfNeeded {
    if (!self.dataManager.dimensionDetail.isOwn.boolValue && _childExamId == nil) {
        @weakObj(self);
        _observer = [NSNotificationCenter.defaultCenter addObserverForName:nc_product_exchange_result object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            TCCashierPaymentNotice *notice = note.object;
            if ([notice.productId isEqualToString:selfweak.dataManager.dimensionDetail.productId.stringValue]) {
                if (notice.code == TCCashierNoticeSuccess) {
                    selfweak.dataManager.dimensionDetail.isOwn = @(1);
                    [selfweak updateMainButton];
                    [selfweak hideHeaderPriceView];
                    [selfweak addBarRightButtonIfOwned];

//                    selfweak.toolBar.mainButtonTitle = @"开始测评";
//                    selfweak.toolBar.tools = @[TCProductToolTestHistoryButton];
                    if (selfweak.dataManager.dimensionDetail.priceYuan == 0) {
                        mLog(@"0元订单");
                        [selfweak startTest];
                    }
                }
            }
        }];
    }
}

- (void)loadData {
    [self loadDetailData];
    [self loadAppraiseData];
}

- (void)loadDetailDataIfNeeded {
    if (_needUpdate) {
        @weakObj(self);
        [_dataManager loadDimensionDetailDataWithSuccess:^{
            selfweak.detail = selfweak.dataManager.dimensionDetail;
            [selfweak loadHistoryDataIfNeeded];
            [selfweak updateMainButton];
            
        } failure:^(NSString *message){
            
        }];
    }
}

- (void)loadDetailData {
    @weakObj(self);
    [_dataManager loadDimensionDetailDataWithSuccess:^{
        selfweak.detail = selfweak.dataManager.dimensionDetail;

        [selfweak addBarRightButtonIfOwned];
        [selfweak loadHistoryDataIfNeeded];
        [selfweak updateView];
        [selfweak hideLoadingPlaceholderView];
    } failure:^(NSString *message){
        if (![NSString isEmptyString:message]) {
            if ([message containsString:@"商品未找到"]) {
                [selfweak.navigationController popViewControllerAnimated:YES];
                return ;
            }
        }
        [selfweak showEmptyViewForNoNetInView:selfweak.view refreshHandler:^{
            [selfweak loadData];
        }];
    }];
}



- (void)loadAppraiseData {
    @weakObj(self);
    [selfweak.appraisalHelper.appraisalManager loadAppraisalIndexNumberDataOnSuccess:^{
        [selfweak updateEvaluationViewWithIndex:selfweak.appraisalHelper.appraisalManager.recommentIndex ];
    } onFailure:^{
    }];
    
    if (!UCManager.sharedInstance.isVisitorPattern) {
        [self.appraisalHelper.appraisalManager loadAppraisalItemsDataOnSuccess:^{
            self.didAppraise = selfweak.appraisalHelper.appraisalManager.hasAppraised;
        } onFailure:^{
        }];
    }
}

- (void)loadHistoryDataIfNeeded {
    @weakObj(self);
    if ((selfweak.dataManager.dimensionDetail && selfweak.dataManager.dimensionDetail.isOwn.boolValue) || _childExamId ) {
        [self.dataManager getTestHistoryListDataWithSuccess:^{
            if (selfweak.dataManager.history) {
                selfweak.canAppraise =  selfweak.dataManager.history.currentCount > 0;
            }
        } failure:^{
        }];
    }
}

- (void (^)(void))mainButtonActionBlock {
    @weakObj(self);
    return ^{
        if (UCManager.sharedInstance.isVisitorPattern) {
            if (selfweak.dataManager.dimensionDetail.priceYuan == 0) {
                //免费的商品，直接弹出设备登录提示并完善信息
                [TCDeviceLoginAlertViewController showWithPresentedViewController:selfweak needPerfectInfoAfterRegister:YES onRegisterSuccess:^{
                } perfectionSuccess:^{
                    [selfweak purchaseTest];
                }];
            } else {
                //收费的商品，等到充值时弹出设备登录提示，如果设备注册登录成功，等待充值完成后，再完善信息
                [selfweak purchaseTest];
            }
        } else {
            if (![NSString isEmptyString:selfweak.childExamId]) {
                [selfweak goTest];
                return;
            } else {
                if (selfweak.dataManager.dimensionDetail.isOwn.boolValue) {
                    [selfweak goTest];
                } else {
                    [selfweak purchaseTest];
                }
            }
        }
    };
}

- (void(^)(void))historyButtonActionBlock {
    @weakObj(self);
    return ^{
        [selfweak showHistoryListView];
    };
}

- (void)showHistoryListView {
    TCTestHistoryRecordView *historyView = TCTestHistoryRecordView.new;
    historyView.historyRecord = self.dataManager.history.data;
    @weakObj(self);
    historyView.onTap = ^(NSString *childDimensionId){
        BOOL isCareerReportType = ([[UCManager sharedInstance].careerChildExamId isEqualToString: selfweak.childExamId]);
        FEEvaluationReportViewController *vc = [[FEEvaluationReportViewController alloc] initWithDimensionId:selfweak.dimensionId childDimensionId:childDimensionId];

        vc.isCareerReport = isCareerReportType;

        [selfweak.navigationController pushViewController:vc animated:YES];
        [selfweak hideHistoryListView];
    };
    historyView.onStartTestButtonClick = ^{
        [selfweak goTest];
        [selfweak hideHistoryListView];
    };
    
    TCPopupContainerView *popupContainer = TCPopupContainerView.new;
    popupContainer.displayedView = historyView;
    popupContainer.title = @"历史测评";
    [popupContainer showToVisibleControllerViewWithCompletion:nil];
    selfweak.currentPopupContainer = popupContainer;
}

- (void)hideHistoryListView {
    [self.currentPopupContainer hideWithCompletion:nil];
}

- (void)startTest {
    @weakObj(self);
    [self.dataManager startDimensionWithSuccess:^{
        selfweak.dataManager.dimensionDetail.status = @0;
        [selfweak updateMainButton];
      
        FEAnswerViewController *vc = [[FEAnswerViewController alloc] init];
        vc.dimensionModel = selfweak.dataManager.dimensionDetail;
        [selfweak.navigationController pushViewController:vc animated:YES];
    } failure:^{}];
}

//继续测评或开始、查看报告
- (void)goTest {
    EvaluationDetailDimensionsModel *detail = self.dataManager.dimensionDetail;
    detail.childExamID = self.childExamId;
    if(!self.dataManager.dimensionDetail){
        return;
    }

    if(detail.status != nil){
        if([detail.status integerValue] == 1 || ([detail.status isEqualToNumber:@0] && [detail.reportStatus isEqualToNumber:@1])){
            BOOL isCareerReportType = ([[UCManager sharedInstance].careerChildExamId isEqualToString: self.childExamId]);
            FEEvaluationReportViewController *vc = [[FEEvaluationReportViewController alloc] initWithDimensionId:self.dimensionId childDimensionId:self.dataManager.dimensionDetail.childDimensionID];
            if ([detail.reportStatus isEqualToNumber:@1]) {
                vc.isCreating = YES; //生成中
            }
            vc.isCareerReport = isCareerReportType;

            [self.navigationController pushViewController:vc animated:YES];
        }else{

            if (detail.childDimensionID == nil) {
                [QSToast toast:self.view message:@"抱歉！数据异常"];
                return;
            }
            //继续测评
            FEAnswerViewController *vc = [[FEAnswerViewController alloc] init];
            vc.dimensionModel = detail;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [self startTest];
    }

}

- (void)purchaseTest {
    if(self.dataManager.dimensionDetail.priceYuan == 0) {
        [TCCashierManager.sharedInstance createProductOrderAndExchangeByProductId:self.dataManager.dimensionDetail.productId.stringValue price:self.dataManager.dimensionDetail.priceYuan productType:TCProductTypeTest];
    } else {
        TCProductItemBaseModel *productModel = TCProductItemBaseModel.new;
        productModel.price = self.dataManager.dimensionDetail.price;
        productModel.productId = self.dataManager.dimensionDetail.productId;
        productModel.productType = TCProductTypeTest;
        productModel.name = self.dataManager.dimensionDetail.dimensionName;
        [TCCashierViewController handleExchangeWithProductModel:productModel presentedViewController:self delegate:nil];
    }
    
}
@end
