//
//  TCMyAccountControllerView.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCEmoneyModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TCMyAccountControllerView <NSObject>
@optional
@property (nonatomic, copy) NSArray <TCEmoneyModel *>*emoneyList;
@property (nonatomic, assign) CGFloat emoneyBalance;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void (^rechargeHandler)(TCEmoneyModel * _Nullable emoney);
@property (nonatomic, copy) void (^rechargeHistoryBlock)(void);
@end

@interface TCMyAccountControllerView : UIView <TCMyAccountControllerView>
@property (nonatomic, copy) NSArray *emoneyList;
@property (nonatomic, assign) CGFloat emoneyBalance;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void (^rechargeHandler)(TCEmoneyModel *emoney);
@property (nonatomic, copy) void (^rechargeHistoryBlock)(void);

@end

NS_ASSUME_NONNULL_END
