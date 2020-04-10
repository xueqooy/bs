//
//  TCAdvertPopupView.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/30.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCAdvertPopupView : FEBaseAlertView
@property (nonatomic) CGFloat maximumWidth;
@property (nonatomic) CGFloat maximumHeight;
@property (nonatomic) CGFloat spacingBetweenImageAndButton;
@property (nonatomic) CGSize buttonSize;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIButton *closeButton;
@property (nonatomic) BOOL hideWhenTapImage;

@property (nonatomic) BOOL hideAnimated;

@property (nonatomic, copy) void (^didTapImage)(void);
@end

NS_ASSUME_NONNULL_END
