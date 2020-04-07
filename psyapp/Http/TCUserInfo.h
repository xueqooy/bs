//
//  TCUserInfo.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/10.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseModel.h"
#import "PICommonInfo.h"





@interface TCUserInfo : FEBaseModel <NSCoding>
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@end


@interface TCChildInfo : FEBaseModel <NSCoding>
@property (nonatomic, copy) NSString *childId;
@property (nonatomic, copy) NSString *childName;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *gradeName;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *schoolId;

//custom
@property (nonatomic, assign, readonly) TCPeriodStage periodStage; //所属的阶段（学前、小学、初中、高中）
@end

@interface TCChildrenInfo : FEBaseModel
@property (nonatomic, copy) NSArray <TCChildInfo *>*items;
@property (nonatomic, assign) NSInteger total;
@end
