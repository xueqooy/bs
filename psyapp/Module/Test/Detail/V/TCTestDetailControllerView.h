//
//  TCTestDetailControllerView.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/1.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluationDetailDimensionsModel.h"

#import "TCCommonButton.h"
//#import "TCProductToolBar.h"

@class CommentModel;
@class TCPopupContainerView;
NS_ASSUME_NONNULL_BEGIN 
@protocol TCTestDetailControllerView
@optional
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong, readonly) UIBarButtonItem *barRightButtonItem;

@property (nonatomic, weak) TCPopupContainerView *currentPopupContainer;

@property (nonatomic, weak) EvaluationDetailDimensionsModel *detail;
@property (nonatomic, assign) BOOL didAppraise;
@property (nonatomic, assign) BOOL canAppraise;

@property (nonatomic, copy) void (^mainButtonAction)(void);
@property (nonatomic, copy) void (^retestButtonAction)(void);
@property (nonatomic, copy) void (^historyButtonAction)(void);
@property (nonatomic, copy) void (^appraisalButtonAction)(void);
@property (nonatomic, copy) CGFloat (^commentHeightBlock)(NSInteger idx);

- (void)updateView;
- (void)updateMainButton;
- (void)updateEvaluationViewWithIndex:(CGFloat)index;
- (void)hideHeaderPriceView;

@end

@interface TCTestDetailControllerView : UIView <TCTestDetailControllerView>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong, readonly) UIBarButtonItem *barRightButtonItem;

@property (nonatomic, weak) EvaluationDetailDimensionsModel *detail;
@property (nonatomic, weak) TCPopupContainerView *currentPopupContainer;

@property (nonatomic, assign) BOOL didAppraise;
@property (nonatomic, assign) BOOL canAppraise;

@property (nonatomic, copy) void (^mainButtonAction)(void);
@property (nonatomic, copy) void (^retestButtonAction)(void);
@property (nonatomic, copy) void (^historyButtonAction)(void);
@property (nonatomic, copy) void (^appraisalButtonAction)(void);
@property (nonatomic, copy) CGFloat (^commentHeightBlock)(NSInteger idx);

- (void)updateView;
- (void)updateMainButton;//返回界面时，再次请求详情数据，只刷新工具栏
- (void)updateEvaluationViewWithIndex:(CGFloat)index;
- (void)hideHeaderPriceView;
@end

NS_ASSUME_NONNULL_END
