//
//  UniverSitynameItemModel.h
//  smartapp
//
//  Created by lafang on 2019/3/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniverSitynameItemModel : FEBaseModel

@property(nonatomic,strong) NSNumber *total;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *details;
@property(nonatomic,strong) NSArray *items;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *summary;

@end

NS_ASSUME_NONNULL_END
