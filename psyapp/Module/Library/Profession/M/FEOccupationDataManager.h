//
//  FEOccupationDataManager.h
//  smartapp
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OccupationTypeModel.h"
#import "OccupationTypeItemModel.h"
#import "ProfessionalOccupationsModel.h"
#import "FEOccupationTreeModel.h"


/**
 Catalog：目录 包括level0 和level1 ；数据一次性请求
 
 level2: 需要再次请求
 
 level2数据的请求，行业和职业分类的请求参数不同
 行业（type 2）category : category   areaID : @""    treeModel.name = category   .ID = nil
 职业 (type 1) category : @""       areaID : areaID  treeModel.name = areaName   .ID = areaID
 
 所以
    行业的类目名称和请求level2的参数都是category
    职业的类目名称是areaName，而请求level2的参数是areaID
 
 */

@interface FEOccupationDataManager : NSObject
@property (nonatomic, strong) NSMutableArray <FEOccupationTreeModel *>*industryTreeItems;

@property (nonatomic, strong) NSMutableArray <FEOccupationTreeModel *>*professionTreeItems;

@property (nonatomic, strong) NSMutableArray <FEOccupationTreeModel *>*level2ItemsJustLoading;//刚刚请求的3级数据

+ (instancetype)sharedManager;

//请求目录 :level0 level1
- (void)loadIndustryGatalogDataWithSuccess:(void(^)(void))success ifFailure:(void(^)(void))failure;
- (void)loadProfessGatalogDataWithSuccess:(void(^)(void))success ifFailure:(void(^)(void))failure;


//请求目录下的列表 :level2
- (void)loadLevel2DataForTreeModel:(FEOccupationTreeModel *)model type:(NSInteger)type WithSuccess:(void(^)(NSMutableArray <FEOccupationTreeModel *>*level2Items))success ifFailure:(void(^)(void))failure;



//----------------------------搜索相关------------------------------
@property (nonatomic, copy) NSArray <ProfessionalOccupationsModel *>*searchData;

- (void)searchWithKeyName:(NSString *)keyName andSuccess:(void(^)(BOOL isEmpty))success ifFailure:(void(^)(void))failure;


- (FEOccupationTreeModel *)getTreeModelWithAreaID:(NSString *)areaID areaName:(NSString *)areaName;
@end

