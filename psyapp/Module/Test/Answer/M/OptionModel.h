//
//  OptionModel.h
//  smartapp
//
//  Created by lafang on 2018/8/16.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

@interface OptionModel : FEBaseModel

@property(nonatomic,strong) NSString *optionId;
@property(nonatomic,strong) NSString *content;

@property(nonatomic,strong) NSString *questionId;
@property(nonatomic,assign) NSNumber *type;
@property(nonatomic,assign) NSNumber *score;
@property(nonatomic,assign) NSNumber *showValue;
@property(nonatomic,assign) NSNumber *orderby;

@end
