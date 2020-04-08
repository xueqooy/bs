//
//  ProfessionalAdminsionModel.h
//  smartapp
//
//  Created by lafang on 2019/4/1.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfessionalAdminsionModel : FEBaseModel

//"average_score": -1,
//"batch": "一批",
//"bkcc": "本科",
//"high_score": -1,
//"kind": "理科",
//"low_score": 672,
//"low_wc": 261,
//"luqu_num": 12,
//"major": "经济学类",
//"mark": "original",
//"school": "北京大学",
//"year": 2017

@property(nonatomic,strong)NSNumber *paid;
@property(nonatomic,strong)NSString *batch;
@property(nonatomic,strong)NSNumber *lowWc;
@property(nonatomic,strong)NSString *major;
@property(nonatomic,strong)NSString *school;
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSNumber *lowScore;
@property(nonatomic,strong)NSNumber *averageScore;
@property(nonatomic,strong)NSNumber *luquNum;
@property(nonatomic,strong)NSNumber *highScore;
@property(nonatomic,strong)NSNumber *year;
@property(nonatomic,strong)NSString *provinceSchool;
@property(nonatomic,strong)NSString *kind;
@property(nonatomic,strong)NSString *mark;
@property(nonatomic,strong)NSString *bkcc;


@end

NS_ASSUME_NONNULL_END
