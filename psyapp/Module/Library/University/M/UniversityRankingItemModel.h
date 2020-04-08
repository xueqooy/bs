//
//  UniversityRankingItemModel.h
//  smartapp
//
//  Created by lafang on 2019/3/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityRankingItemModel : FEBaseModel

@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSNumber *value;
@property(nonatomic,strong)NSString *type;

@end

NS_ASSUME_NONNULL_END
