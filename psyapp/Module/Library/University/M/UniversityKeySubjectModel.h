//
//  UniversityKeySubjectModel.h
//  smartapp
//
//  Created by lafang on 2019/3/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniversityKeySubjectModel : FEBaseModel

//"type": "国家重点学科",
//"name": "一级学科国家重点学科",
//"total": 7,
//"items":

@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSNumber *total;
@property(nonatomic,strong)NSArray<NSString *> *items;

@end

NS_ASSUME_NONNULL_END
