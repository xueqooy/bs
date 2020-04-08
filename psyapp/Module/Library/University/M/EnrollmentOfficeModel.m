//
//  EnrollmentOfficeModel.m
//  smartapp
//
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "EnrollmentOfficeModel.h"

@implementation EnrollmentOfficeModel

//"contact_info": "010-62751407",
//"address": "北京市海淀区颐和园路5号北京大学招生办公室",
//"website": "http://www.gotopku.cn"

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"contactInfo":@"contact_info",
             @"address":@"address",
             @"website":@"website",
             };
}

@end
