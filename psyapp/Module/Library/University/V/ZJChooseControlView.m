//
//  ZJChooseControlView.m
//  smartapp
//
//  Created by lafang on 2019/2/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ZJChooseControlView.h"
#import "ZJChooseModel.h"
#import "FEBaseViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+Category.h"

@interface ZJChooseControlView()

@property(nonatomic ,strong) UIView *btnBackView;

@end

@implementation ZJChooseControlView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.btnBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 50)];
//        self.btnBackView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [self addSubview:self.btnBackView];
        UIView *line = [[UIView alloc] init];
        [self.btnBackView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        line.backgroundColor = UIColor.fe_mainTextColor;
        
        
    }
    return self;
}




-(void)btnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(chooseControlWithBtnArray:button:)]) {
        [self.delegate chooseControlWithBtnArray:self.btnArr button:sender];
    }
}


-(void)setUpAllViewWithTitleArr:(NSArray *)titleArr{
    for (int i = 0; i<titleArr.count; i++) {
        ZJButton *btn = [[ZJButton alloc]init];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"3c3f42"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"fc674f"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"fire_filter_down"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"fire_filter_up"] forState:UIControlStateSelected];
        btn.imageAlignment = ZJImageAlignmentRight;
        btn.spaceBetweenTitleAndImage = 3;
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        CGFloat btnW = mScreenWidth/3;
        CGFloat btnX = i*btnW;
        btn.frame = CGRectMake(btnX, 0, btnW, 50);
        [self.btnBackView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnArr addObject:btn];
    }
    
    CGFloat margin = mScreenWidth/3;
//    for (int i = 0; i<2; i++) {
//        UIView *line = [[UIView alloc]init];
//
//        line.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"];
//
//        CGFloat w = 0.5;
//        CGFloat h = 24;
//        CGFloat x = (margin + w) * (i+1);
//        CGFloat y = 13;
//        line.frame = CGRectMake(x, y, w, h);
//        [self.btnBackView addSubview:line];
//    }
    
}


-(NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}


@end
