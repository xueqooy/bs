//
//  TCCashierControllerView.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/21.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCCashierControllerView.h"
#import "TCCommonButton.h"
@implementation TCCashierControllerView {
    UIView *_container;
    UILabel *_nameLabel;
    UILabel *_priceLabel;
    UILabel *_balanceLabel;
    TCCommonButton *_purchaseButton;
    UIView *_bottomPlaceholderView;
    
    NSString *_buttonTitle;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _productPrice = 0;
    _emoneyBalance = 0;
    @weakObj(self);
    [self addTapGestureWithBlock:^{
        if (selfweak.onBackgroundClick) {
            selfweak.onBackgroundClick();
        }
    }];
    [self setupSubviews];
    return self;
}

- (void)initContainerPosition {
    
    _container.transform = CGAffineTransformMakeTranslation(0, STWidth(260));
}


- (void)doShowAnimation {
    [UIView animateWithDuration:0.25 animations:^{
        _container.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void)doHideAnimationWithCompletion:(void (^)(BOOL))completion {
    [UIView animateWithDuration:0.15 animations:^{
        _container.transform = CGAffineTransformMakeTranslation(0, STWidth(260));
        self.alpha = 0;
    } completion:completion];
}

- (void)setProductName:(NSString *)productName {
    _productName = productName;
    _nameLabel.text = _productName;
}

- (void)setProductPrice:(CGFloat)productPrice {
    _productPrice = productPrice;
    _priceLabel.text = PriceEmoneyYuanString(_productPrice);
    [self updateButtonTitle];
}

- (void)setEmoneyBalance:(CGFloat)emoneyBalance {
    _emoneyBalance = emoneyBalance;
    
    _balanceLabel.text = [NSString stringWithFormat:@"(当前余额：%@)", _emoneyBalance==0? @"0" : PriceYuanString(_emoneyBalance)];
    [self updateButtonTitle];
}

- (void)updateButtonTitle {
    if (_productPrice <= _emoneyBalance) {
        _buttonTitle = _productPrice == 0? @"免费": [NSString stringWithFormat:@"立即购买：%@", PriceEmoneyYuanString(_productPrice)];
    } else {
        _buttonTitle = @"测点不足，充值并购买";
    }
    [_purchaseButton setTitle:_buttonTitle forState:UIControlStateNormal];

}

- (void)actionForButton:(UIButton *)sender {
    if (sender == _purchaseButton) {
        if (_onButtonClick) {
               _onButtonClick();
           }
    }
}

- (void)setupSubviews {
    _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, STWidth(260))];
    _container.backgroundColor = UIColor.fe_backgroundColor;
    [self addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(mScreenWidth, STWidth(260)));
        make.bottom.offset(-mBottomSafeHeight);
        make.centerX.offset(0);
    }];
    
    _bottomPlaceholderView = UIView.new;
    _bottomPlaceholderView.backgroundColor = UIColor.fe_backgroundColor;
    [self addSubview:_bottomPlaceholderView];
    [_bottomPlaceholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(mScreenWidth, mBottomSafeHeight));
        make.top.equalTo(_container.mas_bottom);
        make.left.offset(0);
    }];
    
    UIView *productInfoContainer = self.productInfoContainer;
    productInfoContainer.backgroundColor = UIColor.fe_contentBackgroundColor;
    [_container addSubview:productInfoContainer];
    [productInfoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.mas_equalTo(STWidth(60));
    }];
    
    UIView *purchaseTypeContainer = self.purchaseTypeContainer;
    [_container addSubview:purchaseTypeContainer];
    [purchaseTypeContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productInfoContainer.mas_bottom);
        make.left.right.offset(0);
        make.height.mas_equalTo(STWidth(60));
    }];
    
    _purchaseButton = TCCommonButton.new;
    _purchaseButton.layer.cornerRadius = STWidth(4);
    [_purchaseButton addTarget:self action:@selector(actionForButton:) forControlEvents:UIControlEventTouchUpInside];
    [_container addSubview:_purchaseButton];
    [_purchaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(STWidth(15));
        make.right.bottom.offset(STWidth(-15));
        make.height.mas_equalTo(STWidth(48));
    }];
}

- (UIView *)productInfoContainer {
    UIView *container = UIView.new;
    container.backgroundColor = UIColor.fe_contentBackgroundColor;
    
    _nameLabel = UILabel.new;
    _nameLabel.textColor = UIColor.fe_titleTextColor;
    _nameLabel.font = STFontBold(18);
    [container addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(STWidth(15));
        make.right.offset(STWidth(-100));
        make.centerY.offset(0);
    }];
    
    _priceLabel = UILabel.new;
    _priceLabel.textColor = mHexColor(@"#FC674F");
    _priceLabel.font = STFontBold(16);
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [container addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.offset(STWidth(-15));
    }];
    
    UIView *separator = UIView.new;
    separator.backgroundColor = UIColor.fe_separatorColor;
    [container addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.mas_equalTo(STWidth(1));
    }];
    return container;
}

- (UIView *)purchaseTypeContainer {
    UIView *container = UIView.new;
    container.backgroundColor = UIColor.fe_contentBackgroundColor;
    
    UIImageView *iconImageView = [UIImageView new];
    [iconImageView setImage:[UIImage imageNamed:@"emoney"]];
    iconImageView.clipsToBounds = YES;
    [container addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(STWidth(15));
        make.centerY.offset(0);
        make.size.mas_equalTo(STSize(24, 24));
    }];
    
    UILabel *typeNameLabel = UILabel.new;
    typeNameLabel.text = @"测点支付";
    typeNameLabel.textColor = UIColor.fe_titleTextColorLighten;
    typeNameLabel.font = STFontRegular(16);
    [container addSubview:typeNameLabel];
    [typeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.equalTo(iconImageView.mas_right).offset(STWidth(10));
    }];
    
    _balanceLabel = UILabel.new;
    _balanceLabel.textColor = UIColor.fe_auxiliaryTextColor;
    _balanceLabel.font = STFontRegular(12);
    [container addSubview:_balanceLabel];
    [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.equalTo(typeNameLabel.mas_right).offset(STWidth(6));
    }];
    
    UIButton *checkButton = UIButton.new;
    checkButton.layer.cornerRadius = STWidth(9);
    [checkButton setImageEdgeInsets:UIEdgeInsetsMake(STWidth(4), STWidth(3), STWidth(4), STWidth(3))];
    checkButton.backgroundColor = UIColor.fe_mainColor ;
    [checkButton setImage: [[UIImage imageNamed:@"checked_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [container addSubview:checkButton];
    [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(STSize(18, 18));
        make.centerY.offset(0);
        make.right.offset(STWidth(-15));
    }];
    return container;
}
@end
