//
//  UniversityMajorRootModel.h
//  smartapp
//
//  Created by lafang on 2019/3/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "UniversityMajorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityMajorRootModel : FEBaseModel

@property(nonatomic,assign) NSInteger total;

@property(nonatomic,strong) NSArray *items;

@end

NS_ASSUME_NONNULL_END
