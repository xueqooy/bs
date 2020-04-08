//
//  DegreesRootModel.m
//  smartapp
//
//  Created by lafang on 2019/3/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "DegreesRootModel.h"

@implementation DegreesRootModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"items":@"items"
             };
}


+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:DegreesModel.class];
}

@end
