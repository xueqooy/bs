//
//  ProfessionalOccupationsModel.m
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ProfessionalOccupationsModel.h"

@implementation ProfessionalOccupationsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"occupationName":@"occupation_name",
             @"occupationId":@"occupation_id",
             };
}

@end
