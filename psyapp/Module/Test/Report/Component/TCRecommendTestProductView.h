//
//  TCRecommendTestProductView.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/27.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEUIComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCRecommendTestProductView : FEUIComponent
- (instancetype)initWithTitleText:(NSString *)titleText participantsCount:(NSInteger)count iconImageURL:(NSURL *)imageURL alreadyPurchase:(BOOL)purchased presentPrice:(CGFloat)presentPrice originPrice:(CGFloat)originPrice ;
//- (void)setCompleted:(BOOL)completed;

@property (nonatomic, copy) void (^onClick)(void);
@end

NS_ASSUME_NONNULL_END
