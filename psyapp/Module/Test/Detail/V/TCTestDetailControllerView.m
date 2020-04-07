//
//  TCTestDetailControllerView.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/1.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCTestDetailControllerView.h"
#import "TCTestDetailBriefTableViewCell.h"
#import "PATestDetailHeaderTableViewCell.h"
#import "TCImageHeaderScrollingAnimator.h"
#import "TCCommonButton.h"
#import "TCTestMoreOperationView.h"
#import "TCPopupContainerView.h"

#import "UserService.h"
#import "DateUtil.h"
@interface TCTestDetailControllerView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BOOL backBtnAnimating;
@property (nonatomic, strong) TCImageHeaderScrollingAnimator *scrollingAnimator;
@property (nonatomic, strong) PATestDetailHeaderTableViewCell *headerCell;
@property (nonatomic, strong) TCTestDetailBriefTableViewCell *briefCell;
@property (nonatomic, strong) TCCommonButton *mainButton ;
@end

#define HeaderSection 0
#define BriefSection 1

@implementation TCTestDetailControllerView {
//    TCPopupContainerView *_moreOperationPopupContainer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.fe_backgroundColor;
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.width.mas_equalTo(mScreenWidth);
        make.bottom.offset(0);
    }];
    

    _scrollingAnimator = TCImageHeaderScrollingAnimator.new;
    _scrollingAnimator.scrollView = _tableView;

}

- (UIBarButtonItem *)barRightButtonItem {
    UIButton *button = QMUIButton.new;
    [button setImage:[UIImage imageNamed:@"menu_point"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionForBarRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIView *rightView = UIView.new;
    rightView.frame = CGRectMake(0, 0, STWidth(20), STWidth(20));
    button.frame = rightView.bounds;
    [rightView addSubview:button];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    return item;
}

- (void)actionForBarRightButton {
    if (_currentPopupContainer != nil ) {
        if (![_currentPopupContainer.displayedView isKindOfClass:[TCTestMoreOperationView class]]) {
            [_currentPopupContainer hideWithCompletion:nil];
        } else {
            return;
        }
        
    }
    TCTestMoreOperationView *moreOperationView = TCTestMoreOperationView.new;
    [self configMoreOperationView:moreOperationView];
    
    TCPopupContainerView *popupContainer = TCPopupContainerView.new;
    popupContainer.limitedMinHeight = 0;
    popupContainer.prefersHideTitle = YES;
    popupContainer.displayedView = moreOperationView;
    
    [popupContainer showToVisibleControllerViewWithCompletion:^{
    }];
    _currentPopupContainer = popupContainer;
}

- (void)hideHeaderPriceView {
//    _headerView.priceHidden = YES;
}

- (void)configMoreOperationView:(TCTestMoreOperationView *)moreOperationView {
    if (_detail == nil) return;
    NSMutableArray *operations = @[].mutableCopy;
    if (!_detail.isOwn.boolValue && [NSString isEmptyString:_detail.childExamID]) {
        return;
    } else {
        if (self.didAppraise == NO && self.canAppraise == YES) {
            [operations addObject:TCOperationTestAppraise];
        }
        if(_detail.status != nil){
            if([_detail.status integerValue] == 1){
                [operations addObjectsFromArray: @[TCOperationReTest, TCOperationTestHistory]];
            }else{
                [operations addObject: TCOperationTestHistory];
            }

        }else{
            [operations addObject: TCOperationTestHistory];
        }
    }
    
    moreOperationView.operations = operations;
    for (NSString *tool in operations) {
        if ([tool isEqualToString:TCOperationReTest]) {
            //先设置成不能重测，防止网络延迟，导致未能重测的状态下用户点击开始重测
            [moreOperationView setRetestEnabledRemainTime:TCRetestRemainTimeUnknown];
            CGFloat dayInterval = _detail.retestGap? _detail.retestGap.floatValue : 7;
            
            [UserService getServerTimer:^(id data) {
                NSString *serverTime = data[@"datetime"];
                if (![NSString isEmptyString:self.detail.finishTime] && ![NSString isEmptyString:serverTime]) {
                    NSTimeInterval rest = dayInterval * 24 * 3600 + [DateUtil tokenRemainTimeWithExpiredDate:self.detail.finishTime currentDate:serverTime];
                    [moreOperationView setRetestEnabledRemainTime:rest];
                } else {
                    [moreOperationView setRetestEnabledRemainTime:TCRetestRemainTimeUnknown];
                }
            } failure:^(NSError *error) {
                [moreOperationView setRetestEnabledRemainTime:TCRetestRemainTimeUnknown];
            }];
        }
    }
    @weakObj(self);
    moreOperationView.onOperation = ^(NSString * _Nonnull operation) {
        if ([operation isEqualToString:TCOperationReTest]) {
            if (selfweak.retestButtonAction) selfweak.retestButtonAction();
        } else if ([operation isEqualToString:TCOperationTestHistory]) {
            if (selfweak.historyButtonAction) selfweak.historyButtonAction();
        } else if ([operation isEqualToString:TCOperationTestAppraise]) {
            if (selfweak.appraisalButtonAction) selfweak.appraisalButtonAction();
        }
    };
}

- (void)updateView{
    if (_detail == nil) return;
    //header
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_detail.backgroundImage]];
    _scrollingAnimator.image = [UIImage sd_imageWithData:imageData];
    if (_detail.isOwn.boolValue == YES || _detail.childExamID) {
        [self hideHeaderPriceView];
    } else {
        _headerCell.presentPrice = _detail.priceYuan;
        _headerCell.originPrice = _detail.originPriceYuan;
    }
    _headerCell.title = _detail.dimensionName;
    NSMutableString *text = @"".mutableCopy;
    if (_detail.questionCount) {
        [text appendFormat:@"%@个问题", _detail.questionCount];
    }
    if (_detail.estimatedTime) {
        NSInteger costTime = (NSInteger)ceil([_detail.estimatedTime integerValue] / 60.0);
        if (![text isEqualToString:@""]) {
            [text appendString:@" | "];
        }
        [text appendFormat:@"约%li分钟", (long)costTime];
    }
    if (_detail.useCount) {
        if (![text isEqualToString:@""]) {
            [text appendString:@" | "];
        }
        [text appendFormat:@"%@人已完成", _detail.useCount];
    }
    _headerCell.desc = text;

    //brief
    NSString *briefText;
    if ([NSString isEmptyString:_detail.whatTest]) {
        if(![NSString isEmptyString:_detail.descriptionD]){
            briefText = _detail.descriptionD;
        } else {
            briefText = @"暂无简介";
        }
    } else {
        briefText = _detail.whatTest;
    }
    _briefCell.briefText = briefText;
    if (![NSString isEmptyString:_detail.targetUser]) {
        _briefCell.suitText = _detail.targetUser;
    }
    if (![NSString isEmptyString:_detail.gain]) {
        _briefCell.gainText = _detail.gain;
    }
    if(![NSString isEmptyString:_detail.instruction]) {
        _briefCell.noticeText = _detail.instruction;
    }
    
    [self updateMainButton];
    
    [_tableView reloadData];
}

- (void)updateMainButton {
    if (_detail == nil) return;
    NSString *buttonTitle;
    if (!_detail.isOwn.boolValue && [NSString isEmptyString:_detail.childExamID]) {
       if (_detail.priceYuan == 0) {
           buttonTitle = @"免费";
       } else {
           buttonTitle = @"立即购买";
       }
    } else {
        if(_detail.status != nil){
            if([_detail.status integerValue] == 1){
                buttonTitle = @"查看报告";
            }else{
                if (_detail.reportStatus && [_detail.reportStatus isEqualToNumber:@1]) {
                    buttonTitle = @"报告生成中";
                } else {
                    buttonTitle = @"继续测评";
                }
            }

        }else{
             buttonTitle = @"开始测评";
        }

    }
    
    [_mainButton setTitle:buttonTitle forState:UIControlStateNormal];
    
}

- (void)updateEvaluationViewWithIndex:(CGFloat)index {
    _headerCell.recommendIndex = index;
}

- (void)actionForMainButton {
    if (_mainButtonAction) _mainButtonAction();
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == HeaderSection) {
        if (_headerCell == nil) {
            PATestDetailHeaderTableViewCell *_cell = PATestDetailHeaderTableViewCell.new;
            _headerCell = _cell;
        }
        cell = _headerCell;
    } else  if (indexPath.section == BriefSection) {
        if (_briefCell == nil) {
            TCTestDetailBriefTableViewCell *_cell = TCTestDetailBriefTableViewCell.new;
            _briefCell = _cell;
        }
        cell = _briefCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView;
    if (section == BriefSection) {
        headerView = [self createCommonTitleViewWithTitleText:@"测评简介"];
    }
    return headerView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    if (section == BriefSection) {
        if (_mainButton == nil) {
            _mainButton = TCCommonButton.new;
            _mainButton.layer.cornerRadius = STWidth(4);
            [_mainButton addTarget:self action:@selector(actionForMainButton) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [footerView addSubview:_mainButton];
        [_mainButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(STSize(345, 48));
            make.centerX.offset(0);
            make.top.offset(STWidth(10));
        }];

    }
    
    footerView.backgroundColor = UIColor.fe_backgroundColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == BriefSection) {
        return STWidth(68) + mBottomSafeHeight;
    }
    return STWidth(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == HeaderSection) return 0;
    return STWidth(48);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (UIView *)createCommonTitleViewWithTitleText:(NSString *)title {
    UIView *titleContainer = [UIView new];
    titleContainer.backgroundColor = UIColor.fe_contentBackgroundColor;
        
    UILabel *titleLabel = [UILabel createLabelWithDefaultText:title
                                                numberOfLines:1
                                                    textColor:UIColor.fe_titleTextColorLighten
                                                         font:STFontBold(24)];
    
    [titleContainer addSubview:titleLabel];
    

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(STWidth(15));
        make.top.offset(STWidth(10));
    }];
    titleContainer.frame = CGRectMake(0, 0, mScreenWidth, STWidth(48));

    return titleContainer;
}


@end
