//
//  CommonBottomMenuView.m
//  smartapp
//
//  Created by lafang on 2019/4/1.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "CommonBottomMenuView.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>
#import "StringUtils.h"


@interface CommonBottomMenuView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIButton *closeBtn;//取消按钮
@property(nonatomic,strong) UIButton *sureBtn;//确定按钮

@property(nonatomic,strong) UIPickerView *pickerView;


@property(nonatomic,assign) CGFloat showViewHeight;

@property(nonatomic,strong) NSArray<NSString *> *dataArray;
@property(nonatomic,assign) NSInteger selectIndex;

@end

@implementation CommonBottomMenuView

-(instancetype)initWithData:(NSArray<NSString *> *)array title:(NSString *)title{
    
    if(self == [super init]){
        
        self.dataArray = array;
        
        self.showViewHeight = mScreenHeight/3;
        
        self.frame = CGRectMake(0, 0, mScreenWidth,mScreenHeight);
        self.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.4];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonBgEvent)]];
        
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight - self.showViewHeight, mScreenWidth, self.showViewHeight)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 5;
        
        self.topView = [[UIView alloc] init];
        self.topView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        [self.contentView addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(40);
        }];
        
        self.sureBtn = [[UIButton alloc] init];
        [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [self.topView addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 30));
            make.right.mas_equalTo(self.topView).offset(-20);
            make.centerY.mas_equalTo(self.topView);
        }];
        
        self.closeBtn = [[UIButton alloc] init];
        [self.closeBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.closeBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [self.topView addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 30));
            make.left.mas_equalTo(self.topView).offset(20);
            make.centerY.mas_equalTo(self.topView);
        }];
        
        self.titleLabel = [StringUtils createLabel:title color:@"333333" font:16];
        [self.topView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.topView);
        }];
        
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self.contentView addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.contentView).offset(40);
            make.bottom.equalTo(self.contentView);
        }];
        
        self.selectIndex = 0;
        [self pickerView:self.pickerView didSelectRow:self.selectIndex inComponent:1];
        
    }
    return self;
    
}

#pragma mark - dataSouce
//有几行
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
//行中有几列
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}
//列显示的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component {
    return self.dataArray[row];
}

#pragma mark - delegate
// 选中某一组的某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    NSString *selFood = self.dataArray[row];
    NSLog(@"%li", row);
    self.selectIndex = row;
    
}


#pragma mark - 按钮点击可以回调
- (void)buttonEvent:(UIButton *)sender {
    
    if(sender == self.sureBtn){
        if (self.menuCallBack) {
            self.menuCallBack(self.selectIndex);
        }
    }

    [self disMissView];
}

- (void)buttonBgEvent{
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


@end
