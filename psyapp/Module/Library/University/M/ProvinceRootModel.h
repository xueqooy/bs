//
//  ProvinceRootModel.h
//  smartapp
//
//  Created by lafang on 2019/3/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "ProvinceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProvinceRootModel : FEBaseModel

@property(nonatomic,assign) NSInteger total;

@property(nonatomic,strong) NSArray *items;

@end

NS_ASSUME_NONNULL_END
