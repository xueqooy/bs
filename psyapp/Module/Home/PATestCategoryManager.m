//
//  PATestCategoryManager.m
//  psyapp
//
//  Created by mac on 2020/3/14.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "PATestCategoryManager.h"
#import "TCCategoryService.h"
@interface PATestCategoryManager ()
@property (nonatomic, strong) NSArray <TCStageModel *>*stages;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSArray <TCCategroyModel *>*> *categoryDictionary;

@property (assign) NSInteger requetedCount;
@property (assign) BOOL loadFailed;
@property (nonatomic, copy) void (^successBlock)(void);
@property (nonatomic, copy) void (^failureBlock)(void);
@end

@implementation PATestCategoryManager
+ (instancetype)sharedInstance {
    static PATestCategoryManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

+ (instancetype)alloc {
    return [self sharedInstance];
}

- (void)loadCategoriesOnSucess:(void (^)(void))success failure:(void (^)(void))failure {
    _categoryDictionary = @{}.mutableCopy;
    self.loadFailed = NO;
    self.requetedCount = 0;
    self.failureBlock = failure;
    self.successBlock = success;
    @weakObj(self);
    [self loadStageOnSuccess:^{
        for (TCStageModel *stage in selfweak.stages) {
            [selfweak loadCategoriesForStageCode:stage.code];
        }
    } failure:^{
        if (failure) failure();
    }];
}

- (void)loadCategoriesForStageCode:(NSString *)stageCode {
    if ([NSString isEmptyString:stageCode]) {
        [self incrementRequestedCount];
        return;
    }
    if (_loadFailed) {
        [self incrementRequestedCount];
        return;
    }
    [TCCategoryService getCategoriesByStage:stageCode.integerValue type:TCCategoryTypeTest OnSuccess:^(id data) {
        NSArray *categories = [MTLJSONAdapter modelsOfClass:TCCategroyModel.class fromJSONArray:data[@"items"] error:nil];
        if (categories) {
            [self.categoryDictionary setObject:categories forKey:stageCode];
        }
        [self incrementRequestedCount];
    } failure:^(NSError *error) {
        [HttpErrorManager showErorInfo:error];
        self.loadFailed = YES;
        [self incrementRequestedCount];
        if (self.failureBlock) {
            self.failureBlock();
            self.failureBlock = nil;
        }
    }];
}

- (void)incrementRequestedCount {
    _requetedCount ++;
    if (self.requetedCount == self.stages.count && self.loadFailed == NO) {
        if (self.successBlock) {
            self.successBlock();
            self.successBlock = nil;
        }
    }
}

- (void)loadStageOnSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    [TCCategoryService getStageConfigOnSuccess:^(id data) {
        self.stages = [MTLJSONAdapter modelsOfClass:TCStageModel.class fromJSONArray:data[@"items"] error:nil];
        if (success) success();
    } failure:^(NSError *error) {
        [HttpErrorManager showErorInfo:error];
        if (failure) failure();
    }];
}

- (NSArray<NSString *> *)stageNames {
    NSMutableArray *temp = @[].mutableCopy;
    for (TCStageModel *stage in _stages) {
        if ([NSString isEmptyString:stage.name]) {
            if ([NSString isEmptyString:stage.remark]) {
                [temp addObject:@""];
            } else {
                [temp addObject:stage.remark];
            }
        } else {
            [temp addObject:stage.name];
        };
    }
    return temp;
}

- (NSArray<NSString *> *)stageCodes {
    NSMutableArray *temp = @[].mutableCopy;
    for (TCStageModel *stage in _stages) {
        if ([NSString isEmptyString:stage.code]) {
            [temp addObject:@""];
        } else {
            [temp addObject:stage.code];
        }
    }
    return temp;
}

- (NSString *)getCategoryIdForStageCode:(NSString *)stageCode categoryName:(NSString *)categoryName {
    if (_categoryDictionary == nil || stageCode == nil || categoryName == nil) return nil;
    NSArray *categories = [_categoryDictionary objectForKey:stageCode];
    for (TCCategroyModel *category in categories) {
        if ([category.name isEqualToString:categoryName]) {
            return category.Id;
        }
    }
    return nil;
}
@end
