//
//  FEOccupationDataManager.m
//  smartapp
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEOccupationDataManager.h"
#import "CareerService.h"
#import "HttpErrorManager.h"

@interface FEOccupationDataManager ()
@property (nonatomic, strong) NSMutableArray <OccupationTypeModel *>*industryGatalogData;
@property (nonatomic, strong) NSMutableArray *industryData;
@property (nonatomic, assign) NSInteger industrypage;



@property (nonatomic, strong) NSMutableArray <OccupationTypeModel *>*professionGatalogData;
@property (nonatomic, strong) NSMutableArray *professionData;
@property (nonatomic, assign) NSInteger professionPage;
@end

@implementation FEOccupationDataManager
+ (instancetype)sharedManager {
    static FEOccupationDataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
    });
    return manager;
}

- (void)loadIndustryGatalogDataWithSuccess:(void(^)(void))success ifFailure:(void(^)(void))failure; {
    [self p_loadGatalogDataWithType:2 WithSuccess:success ifFailure:failure];
}

- (void)loadProfessGatalogDataWithSuccess:(void(^)(void))success ifFailure:(void(^)(void))failure; {
    [self p_loadGatalogDataWithType:1 WithSuccess:success ifFailure:failure];
}


- (void)loadLevel2DataForTreeModel:(FEOccupationTreeModel *)treeModel type:(NSInteger)type WithSuccess:(void (^)(NSMutableArray<FEOccupationTreeModel *> *))success ifFailure:(void (^)(void))failure {
    [self p_loadLevel2DataForTreeModel:treeModel type:type WithSuccess:success ifFailure:failure];
}



- (void)p_loadLevel2DataForTreeModel:(FEOccupationTreeModel *)treeModel type:(NSInteger)type WithSuccess:(void (^)(NSMutableArray<FEOccupationTreeModel *> * ))success ifFailure:(void (^)(void))failure {
  
    [QSLoadingView show];
    NSString *category, *areaID;
    if (type == 2) {
        category = treeModel.name;
        areaID = @"";
    } else {
        category = @"";
        areaID = treeModel.ID;
    }
    
    [CareerService getOccupationsByCategory:category areaId:areaID occupationName:@"" page:1 size:149 success:^(id data) {
        [QSLoadingView dismiss];
        if(data){
            NSArray<ProfessionalOccupationsModel *> *dataModels = [MTLJSONAdapter modelsOfClass:ProfessionalOccupationsModel.class fromJSONArray:data[@"items"] error:nil];
            if(dataModels){
                _level2ItemsJustLoading = @[].mutableCopy;
                for (ProfessionalOccupationsModel *model in dataModels) {
                    FEOccupationTreeModel *item = [FEOccupationTreeModel dataObjectWithName:model.occupationName children:nil parent:treeModel ID:[NSString stringWithFormat:@"%@", model.occupationId]];
                    [_level2ItemsJustLoading addObject:item];
                }
                treeModel.children = _level2ItemsJustLoading;
                success(_level2ItemsJustLoading);
            } else {
                success(nil);
            }

        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:[UIApplication sharedApplication].keyWindow];
        if (failure) {
            failure();
        }
       
    }];
}

//type  1:职业分类 2:行业分类
- (void)p_loadGatalogDataWithType:(NSInteger)type WithSuccess:(void(^)(void))success ifFailure:(void(^)(void))failure {
    [QSLoadingView show];
    [CareerService getOccupationsCategory:[NSString stringWithFormat:@"%ld",(long)type] success:^(id data) {
        [QSLoadingView dismiss];
        if(data){
            NSArray<OccupationTypeModel *> *dataModels = [MTLJSONAdapter modelsOfClass:OccupationTypeModel.class fromJSONArray:data[@"items"] error:nil];
            if(dataModels){
                if(type == 1){
                    _professionGatalogData = @[].mutableCopy;
                    [_professionGatalogData addObjectsFromArray:dataModels];
                    [self p_creatTreeItemsWithData:_professionGatalogData forType:1];
                }else{
                    _industryGatalogData = @[].mutableCopy;
                    [_industryGatalogData addObjectsFromArray:dataModels];
                    [self p_creatTreeItemsWithData:_industryGatalogData forType:2];

                }
            }
            success();
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:[UIApplication sharedApplication].keyWindow];
        if (failure) {
            failure();
        }
    }];
}

//type  1:职业分类 2:行业分类
- (void)p_creatTreeItemsWithData:(NSMutableArray <OccupationTypeModel *>*)data forType:(NSInteger)type {
    if (data == nil || data.count == 0) {
        return;
    }
    NSMutableArray *tempItems;
    if (type == 2) {
        _industryTreeItems = @[].mutableCopy;
        tempItems = _industryTreeItems;
    } else {
        _professionTreeItems = @[].mutableCopy;
        tempItems = _professionTreeItems;
    }
    for (OccupationTypeModel *aModel in data) {
        NSMutableArray *subItems = @[].mutableCopy;
        NSString *name;
        if (type == 2) {
            name = aModel.realm;
        } else {
            name = aModel.personalityType;
        }
        FEOccupationTreeModel *item = [FEOccupationTreeModel dataObjectWithName:name children:nil parent:nil ID:nil];
        for (OccupationTypeItemModel *subModel in aModel.subItems) {
            NSString *name, *ID;
            if (type == 2) {
                name = subModel.category;
                ID = nil;
            } else {
                name = subModel.areaName;
                ID = [NSString stringWithFormat:@"%@",subModel.areaId] ;
            }
            FEOccupationTreeModel *subItem = [FEOccupationTreeModel dataObjectWithName:name children:nil parent:item ID:ID];
            [subItems addObject:subItem];
        }
        [item setChildren:subItems];
        
        [tempItems addObject:item];
    }
}


//搜素
- (void)searchWithKeyName:(NSString *)keyName andSuccess:(void(^)(BOOL isEmpty))success ifFailure:(void(^)(void))failure {

    [QSLoadingView show];
    NSString *key = [keyName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [CareerService getOccupationsByCategory:@"" areaId:@"" occupationName:key page:1 size:149 success:^(id data) {
        [QSLoadingView dismiss];
        if(data){
            NSArray<ProfessionalOccupationsModel *> *dataModels = [MTLJSONAdapter modelsOfClass:ProfessionalOccupationsModel.class fromJSONArray:data[@"items"] error:nil];
            if(dataModels){
                _searchData = dataModels;
                if (dataModels.count > 0) {
                    success(NO);
                } else {
                    success(YES);
                }
            }
        }
    } failure:^(NSError *error) {
        self->_searchData = nil;
        [QSLoadingView dismiss];
        [HttpErrorManager showErorInfo:error showView:[UIApplication sharedApplication].keyWindow];
        failure();
    }];
}


- (FEOccupationTreeModel *)getTreeModelWithAreaID:(NSString *)areaID areaName:(NSString *)areaName {

    if (_professionTreeItems) {
        for (FEOccupationTreeModel *level0TreeModel in _professionTreeItems) {
            NSArray *childTreeModels = level0TreeModel.children;
            if (childTreeModels) {
                for (FEOccupationTreeModel *level1TreeModel in childTreeModels) {
                    if (areaName) {
                        if ([level1TreeModel.name containsString:areaName]) {
                            NSLog(@"%@, %@", level1TreeModel.name, level1TreeModel.ID);
                            return level1TreeModel;
                        }
                    }
                    
                }
            }
        }
    }

    return nil;
}
@end
