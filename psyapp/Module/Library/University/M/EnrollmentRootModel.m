//
//  EnrollmentRootModel.m
//  smartapp
//
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "EnrollmentRootModel.h"

@implementation EnrollmentRootModel

//@property(nonatomic,strong)EnrollmentOfficeModel *enrollmentOffice;
//@property(nonatomic,strong)EnrollmentOfficeModel *enrollmentNavigation;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"enrollmentOffice":@"enrollment_office",
             @"enrollmentNavigation":@"enrollment_navigation",
             };
}


+ (NSValueTransformer *)enrollmentOfficeJSONTransformer {

    return [MTLJSONAdapter dictionaryTransformerWithModelClass:EnrollmentOfficeModel.class];

}

+ (NSValueTransformer *)enrollmentNavigationJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:EnrollmentNavigationModel.class];
}

@end
