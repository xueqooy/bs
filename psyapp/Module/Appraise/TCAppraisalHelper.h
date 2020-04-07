//
//  TCAppraisalHelper.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/10.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEAppraisalManager.h"
NS_ASSUME_NONNULL_BEGIN
@class TCPopupContainerView;
@interface TCAppraisalHelper : NSObject
@property (nonatomic, strong) FEAppraisalManager *appraisalManager;
@property (nonatomic, assign) FEAppraisalType type;
@property (nonatomic, strong, readonly) TCPopupContainerView *popupView;

@property (nonatomic, copy) void (^appraiseSuccessBlock)(void);

- (instancetype)initWithUniqueId:(NSString *)uniqueId type:(FEAppraisalType)type;

- (void)showAppraisalViewIfNotAppraisedWithCompletion:(void(^)(BOOL shown))completion;
@end

NS_ASSUME_NONNULL_END
