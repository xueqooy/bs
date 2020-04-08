//
//  DegreesModel.h
//  smartapp
//
//  Created by lafang on 2019/3/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "DegreesRankingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DegreesModel : FEBaseModel

//"code": "benke",
//"name": "本科",
//"ranking_items": [{

@property(nonatomic,strong) NSString *code;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSArray *rankingItems;

@end

NS_ASSUME_NONNULL_END
