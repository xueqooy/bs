//
//  UniversityAdminsionModel.h
//  smartapp
//
//  Created by lafang on 2019/4/1.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityAdminsionModel : FEBaseModel

//"batch": "一批",
//"bkcc": "本科",
//"kind": "理科",
//"low_score": 671,
//"low_wc": 287,
//"luqu_num": 111,
//"mark": "original",
//"province_score": 537,
//"school": "北京大学",
//"year": 2017

@property(nonatomic,strong) NSString *batch;
@property(nonatomic,strong) NSString *bkcc;
@property(nonatomic,strong) NSString *kind;
@property(nonatomic,strong) NSNumber *lowScore;
@property(nonatomic,strong) NSNumber *lowWc;
@property(nonatomic,strong) NSNumber *luquNum;
@property(nonatomic,strong) NSString *mark;
@property(nonatomic,strong) NSNumber *provinceScore;
@property(nonatomic,strong) NSString *school;
@property(nonatomic,strong) NSNumber *year;
@property(nonatomic,strong) NSString *provinceSchool;
@property(nonatomic,strong) NSString *province;
@property(nonatomic,strong) NSNumber *uaid;

@end

NS_ASSUME_NONNULL_END
