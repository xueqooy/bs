//
//  FEDimensionEvaluateModel.h
//  smartapp
//
//  Created by mac on 2019/12/23.
//  Copyright © 2019 jeyie0. All rights reserved.
//
//https://www.tapd.cn/22217601/markdown_wikis/view/#1122217601001001705
#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface FEDimensionEvaluateTitleItemModel : FEBaseModel
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *type;
@end

@interface FEDimensionEvaluateTitleModel : FEBaseModel
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, copy) NSArray <FEDimensionEvaluateTitleItemModel *>* items;
@end

@interface FEDimensionEvaluateItemModel : FEBaseModel
@property (nonatomic, strong) NSNumber *itemCount;
@property (nonatomic, strong) NSNumber *value;
@end

@interface FEDimensionEvaluateModel : FEBaseModel
@property (nonatomic, copy) NSArray <FEDimensionEvaluateItemModel *>* evaluateList;
@property (nonatomic, copy) NSString *recommendValue;
@end

NS_ASSUME_NONNULL_END
