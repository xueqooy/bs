//
//  TCBannerModel.h
//  smartapp
//
//  Created by lafang on 2019/4/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"



NS_ASSUME_NONNULL_BEGIN
// type 类型 1 文章 2 TAB 3.课程 4.测评量表 5.url跳转  6.个人中心 99.广告(新加的)
@interface TCBannerModel : FEBaseModel
@property (nonatomic, strong) NSNumber *uniqueId;
@property(nonatomic, copy)NSString *describe;
@property(nonatomic, copy)NSString *imgUrl;
@property(nonatomic, strong)NSNumber *type;
@property(nonatomic, copy)NSString *value;
@property (nonatomic, strong) NSNumber *includeAd;
@property (nonatomic, strong) NSNumber *showPage; // 0发现 1测评 
//广告属性
@property(nonatomic,strong)NSString *adImageURL;

@end

NS_ASSUME_NONNULL_END
