//
//  TCTestHistoryModel.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/8.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCTestHistoryModel : FEBaseModel
@property (nonatomic, copy) NSString *finishTime;
@property (nonatomic, copy) NSString *childDimensionId;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) NSNumber *isBadTendency;
@end

NS_ASSUME_NONNULL_END
