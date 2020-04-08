//
//  EnrollmentNavigationModel.m
//  smartapp
//
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "EnrollmentNavigationModel.h"

@implementation EnrollmentNavigationModel

//"name": "普通高考报考专区",
//"items": [{

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"name":@"name",
             @"items":@"items",
             };
}

+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:EnrollmentNavigationItemModel.class];
}

@end
