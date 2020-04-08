//
//  ProfessionalRootModel.m
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ProfessionalRootModel.h"

@implementation ProfessionalRootModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"total":@"total",
             @"items":@"items"
             };
}


+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:ProfessionalSubjectModel.class];
}

@end
