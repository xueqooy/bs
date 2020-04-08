//
//  ProfessionalRootModel.h
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "ProfessionalSubjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessionalRootModel : FEBaseModel

@property(nonatomic,assign) NSInteger total;

@property(nonatomic,strong) NSArray *items;

@end

NS_ASSUME_NONNULL_END
