//
//  UniversitySituationModel.h
//  smartapp
//
//  Created by lafang on 2019/3/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "UniversityBasicInfoModel.h"
//#import "UniversityRankingModel.h"
#import "UniversityRankingItemModel.h"
#import "UniverSitynameItemModel.h"
#import "UniversityModel.h"
#import "StudentDataModel.h"
#import "StudentRatioModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversitySituationModel : FEBaseModel

@property(nonatomic,strong) StudentDataModel *studentData;
@property(nonatomic,strong) StudentRatioModel *studentRatio;
@property(nonatomic,strong) NSString *briefIntroduction;
@property(nonatomic,strong) UniversityBasicInfoModel *basicInfo;
@property(nonatomic,strong) NSArray *ranking;
@property(nonatomic,strong) NSArray *advantageSpecialty;//优势专业
@property(nonatomic,strong) NSArray *famousAlumni;//知名校友
@property(nonatomic,strong) UniverSitynameItemModel *facultyStrength;//师资力量
@property(nonatomic,strong) UniverSitynameItemModel *scientificInstitution;//科研机构
@property(nonatomic,strong) NSNumber *isFollow;

@property(nonatomic,strong) UniversityModel *universityModel;
@property(nonatomic,assign) BOOL isScaleBrief;//是否展开简介

@end

NS_ASSUME_NONNULL_END
