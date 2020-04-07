//
//  TCMyAccountControllerView.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCMyAccountControllerView.h"
#import "TCMyAccountRechargeGridViewCell.h"
#import "TCCommonButton.h"
#import "TCSimultaneousScrollView.h"
@implementation TCMyAccountControllerView {
    TCSimultaneousScrollView *_scrollView;
    UILabel *_balanceLabel;
    QMUIGridView *_rechargeGridView;
    TCCommonButton *_rechargeButton;
    QMUIButton *_rechargeHistoryButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _selectedIndex = -1;
    [self setupSubViews];
    return self;
}

- (void)setEmoneyList:(NSArray *)emoneyList {
    _emoneyList = emoneyList;
    [_rechargeGridView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.gridViewHeight);
    }];
    [self layoutIfNeeded];
    for (int i = 0; i < _emoneyList.count; i ++) {
        TCEmoneyModel *item = _emoneyList[i];
        TCMyAccountRechargeGridViewCell *cell = TCMyAccountRechargeGridViewCell.new;
        cell.price = item.priceYuan;
        cell.emoneyCount = item.emoneyCount;
        @weakObj(self);
        cell.onTap = ^{
            [selfweak selectedEmoneyAtIndex:i];
        };
        [_rechargeGridView addSubview:cell];
    }
    
}

- (void)setEmoneyBalance:(CGFloat)emoneyBalance {
    _emoneyBalance = emoneyBalance;
    _balanceLabel.text = [NSString stringWithFormat:@"%.2f", emoneyBalance];
}

- (void)selectedEmoneyAtIndex:(NSInteger)idx {
    if (_selectedIndex == idx) return;
    TCMyAccountRechargeGridViewCell *previousSeletedCell = _rechargeGridView.subviews[_selectedIndex];
    [previousSeletedCell setSelected:NO];

    _selectedIndex = idx;
    TCMyAccountRechargeGridViewCell *cell = _rechargeGridView.subviews[idx];
    [cell setSelected:YES];
   
}

- (void)setupSubViews {
    _scrollView = TCSimultaneousScrollView.new;
    _scrollView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UIView *rootContainer = UIView.new;
    rootContainer.backgroundColor = UIColor.fe_contentBackgroundColor;
    [_scrollView addSubview:rootContainer];
    [rootContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat margin = STWidth(15);
        make.width.mas_equalTo(mScreenWidth - 2 * margin);
        make.edges.mas_equalTo(UIEdgeInsetsMake(margin, margin, margin, margin));
    }];
    
    UIView *balanceContainer = self.balanceContainer;
    [rootContainer addSubview:balanceContainer];
    [balanceContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.mas_equalTo(STWidth(80));
    }];
    
    UIView *rechargeContainer = self.rechargeContainer;
    [rootContainer addSubview:rechargeContainer];
    [rechargeContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceContainer.mas_bottom);
        make.left.right.offset(0);
    }];
    
    UIView *descContainer = self.descContainer;
    [rootContainer addSubview:descContainer];
    [descContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rechargeContainer.mas_bottom);
        make.bottom.left.right.offset(0);
    }];
}

- (UIView *)balanceContainer {
    UIView *container = UIView.new;
    container.backgroundColor = UIColor.fe_contentBackgroundColor;
    
    UILabel *balanceTitleLabel = UILabel.new;
    balanceTitleLabel.text = @"当前余额（测点）";
    balanceTitleLabel.textAlignment = NSTextAlignmentCenter;
    balanceTitleLabel.textColor = UIColor.fe_auxiliaryTextColor;
    balanceTitleLabel.font = STFontRegular(16);
    [container addSubview:balanceTitleLabel];
    [balanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.centerX.offset(0);
    }];
    
    _balanceLabel = UILabel.new;
    _balanceLabel.text = @"0.00";
    _balanceLabel.textColor = UIColor.fe_titleTextColorLighten;
    _balanceLabel.font = STFontBold(24);
    _balanceLabel.textAlignment = NSTextAlignmentCenter;
    [container addSubview:_balanceLabel];
    [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(balanceTitleLabel.mas_bottom).offset(STWidth(10));
    }];
    
    UIView *separator = UIView.new;
    separator.backgroundColor = UIColor.fe_separatorColor;
    [container addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.equalTo(container);
        make.height.mas_equalTo(STWidth(1));
    }];
    return container;
}

- (UIView *)rechargeContainer {
    UIView *container = UIView.new;
    container.backgroundColor = UIColor.fe_contentBackgroundColor;
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = STFontBold(18);
    titleLabel.textColor = UIColor.fe_titleTextColor;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"充值（充值金额仅限iOS系统使用）"];
    [text setAttributes:@{
        NSFontAttributeName : STFontRegular(12),
        NSForegroundColorAttributeName : UIColor.fe_placeholderColor
    } range:NSMakeRange(2, 15)];
    titleLabel.attributedText = text;
    [container addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(STWidth(10));
    }];
    
    
    _rechargeGridView = [[QMUIGridView alloc] initWithColumn:2 rowHeight:STWidth(48)];
    _rechargeGridView.backgroundColor = UIColor.fe_contentBackgroundColor;
    _rechargeGridView.separatorWidth = STWidth(15);
    _rechargeGridView.separatorColor = UIColor.fe_contentBackgroundColor;
    [container addSubview:_rechargeGridView];
    [_rechargeGridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(STWidth(20));
        make.left.right.offset(0);
        make.height.mas_equalTo(self.gridViewHeight);
    }];
    
    _rechargeButton = TCCommonButton.new;
    _rechargeButton.layer.cornerRadius = STWidth(4);
    [_rechargeButton setTitle:@"立即充值" forState:UIControlStateNormal];
    [_rechargeButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:_rechargeButton];
    [_rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rechargeGridView.mas_bottom).offset(STWidth(20));
        make.left.right.offset(0);
        make.height.offset(STWidth(48));
    }];
    
    _rechargeHistoryButton = QMUIButton.new;
    [_rechargeHistoryButton setTitleColor:UIColor.fe_mainColor forState:UIControlStateNormal];
    _rechargeHistoryButton.titleLabel.font = STFontRegular(16);
    [_rechargeHistoryButton setTitle:@"充值记录" forState:UIControlStateNormal];
    [_rechargeHistoryButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:_rechargeHistoryButton];
    [_rechargeHistoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(_rechargeButton.mas_bottom).offset(STWidth(20));
    }];
    
    UIView *separator = UIView.new;
    separator.backgroundColor = UIColor.fe_backgroundColor;
    [container addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rechargeHistoryButton.mas_bottom).offset(STWidth(10));
        make.bottom.offset(0);
        make.left.offset(STWidth(-15));
        make.right.offset(STWidth(15));
        make.height.mas_equalTo(STWidth(10));
    }];
    return container;    
}


- (UIView *)descContainer {
    UIView *container = UIView.new;
    container.backgroundColor = UIColor.fe_contentBackgroundColor;
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.font = STFontBold(18);
    titleLabel.textColor = UIColor.fe_titleTextColor;
    titleLabel.text = @"充值说明";
    [container addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(STWidth(10));
    }];
    
    UILabel *contentLabel = UILabel.new;
    contentLabel.numberOfLines = 0;
    NSString *content = @"1.充值仅限指定价格；\n2.测点可用于直接购买App内虚拟内容；\n3.测点为虚拟币，充值金额不会过期，不支持退款，提现或转赠他人；";
    [contentLabel setText:content lineSpacing:STWidth(10)];
    contentLabel.font = STFontRegular(14);
    contentLabel.textColor = UIColor.fe_auxiliaryTextColor;
    [container addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(STWidth(20));
        make.left.right.offset(0);
        make.bottom.offset(-STWidth(32));
    }];
    
    return container;
}

- (CGFloat)gridViewHeight {
    NSInteger rowCount = ceilf(self.emoneyList.count / 2.0);
    return rowCount * STWidth(48) + (rowCount - 1) * STWidth(15);
}

- (void)actionForButton:(UIButton *)sender {
    if (sender == _rechargeButton) {
        if (_rechargeHandler) {
            if (_selectedIndex < 0 || _selectedIndex >= _emoneyList.count) {
                _rechargeHandler(nil);
                return;
            }
            _rechargeHandler(_emoneyList[_selectedIndex]);
        }
    } else if (sender == _rechargeHistoryButton) {
        if (_rechargeHistoryBlock) _rechargeHistoryBlock();
    }
}


@end
