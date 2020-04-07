//
//  MbtiDateModel.m
//  smartapp
//
//  Created by lafang on 2019/3/24.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "MbtiDateModel.h"

@implementation MbtiDateModel

//"left":45.0,
//"right":55.0,
//"result":"string"           //结果

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"left":@"left",
             @"right":@"right",
             @"result":@"result",
             @"leftName":@"left_name",
             @"rightName":@"right_name"
             };
}

@end
