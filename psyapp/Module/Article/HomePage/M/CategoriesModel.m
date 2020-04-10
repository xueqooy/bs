//
//  CategoriesModel.m
//  smartapp
//
//  Created by lafang on 2018/8/23.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "CategoriesModel.h"

@implementation CategoriesModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"categoriesId":@"id",
             @"name":@"name",
             
             
             @"backgroundImg":@"background_img",
             @"backgroundColor":@"background_color",
             @"icon":@"icon"
             };
}


@end
