//
//  UniversityRankingModel.h
//  smartapp
//
//  Created by lafang on 2019/3/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityRankingModel : FEBaseModel

//"arwu": 45,
//"cn_zonghelei15": 0,
//"qs": 17,
//"cn_yuyanlei15": 0,
//"cn_caijinglei15": 0,
//"cn_yishulei15": 0,
//"cn_zhengfalei15": 0,
//"cn_minzulei15": 0,
//"usnews_global": 50,
//"cn_shifanlei15": 0,
//"cn_yiyaolei15": 0,
//"cn_nonglinlei15": 0,
//"cn_zhuanke16": 0,
//"times": 22,
//"applysq": 0,
//"cn_ligonglei15": 1,
//"cn_china15": 2,
//"usnews": 0,
//"cn_tiyulei15": 0,
//"fortune500": 0

@property(nonatomic,strong) NSNumber *arwu;
@property(nonatomic,strong) NSNumber *cnZonghelei15;
@property(nonatomic,strong) NSNumber *qs;
@property(nonatomic,strong) NSNumber *cnYuyanlei15;
@property(nonatomic,strong) NSNumber *cnCaijinglei15;
@property(nonatomic,strong) NSNumber *cnYishulei15;
@property(nonatomic,strong) NSNumber *cnZhengfalei15;
@property(nonatomic,strong) NSNumber *cnMinzulei15;
@property(nonatomic,strong) NSNumber *usnewsGlobal;
@property(nonatomic,strong) NSNumber *cnShifanlei15;
@property(nonatomic,strong) NSNumber *cnYiyaolei15;
@property(nonatomic,strong) NSNumber *cnNonglinlei15;
@property(nonatomic,strong) NSNumber *cnZhuanke16;
@property(nonatomic,strong) NSNumber *times;
@property(nonatomic,strong) NSNumber *applysq;
@property(nonatomic,strong) NSNumber *cnLigonglei15;
@property(nonatomic,strong) NSNumber *cnChina15;
@property(nonatomic,strong) NSNumber *usnews;
@property(nonatomic,strong) NSNumber *cnTiyulei15;
@property(nonatomic,strong) NSNumber *fortune500;

@end

NS_ASSUME_NONNULL_END
