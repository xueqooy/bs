//
//  EmptyErrorView.m
//  smartapp
//
//  Created by lafang on 2018/9/3.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "EmptyErrorView.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import <Masonry/Masonry.h>
#import "UIImageView+WebCache.h"

@interface EmptyErrorView()

@property (nonatomic,strong) UIView *containerView;

//@property (nonatomic,strong) UIImageView *bgImage;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *refreshBtn;

@end

@implementation EmptyErrorView

-(instancetype)initWithType:(FEErrorType)type fatherView:(UIView *)fatherView{
    
    if (self == [super init]) {
        
        self.frame = CGRectMake(0, 0, fatherView.width, fatherView.height);
       if (fatherView != nil) {
           [fatherView addSubview:self];
       } else {
           return self;
       }
        self.backgroundColor = UIColor.fe_contentBackgroundColor;
        //self.hidden = YES;
        
        self.containerView = [[UIView alloc] init];
        self.containerView.layer.masksToBounds = YES;
        self.containerView.layer.cornerRadius = 5;
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(STSize(320, 320));
            make.center.equalTo(self);
        }];
        
        self.iconImage = [[UIImageView alloc] init];
        [self.iconImage setImage:[UIImage imageNamed:@"fire_error_net"]];
        self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.containerView addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 200));
            make.centerX.top.equalTo(self.containerView);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"暂无数据";
        self.titleLabel.textColor = UIColor.fe_auxiliaryTextColor;
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.containerView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat topSpacing  = mIsiPhoneX ? 20 :0;
            make.centerX.equalTo(self.containerView);
            make.top.equalTo(self.iconImage.mas_bottom).offset(topSpacing);
            make.right.offset(STWidth(-15));
            make.left.offset(STWidth(15));
        }];
        self.titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick)];
        [self.titleLabel addGestureRecognizer:ges];

        self.refreshBtn = [[UIButton alloc] init];
        [self.refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        self.refreshBtn.titleLabel.font = mFontBold(18);
        self.refreshBtn.fe_adjustTitleColorAutomatically = YES;
        self.refreshBtn.backgroundColor = UIColor.fe_mainColor;
        [self.refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.refreshBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        self.refreshBtn.layer.cornerRadius = STWidth(4);
        self.refreshBtn.hidden = YES;
        [self.containerView addSubview:self.refreshBtn];
        [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat topSpacing = mIsiPhoneX ? 31 : 15;
            make.top.equalTo(self.titleLabel.mas_bottom).offset(topSpacing);
            make.centerX.equalTo(self.containerView);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
        
        
        [self setErrorType:type];
        
    }
    return self;
}

- (instancetype)initWithNoDataTitle:(NSString *)title buttonText:(NSString *)buttonText fatherView:(UIView *)fatherView {
    self = [self initWithType:FEErrorType_NoData fatherView:fatherView];
    if (![NSString isEmptyString:buttonText]) {
        self.refreshBtn.hidden = NO;
        [self.refreshBtn setTitle:buttonText forState:UIControlStateNormal];
    }
    
    if (![NSString isEmptyString:title]) {
        self.titleLabel.text = title;
    } else {
        self.titleLabel.text = @"";
    }
    return self;
}

- (void)updateLayout {
    self.frame = CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height);
}

-(void)titleLabelClick{
     if(self.refreshIndex){
         self.refreshIndex(2);
     }
}

-(void)refreshBtnClick{
    if (self.extraHandler) {
        self.extraHandler();
    }
    if(self.refreshIndex){
        self.refreshIndex(1);
    }
}

-(void)setRefreshBtnText:(NSString *)text{
    if(self.refreshBtn){
        [self.refreshBtn setTitle:text forState:UIControlStateNormal];
    }
}

-(void)setTitleText:(NSString *)text{
    if(self.titleLabel){
        self.titleLabel.text = text;
    }
}

-(void)hiddenRefreshBtn:(BOOL)isHidden{
    if(self.refreshBtn){
        self.refreshBtn.hidden = isHidden;
    }
}

-(void)showEmptyView{
    self.hidden = NO;
}

-(void)hiddenEmptyView{
    self.hidden = YES;
}

-(void)setErrorType:(FEErrorType)errorType{
    switch (errorType) {
        case FEErrorType_NoMessage:
            self.titleLabel.text = @"你还未收到任何消息";
            self.iconImage.image  = [UIImage imageNamed:@"fire_error_message"];
            break;
        case FEErrorType_NoHistory:
            self.titleLabel.text = @"无历史记录";
            self.iconImage.image  = [UIImage imageNamed:@"fire_error_history"];
            break;
        case FEErrorType_NoComment:
            self.titleLabel.text = @"还没留言";
            self.iconImage.image  = [UIImage imageNamed:@"fire_error_comment"];
            break;
        case FEErrorType_NoCollection:
            self.titleLabel.text = @"你没有任何收藏";
            self.iconImage.image  = [UIImage imageNamed:@"fire_error_collect"];
            break;
        case FEErrorType_NoSeek:
            self.titleLabel.text = @"换个关键字试试";
            self.iconImage.image  = [UIImage imageNamed:@"fire_error_seek"];
            break;
        case FEErrorType_NoNet:
            self.titleLabel.text = @"网络异常";
            self.iconImage.image  = [UIImage imageNamed:@"fire_error_net"];
            self.refreshBtn.hidden = NO;
            break;
        case FEErrorType_NoFollow:
            self.titleLabel.text = @"你还没有关注";
            self.iconImage.image  = [UIImage imageNamed:@"fire_error_collect"];
            break;
        case FEErrorType_NoCoupon:
            self.titleLabel.text = @"你没有优惠卷";

            self.iconImage.image  = [UIImage imageNamed:@"fire_error_collect"];
            break;
        case FEErrorType_NoCourse:
            self.titleLabel.text = @"没有课程";
            self.iconImage.image  = [UIImage imageNamed:@"fire_error_collect"];
            break;
        case FEErrorType_NoData:
            self.titleLabel.text = @"暂无数据";
            self.iconImage.image  = [UIImage imageNamed:@"fire_error_collect"];
            break;
        case FEErrorType_Vistor:
            self.refreshBtn.hidden = NO;
            [self.refreshBtn setTitle:@"去登录" forState:UIControlStateNormal];
            self.titleLabel.text = @"需要登录";
            self.iconImage.image  = [UIImage imageNamed:@"fire_error_net"];
            break;
    }

}

@end
