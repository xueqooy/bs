//
//  MbtiDateModel.h
//  smartapp
//
//  Created by lafang on 2019/3/24.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MbtiDateModel : FEBaseModel

//"left":45.0,
//"right":55.0,
//"result":"string"           //结果

@property(nonatomic,strong)NSNumber *left;
@property(nonatomic,strong)NSNumber *right;
@property(nonatomic,strong)NSString *result;
@property(nonatomic, copy)NSString *leftName;
@property(nonatomic, copy)NSString *rightName;

@end

NS_ASSUME_NONNULL_END
