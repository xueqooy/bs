//
//  TCPopupContainerView.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/6.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCPopupContainerViewProtocol
@property (nonatomic) CGFloat height;
@property (nonatomic) UIEdgeInsets margins;

@optional
@property (nonatomic, copy) void (^hideBlock)(void);
@end

@interface TCPopupContainerView : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) UIView *titleLabelContainer;
@property (nonatomic) UIView <TCPopupContainerViewProtocol>*displayedView;
@property (nonatomic) CGFloat limitedMaxHeight;
@property (nonatomic) CGFloat limitedMinHeight;
@property (nonatomic) BOOL prefersHideButtonHidden;
@property (nonatomic) BOOL prefersHideTitle;

- (void)showToWindowWithCompletion:(void(^)(void))completion;
- (void)showToVisibleControllerViewWithCompletion:(void(^)(void))completion;
- (void)hideWithCompletion:(void(^)(void))completion;
@end

