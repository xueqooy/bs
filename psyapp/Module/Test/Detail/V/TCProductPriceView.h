//
//  TCProductPriceView.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/1.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum TCPresentPircePosition {
    TCPresentPircePositionLeft,//default
    TCPresentPircePositionRight,
    TCPresentPircePositionTop,
} TCPresentPircePosition;

@interface TCProductPriceView : UIView
@property (nonatomic, strong) UIFont *presentPriceTextFont;
@property (nonatomic, strong) UIFont *originalPriceTextFont;

@property (nonatomic, strong) UIColor *presentPriceTextColor;
@property (nonatomic, strong) UIColor *originalPriceTextColor;

@property (nonatomic, assign) CGFloat presentPrice;
@property (nonatomic, assign) CGFloat originalPrice;

@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) TCPresentPircePosition presentPricePosition;
@end

NS_ASSUME_NONNULL_END
