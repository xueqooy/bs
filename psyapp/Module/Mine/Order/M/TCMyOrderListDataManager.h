//
//  TCMyOrderListDataManager.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPagedDataManager.h"
#import "TCMyOrderRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum  TCMyOrderType{
    TCMyOrderTypeTest = 1,
    TCMyOrderTypeCourse = 2,
    TCMyOrderTypeEmoney = 3
}TCMyOrderType ;

@interface TCMyOrderListDataManager : NSObject
@property (nonatomic, strong) TCPagedDataManager <TCMyOrderRecordModel *>*list;
@property (nonatomic, assign) TCMyOrderType type;
- (instancetype)initWithOrderType:(TCMyOrderType)orderType;

- (void)getOrderListOnSuccess:(void(^)(void))success failure:(void(^)(void))failure;
@end

NS_ASSUME_NONNULL_END
