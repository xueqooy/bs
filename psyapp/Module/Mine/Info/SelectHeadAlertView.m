//
//  SelectHeadAlertView.m
//  smartapp
//
//  Created by lafang on 2018/10/20.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "SelectHeadAlertView.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import  "UIButton+Utils.h"
#import <Masonry/Masonry.h>

@interface SelectHeadAlertView()

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIButton *photoBtn;
@property (nonatomic,strong) UIButton *cameraBtn;
@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,assign) CGFloat showViewHeight;

@end

@implementation SelectHeadAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.showViewHeight = [SizeTool height:180];
        
        self.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight);
        //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonBgEvent)]];
        mLogFunc(@"%f", mBottomSafeHeight);
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight - self.showViewHeight - mBottomSafeHeight, mScreenWidth, self.showViewHeight)];
        self.contentView.backgroundColor = UIColor.fe_contentBackgroundColor;
        [self addSubview:self.contentView];
        
        [self layoutIfNeeded];
        
    
        self.photoBtn = [[UIButton alloc] init];
        [self.photoBtn setTitle:@"从相册中选取" forState:UIControlStateNormal];
        self.photoBtn.titleLabel.font = mFont(16);
        [self.photoBtn setTitleColor:UIColor.fe_titleTextColorLighten forState:UIControlStateNormal];
        [self.photoBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:self.photoBtn];
        [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(_showViewHeight/3.0);
        }];
        
        UIView *separator1 = [UIView new];
        separator1.backgroundColor = UIColor.fe_separatorColor;
        [self.contentView addSubview:separator1];
        [separator1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([SizeTool width:15]);
            make.right.mas_equalTo(- [SizeTool width:15]);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(_photoBtn);
        }];
        
        self.cameraBtn = [[UIButton alloc] init];
        [self.cameraBtn setTitle:@"通过拍照上传" forState:UIControlStateNormal];
        self.cameraBtn.titleLabel.font = mFont(16);
        [self.cameraBtn setTitleColor:UIColor.fe_titleTextColorLighten forState:UIControlStateNormal];
        [self.cameraBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:self.cameraBtn];
        [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(_photoBtn.mas_bottom);
            make.height.mas_equalTo(_showViewHeight/3.0);
        }];
        
        UIView *separator2 = [UIView new];
        separator2.backgroundColor = UIColor.fe_separatorColor;
        [self.contentView addSubview:separator2];
        [separator2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([SizeTool width:15]);
            make.right.mas_equalTo(- [SizeTool width:15]);
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(_cameraBtn);
        }];
       
        self.cancelBtn = [[UIButton alloc] init];
        self.cancelBtn.backgroundColor = [UIColor whiteColor];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = mFont(14);
        [self.cancelBtn setTitleColor:UIColor.fe_textColorHighlighted forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_cameraBtn.mas_bottom);
            make.height.mas_equalTo(_showViewHeight/3.0);
        }];
        
        [self.cameraBtn setBackgroundNormalColor:UIColor.fe_contentBackgroundColor andHighlightedColor:UIColor.fe_buttonBackgroundColorActive];
        [self.photoBtn setBackgroundNormalColor:UIColor.fe_contentBackgroundColor andHighlightedColor:UIColor.fe_buttonBackgroundColorActive];
        [self.cancelBtn setBackgroundNormalColor:UIColor.fe_contentBackgroundColor andHighlightedColor:UIColor.fe_buttonBackgroundColorActive];
    }
    return self;
}

- (void)buttonBgEvent{
    [self disMissView];
}

-(void)buttonClick:(UIButton *)btn{
    
    if(btn == self.photoBtn){
        if(self.resultAlert){
            self.resultAlert(1);
        }
    }else if(btn == self.cameraBtn){
        if(self.resultAlert){
            self.resultAlert(2);
        }
    }
    [self disMissView];
}


//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:self.contentView];
    
    [self.contentView setFrame:CGRectMake(0, mScreenHeight, mScreenWidth, self.showViewHeight)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [self.contentView setFrame:CGRectMake(0, mScreenHeight - self.showViewHeight, mScreenWidth, self.showViewHeight)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    
    [self.contentView setFrame:CGRectMake(0, mScreenHeight - self.showViewHeight, mScreenWidth, self.showViewHeight)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [self.contentView setFrame:CGRectMake(0, mScreenHeight, mScreenWidth, self.showViewHeight)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [self.contentView removeFromSuperview];
                         
                     }];
    
}

-(void)showAlertView{
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

@end
