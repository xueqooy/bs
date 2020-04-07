//
//  EmptyErrorView.h
//  smartapp
//
//  Created by lafang on 2018/9/3.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FEErrorType) {
    FEErrorType_NoComment = 1,//无评论
    FEErrorType_NoHistory,//无历史记录
    FEErrorType_NoFollow,//无关注
    FEErrorType_NoCollection,//无收藏
    FEErrorType_NoCoupon,//无优惠卷
    FEErrorType_NoCourse,//无课程
    FEErrorType_NoMessage,//无消息
    FEErrorType_NoSeek,//无搜索
    FEErrorType_NoNet, //加载失败或无网络
    FEErrorType_NoData,//无数据
    FEErrorType_Vistor,//游客模式
};
//#define ERROR_NODATA 0  //暂无数据
//#define ERROR_SERVICE 1 //服务器异常
//#define ERROR_NET 2     //网络异常
//#define ERROR_VISITOR 3  //游客模式

typedef void(^EmptyViewResult)(NSInteger index);

@interface EmptyErrorView : UIView

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,copy) EmptyViewResult refreshIndex;

@property (nonatomic, copy) void(^extraHandler)(void);
- (instancetype) initWithType: (FEErrorType) type fatherView:(UIView *)fatherView;

- (instancetype) initWithNoDataTitle:(NSString *)title buttonText:(NSString *)buttonText fatherView:(UIView *)fatherView;


- (void)showEmptyView;

- (void)hiddenEmptyView;

- (void)setErrorType:(FEErrorType) errorType;

-(void)setRefreshBtnText:(NSString *)text;

-(void)setTitleText:(NSString *)text;

-(void)hiddenRefreshBtn:(BOOL)isHidden;

-(void)updateLayout;
@end
