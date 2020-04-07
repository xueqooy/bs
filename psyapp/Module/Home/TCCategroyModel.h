//
//  TCCategroyModel.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/3.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCStageModel : FEBaseModel
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *remark;
@end

@interface TCCategroyModel : FEBaseModel
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSArray <TCCategroyModel *>*subItems;
@end

NS_ASSUME_NONNULL_END
