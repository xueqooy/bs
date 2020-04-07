//
//  TCMyOrderListViewController.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseViewController.h"
#import "TCMyOrderListDataManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface TCMyOrderListViewController : FEBaseViewController
@property (nonatomic, assign) TCMyOrderType type;
- (instancetype)initWithOrderType:(TCMyOrderType)type;
@end

NS_ASSUME_NONNULL_END
