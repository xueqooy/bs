//
//  FireExamViewController.m
//  smartapp
//
//  Created by lafang on 2018/9/19.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEAnswerViewController.h"
#import "FEAnswerCollectionCell.h"
#import "EvaluateService.h"
#import "FECommonAlertView.h"
#import "FEPicturedAlertView.h"

#import "FEEvaluationReportViewController.h"

#import "TCCommonButton.h"
#import "FEExamProgressBar.h"
#import "FESlidingHintView.h"
#import "FEAnswerManager.h"
#import "FEQuestionModel.h"
#import "TCNetworkReachabilityHelper.h"

#import <QMUIKit.h>
#define STOP_TIMES 60



@interface FEAnswerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>


@property (nonatomic,strong) FEExamProgressBar *progressBar;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *bottomBarView;
@property (nonatomic,strong) TCCommonButton *submitButton;


@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger currPageIndex;
@property (nonatomic, weak) FEAnswerCollectionCell *currentPageCell;


@property (nonatomic,assign) NSInteger bottomBarHeight;
@property (nonatomic,assign) NSInteger bottomBtnOffset;

@property (nonatomic,assign) NSInteger stopCurrentTime;//用于计算某一题目停留时间
@property (nonatomic,strong) NSMutableArray<NSNumber *> *recordTimeArray;


@property (nonatomic,assign) BOOL isCompleteAndToReport;
@property (nonatomic,assign) BOOL lastDidseleted;

@property (nonatomic,assign) NSInteger onceAnswerCount;//连续答题次数

@property (nonatomic, strong) FEAnswerManager *answerManager;
@property (nonatomic, weak) AFNetworkReachabilityManager *networkReachabilityManager;
@property (nonatomic, weak) id  networkingStatusObserver;

@end

@implementation FEAnswerViewController

- (void)initDataManager {
    NSString *childDimensionId = self.dimensionModel.childDimensionID;
    BOOL isMerge = [self.dimensionModel.isMergeAnswer boolValue];
    _answerManager = [[FEAnswerManager alloc] initWithChildDimensionID:childDimensionId isMerge:isMerge ];
}

- (void)initNetworkReachabilityManager {
    @weakObj(self);
    _networkingStatusObserver = [NSNotificationCenter.defaultCenter addObserverForName:nc_networking_status_change object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        if (note.object) {
            if ([note.object isKindOfClass:NSNumber.class]) {
                @strongObj(self);
                AFNetworkReachabilityStatus status = [note.object integerValue];
                switch (status) {
                    case AFNetworkReachabilityStatusUnknown: // 未知网络
                        break;
        
                    case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                        [QSToast toastWithMessage:@"网络连接异常"];
                        [self.answerManager saveDataWhenNetworkNotReachable];
                        break;
        
                    case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                        [self.answerManager clearLocalDataWhenNetworkReachable];
                        break;
        
                    case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                        [self.answerManager clearLocalDataWhenNetworkReachable];
                        break;
                }
            }
        }
    }];
//    _networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
//    //TODO:本地缓存
//    @weakObj(self);
//    [_networkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        @strongObj(self);
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown: // 未知网络
//                break;
//
//            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
//                [QSToast toastWithMessage:@"网络连接异常"];
//                [self.answerManager saveDataWhenNetworkNotReachable];
//                break;
//
//            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
//                [self.answerManager clearLocalDataWhenNetworkReachable];
//                break;
//
//            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
//                [self.answerManager clearLocalDataWhenNetworkReachable];
//                break;
//        }
//    }];
//    [_networkReachabilityManager startMonitoring];
}

- (void)dealloc {
//    [_networkReachabilityManager stopMonitoring];
    [NSNotificationCenter.defaultCenter removeObserver:_networkingStatusObserver];
}

- (void)viewDidLoad {
    self.fd_interactivePopDisabled = YES;
    [self initDataManager];
    
    //需要在禁用手势后调用super,否者仍然会添加手势
    [super viewDidLoad];

    @weakObj(self);
    self.fe_navigaitionViewController.barBackButtonAction = ^{
        [selfweak barBackButtonAction];
    };

    
    self.title = @"测评详情";
    if(mIsiPhoneX){
        self.bottomBarHeight = 84 + [SizeTool height:60];
        self.bottomBtnOffset = 34;
    }else{
        self.bottomBarHeight = 50 + [SizeTool height:60];
        self.bottomBtnOffset = 0;
    }
    self.recordTimeArray = @[].mutableCopy;
    
    [self setupSubViews];
    
    [self loadData];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationBarShadowHidden = YES;
    _onceAnswerCount = 0;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self popGestureSwitch:NO];
}

- (void)barBackButtonAction {
    
    [self stopTimes];
    @weakObj(self);
    FECommonAlertView *exitAlert = [[FECommonAlertView alloc] initWithTitle:@"答题还没有全部完成，\r\n确定要退出吗？" leftText:@"退出" rightText:@"继续答题" icon:nil];
    exitAlert.resultIndex = ^(NSInteger index) {
        @strongObj(self);
        if(index == 1){
            //退出
            [self saveDimensionQuestions];
        }else{
            [self initTimes];
        }
    };
    exitAlert.extraHandlerForClickingBackground = ^{
        @strongObj(self);
        [self initTimes];
    };
    [exitAlert showCustomAlertView];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.fe_navigaitionViewController.barBackButtonAction = nil;
 
    [super viewWillDisappear: animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

//    [self popGestureSwitch:YES];
    //去报告，不调保存
    if(!self.isCompleteAndToReport){
        [self saveDimensionQuestions];
    }
    if(self.timer){
        [self stopTimes];
    }
    
}


- (void) initTimes {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    self.stopCurrentTime = self.answerManager.costedTime;
}

- (void)stopTimes{

    [self.timer invalidate];
    self.timer = nil;
    self.stopCurrentTime = self.answerManager.costedTime;
    [self.recordTimeArray removeAllObjects];
}

- (void)timerAction {
    self.answerManager.costedTime ++;
    
    [self.progressBar setTimeWithString:[self getMMSSFromSS:[NSString stringWithFormat:@"%li", (long)self.answerManager.costedTime]]];
    if(self.answerManager.costedTime - self.stopCurrentTime >= STOP_TIMES){
        
        mLog(@"弹出休息提示");

       // 当前题目停留时间超过30s,弹窗提示
        [self stopTimes];
        @weakObj(self);
        FEPicturedAlertView *exitAlert = [[FEPicturedAlertView alloc] initWithTitle:@"如果你想休息一下在答题，你可以放心地退出，我们会保存你测评的进度" leftText:@"退出" rightText:@"继续答题" picture:[UIImage imageNamed:@"answer_rest_picture"]];
        exitAlert.resultIndex = ^(NSInteger index) {
            @strongObj(self);

            if(index == 1){
                //退出
                [self saveDimensionQuestions];
            }else{
                [self initTimes];
            }
        };
        exitAlert.extraHandlerForClickingBackground = ^{
            @strongObj(self);

            [self initTimes];
        };
        [exitAlert showWithAnimated:YES];
    }

}



- (void) setupSubViews {
    @weakObj(self);
    _progressBar = [FEExamProgressBar new];
    _progressBar.definitionButtonClickHandler = ^{
        if (mIsProduct) {
            [selfweak stopTimes];
            FECommonAlertView *alertView = [[FECommonAlertView alloc] initWithTitle:selfweak.dimensionModel.instruction leftText:nil rightText:@"确定" icon:nil];
            [alertView setAttributeTextWithNormalText:selfweak.dimensionModel.instruction];
            alertView.resultIndex = ^(NSInteger index) {
                [selfweak initTimes];
            };
            alertView.extraHandlerForClickingBackground = ^{
                [selfweak initTimes];
            };
            [alertView showCustomAlertView];
        } else {
            [selfweak testSaveAllAnswer];
        }
        
        
    };
    [self.view addSubview:_progressBar];
    [_progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.height.mas_equalTo([SizeTool height:60]);
        make.top.equalTo(self.view).offset(0.5);
    }];
    
    self.view.backgroundColor = UIColor.fe_contentBackgroundColor;
    

    self.bottomBarView = [[UIView alloc] init];
    self.bottomBarView.userInteractionEnabled = NO;
    [self.view addSubview:self.bottomBarView];
    [self.bottomBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(_bottomBarHeight);
    }];
    
    
    self.submitButton = [[TCCommonButton alloc] init];
    self.submitButton.layer.cornerRadius = STWidth(4);
    [self.submitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.submitButton.backgroundColor = UIColor.fe_mainColor;
    [self.submitButton addTarget:self action:@selector(submitAnswersAction) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.bottomBarView addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomBarView).offset(-_bottomBtnOffset - [SizeTool height:28]);
        make.right.equalTo(self.bottomBarView).offset([SizeTool width:-15]);
        make.width.mas_equalTo([SizeTool width:345]);
        make.height.mas_equalTo([SizeTool height:48]);
    }];
    self.submitButton.hidden = YES;
    
    //创建一个流式布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = UIColor.fe_contentBackgroundColor;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressBar.mas_bottom).offset([SizeTool height:10]);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-mBottomSafeHeight);
    }];
    
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[FEAnswerCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([FEAnswerCollectionCell class])];
    [self.view bringSubviewToFront:_bottomBarView];
        
}

-(void)activeSubmitButton{
    if(_lastDidseleted){
        self.bottomBarView.userInteractionEnabled = YES;
        self.submitButton.hidden = NO;
    }
}

-(void)loadData{
    @weakObj(self);
    [_answerManager loadQuestionsWithSuccess:^(NSInteger answerIndex) {
        @strongObj(self);
        NSInteger pageIndex = answerIndex;
        //如果最后一题已经回答，会滚动到最后一页
        if (answerIndex >= self.answerManager.questions.count) {
            pageIndex = answerIndex - 1;
            self.lastDidseleted = YES;
        }
        self.currPageIndex = pageIndex;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageIndex inSection:0];
        GCD_ASYNC_MAIN(^{
            [self.collectionView reloadData];

            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            
            [self updatePage];
            [self initTimes];
            
            if(self.dimensionModel.instruction && ![self.dimensionModel.instruction isEqualToString:@""]){
                [self.progressBar setDefinitionButtonHidden:NO];
            }else{
                [self.progressBar setDefinitionButtonHidden:YES];
            }
        });
        
        [self initNetworkReachabilityManager];
    } failure:nil];

}


-(void)showFastClickAlert{
   // 非正式环境关闭快速答题提示
    if(![@"https://psytest-server.cheersmind.com" isEqualToString:API_HOST]){
        return;
    }
    if(self.currPageIndex < self.answerManager.questions.count-1){
        [self stopTimes];
        __weak typeof(self) weakSelf = self;
        FECommonAlertView *exitAlert = [[FECommonAlertView alloc] initWithTitle:@"您的手速太快啦！" leftText:@"" rightText:@"好的" icon:[UIImage imageNamed:@"fire_exam_alert_exit"]];
        exitAlert.resultIndex = ^(NSInteger index) {
            if(index == 1){
                //退出
                [weakSelf saveDimensionQuestions];
            }else{
                [weakSelf initTimes];
            }
        };
        exitAlert.extraHandlerForClickingBackground = ^{
            [weakSelf initTimes];
        };
        [exitAlert showCustomAlertView];
    }
}

//本地临时单题保存
- (void) saveSingleAnswer:(NSNumber *)optionIndex optionTexts:(NSString *)optionText ifMergeSubquestionIndex:(NSInteger)subquestionIdx{
    [_answerManager saveSingleAnswerWithOptionIndex:optionIndex optionText:optionText forPage:self.currPageIndex ifMergeSubquestionIndex:subquestionIdx];
    
    
    if ([self.dimensionModel.isMergeAnswer boolValue] == NO) {
        [self showFastClickAlertIfAnswerIsTooFast];
    }
    
}

- (void)showFastClickAlertIfAnswerIsTooFast {
    NSInteger stopQuickTimes = 3;
    if(self.recordTimeArray.count==5){
        [self.recordTimeArray removeObjectAtIndex:0];
        [self.recordTimeArray addObject:@(_answerManager.costedTime)];
        if([self.recordTimeArray[4] integerValue] - [self.recordTimeArray[0] integerValue] <= stopQuickTimes){
            [self showFastClickAlert];
        }
    }else{
        [self.recordTimeArray addObject:@(_answerManager.costedTime)];
        if(self.recordTimeArray.count == 5){
            if([self.recordTimeArray[4] integerValue] - [self.recordTimeArray[0] integerValue] <= stopQuickTimes){
                [self showFastClickAlert];
            }
        }
    }
}

//提交按钮
- (void)submitAnswersAction {
    
    BOOL currentPageAnswered = [_answerManager isAnsweredForPage:self.currPageIndex];
    if (currentPageAnswered) {
        __weak typeof(self) weakSelf = self;
        [self stopTimes];

        FECommonAlertView *completeAlert = [[FECommonAlertView alloc] initWithTitle:@"恭喜你，完成所有问题，\r\n是否提交结果？" leftText:@"返回修改" rightText:@"确定提交" icon:nil];
        completeAlert.resultIndex = ^(NSInteger index) {
            if(index == 1){
                [weakSelf initTimes];
            }else if(index == 2){
                [weakSelf submitDimensionQuestions];
            }
        };
        completeAlert.extraHandlerForClickingBackground = ^{
            [weakSelf initTimes];
        };
        [completeAlert showCustomAlertView];
    } else {
        [QSToast toast:self.view message:@"当前作答未完成"];
    }
    
    
}



//下一题
-(void)scrollToNextPageIfNeeded{
    
    //答完最后一题，可以提交
    if (self.currPageIndex >= _answerManager.questions.count - 1) {
        _lastDidseleted = YES;
        [self submitAnswersAction];
        [self activeSubmitButton];

    }else{
        //修改答题，不自动滚动下一题
        if (self.currPageIndex < self.answerManager.userAnswserIndex) {
            _collectionView.userInteractionEnabled = YES;
            return;
        }
        
        
        //滚动下一题
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currPageIndex+1 inSection:0];
        
        [QMUIHelper executeAnimationBlock:^{
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        } completionBlock:^{
            [self showSlideHintForPreviousIfNeeded];
        }];
    
        
       // self.stopCurrentTime = _answerManager.costedTime;
        
        self.answerManager.userAnswserIndex ++;
    }

}

- (void)showSlideHintForNextIfNeeded {
    //显示滚动下一题的提示
    if (![AppSettingsManager sharedInstance].hasShowSlideHintForNextOnAnswer) {
        [FESlidingHintView showNext];
        [AppSettingsManager sharedInstance].hasShowSlideHintForNextOnAnswer = YES;
    }
}
- (void)showSlideHintForPreviousIfNeeded {
    //显示滚动上一题的提示
    if (![AppSettingsManager sharedInstance].hasShowSlideHintForPreviousOnAnswer) {
        [FESlidingHintView showPrevious];
        [AppSettingsManager sharedInstance].hasShowSlideHintForPreviousOnAnswer = YES;
    }
}

//保存量表答题
-(void)saveDimensionQuestions{
    if (TCNetworkReachabilityHelper.isReachable ) {
        @weakObj(self);
        [_answerManager saveAnswers:^{
            @strongObj(self);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^{
            @strongObj(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//提交量表答题
-(void)submitDimensionQuestions{
    @weakObj(self);
    [_answerManager submitAnwsersWithSuccess:^(id data) {
        @strongObj(self);
        [self goReportViewController:data];
    } failure:^{
        [selfweak initTimes];
    }];
}

-(void)goReportViewController:(NSDictionary *)data{
    
    self.isCompleteAndToReport = YES;
    
    if ([self.dimensionModel.reportForbid isEqualToNumber:@1]){
        //报告被禁止查看，返回测评详情
        //不需要提前移除VC，因为该页不允许返回手势，所以不用考虑提交后手势返回时重复可进入测评
        NSArray *originViewControllers = self.navigationController.viewControllers;
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:originViewControllers];
        NSRange removeIndexRange = NSMakeRange([self.navigationController.viewControllers count] -2, 1);
        NSIndexSet *removeIndexSet = [[NSIndexSet alloc] initWithIndexesInRange:removeIndexRange];
        [viewControllers removeObjectsAtIndexes:removeIndexSet];
        self.navigationController.viewControllers = viewControllers;
        
        [self.navigationController popViewControllerAnimated:YES];
        [QSToast toast:[UIApplication sharedApplication].keyWindow message:@"提交成功"];
        return;
    }
    
    FEEvaluationReportViewController *vc = [[FEEvaluationReportViewController alloc] initWithDimensionId:self.dimensionModel.dimensionID childDimensionId:self.dimensionModel.childDimensionID];
    vc.isCreating = YES;

    if ([[UCManager sharedInstance].careerChildExamId isEqualToString:self.dimensionModel.childExamID]) {
        vc.isCareerReport = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];

    
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 
     return _answerManager.questions? _answerManager.questions.count : 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FEAnswerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FEAnswerCollectionCell class]) forIndexPath:indexPath];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.width, collectionView.height);
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    FEAnswerCollectionCell *_cell = (FEAnswerCollectionCell *)cell;
    if ([self.dimensionModel.isMergeAnswer boolValue] == NO) {
        _cell.single_question = _answerManager.questions[indexPath.item];
    } else {
        _cell.merge_question = _answerManager.questions[indexPath.item];
    }
    @weakObj(self);
    _cell.answeredHandler = ^(NSNumber *optionIndex, NSString *optionText, NSInteger merge_subquestion_index) {
        @strongObj(self);
        //保存答案
        [self saveSingleAnswer:optionIndex optionTexts:optionText ifMergeSubquestionIndex:merge_subquestion_index];
        //答题操作，设置停止时间为当前时间
        self.stopCurrentTime = self.answerManager.costedTime;
        
        //非合并答题，答完一题，切换下一题
        if ([self.dimensionModel.isMergeAnswer boolValue] == NO) {

            if (indexPath.item != self.answerManager.questions.count - 1) {
               self.collectionView.userInteractionEnabled = NO;
            
            }
            
            [self scrollToNextPageIfNeeded];

        }
    
    };
    
    //合并答题，全部答完，切换下一题
    if ([self.dimensionModel.isMergeAnswer boolValue]) {
        _cell.merge_allSubquestionAnsweredHandler = ^{
            @strongObj(self);
            [self showFastClickAlertIfAnswerIsTooFast];
            if (indexPath.item != self.answerManager.questions.count - 1) {
                self.collectionView.userInteractionEnabled = NO;
                
            }
            
            
            [self scrollToNextPageIfNeeded];

        };
    }
       
}


#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.collectionView.userInteractionEnabled = YES;
}

- (NSInteger) getScrollPage {
    CGFloat page =  self.collectionView.width == 0?0 : (self.collectionView.contentOffset.x / self.collectionView.width);
    page = page + 0.5;
    return  (int)page;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        NSInteger page = [self getScrollPage];
        
        BOOL isCurrentQuestionAnswered = [_answerManager isAnsweredForPage:page]; //[self isCurrentQuestionAnswered:page];
        if (!isCurrentQuestionAnswered && scrollView.contentOffset.x>page*scrollView.width) {
            scrollView.contentOffset = CGPointMake(page*scrollView.width, 0);
        }
        
        if (page != self.currPageIndex) {
            self.currPageIndex = page;
            [self updatePage];
        }
    
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.currPageIndex < self.answerManager.userAnswserIndex) {
        [self showSlideHintForNextIfNeeded];
    }
}



-(void)updatePage{
    
    
    [self.progressBar setCurrentProgress:self.currPageIndex+1 total:_answerManager.questions.count];

    
    if(self.currPageIndex == _answerManager.questions.count -1){
        [self activeSubmitButton];
    }

}


//***********测试使用一次性全部回答完所有题*******
- (void) testSaveAllAnswer{
    
    [_answerManager test_answerAllQuestions];
    
    [self stopTimes];
    
    @weakObj(self);
    FECommonAlertView *completeAlert = [[FECommonAlertView alloc] initWithTitle:@"恭喜你，完成所有问题，\r\n是否提交结果？" leftText:@"返回修改" rightText:@"确定提交" icon:nil];
    completeAlert.resultIndex = ^(NSInteger index) {
        @strongObj(self);
        if(index == 1){
            [self initTimes];
        }else if(index == 2){
            [self submitDimensionQuestions];
        }
    };
    completeAlert.extraHandlerForClickingBackground = ^{
        @strongObj(self);
        [self initTimes];
    };
    [completeAlert showCustomAlertView];

}

-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    NSString *str_minute;
    NSString *str_second;
    //format of minute
    if (seconds < 600) {
        str_minute = [NSString stringWithFormat:@"0%ld", seconds/60];
    } else {
        str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    }
    //format of second
    if (seconds % 60 < 10) {
        str_second = [NSString stringWithFormat:@"0%ld", seconds%60];
    } else {
        str_second = [NSString stringWithFormat:@"%ld", seconds%60];
    }
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    
    return format_time;
    
}


@end
