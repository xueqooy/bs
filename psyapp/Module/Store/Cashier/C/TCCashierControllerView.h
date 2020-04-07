//
//  TCCashierControllerView.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/21.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TCCashierControllerView <NSObject>
@optional
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, assign) CGFloat productPrice;
@property (nonatomic, assign) CGFloat emoneyBalance;

@property (nonatomic, copy) void(^onButtonClick) (void);
@property (nonatomic, copy) void(^onBackgroundClick) (void);


- (void)doShowAnimation;
- (void)doHideAnimationWithCompletion:(void(^)(BOOL))completion;
- (void)initContainerPosition;
@end

@interface TCCashierControllerView : UIView <TCCashierControllerView>
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, assign) CGFloat productPrice;
@property (nonatomic, assign) CGFloat emoneyBalance;
@property (nonatomic, copy) void(^onButtonClick) (void);
@property (nonatomic, copy) void(^onBackgroundClick) (void);
- (void)doShowAnimation;
- (void)doHideAnimationWithCompletion:(void(^)(BOOL))completion;
- (void)initContainerPosition;

@end

NS_ASSUME_NONNULL_END
