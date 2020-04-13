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

- (instancetype)initWithAVObject:(AVObject *)object {
    self = [super initWithAVObject:object];
    self.uniqueId = object.objectId;
    AVFile *imgFile = [object objectForKey:@"img"];
    self.imgUrl = imgFile.url;
    self.type = [object objectForKey:@"type"];
    self.value = [object objectForKey:@"value"];
    self.includeAd = [object objectForKey:@"includeAd"];
    AVFile *adImgFile = [object objectForKey:@"adImg"];
    self.adImageURL = adImgFile.url;
    self.describe = [object objectForKey:@"description"];
    return self;
}
@end
