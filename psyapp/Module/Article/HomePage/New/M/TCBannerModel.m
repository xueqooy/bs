//
//  TCBannerModel.m
//  smartapp
//
//  Created by lafang on 2019/4/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "TCBannerModel.h"

@implementation TCBannerModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
        @"uniqueId" : @"id",
        @"describe" : @"describe",
        @"imgUrl":@"img_url",
        @"type":@"type",
        @"value":@"value",
        @"includeAd" : @"inc_ad",
        @"showPage" : @"show_page",
        @"adImageURL" : @"ext_img_url",
    };
}

@end
