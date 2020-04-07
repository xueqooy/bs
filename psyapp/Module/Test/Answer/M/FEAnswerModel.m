//
//  FEAnswerModel.m
//  smartapp
//
//  Created by mac on 2019/11/13.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEAnswerModel.h"

@implementation FEAnswerModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"questionID" : @"questionID",
        @"optionID" : @"optionID",
        @"childFactorID" : @"childFactorID",
        @"optionText" : @"optionText"
    };
}
@end
