//
//  FEAnswerModel.h
//  smartapp
//
//  Created by mac on 2019/11/13.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEAnswerModel : FEBaseModel

@property (nonatomic, copy) NSString *questionID;
@property (nonatomic, copy) NSString *optionID;
@property (nonatomic, copy) NSString *childFactorID;
@property (nonatomic, copy) NSString *optionText;

@end

NS_ASSUME_NONNULL_END
