//
//  TCCoursePurchaseBar.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/17.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCPopupContainerView.h"

NS_ASSUME_NONNULL_BEGIN
extern NSString *const TCOperationTestHistory;
extern NSString *const TCOperationReTest;
extern NSString *const TCOperationTestAppraise;

extern NSTimeInterval const TCRetestRemainTimeUnknown;

@interface TCTestMoreOperationView : UIView  <TCPopupContainerViewProtocol>
@property (nonatomic, copy) NSArray <NSString *>*operations;
@property (nonatomic, copy) void (^onOperation)(NSString *operation);

- (void)setRetestEnabledRemainTime:(NSTimeInterval)time;
@end

NS_ASSUME_NONNULL_END
