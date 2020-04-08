//
//  UniversityBasicInfoModel.h
//  smartapp
//
//  Created by lafang on 2019/3/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityBasicInfoModel : FEBaseModel

//"public_or_private": "public",
//"china_belong_to": "教育部直属",
//"institute_quality": ["985", "双一流", "C9"],
//"institute_type": "综合类"

@property(nonatomic,strong) NSString *publicOrPrivate;
@property(nonatomic,strong) NSString *chinaBelongTo;
@property(nonatomic,strong) NSArray<NSString *> *instituteQuality;
@property(nonatomic,strong) NSString *instituteType;


@end

NS_ASSUME_NONNULL_END
