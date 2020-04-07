//
//  PATestCategoryManager.h
//  psyapp
//
//  Created by mac on 2020/3/14.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCCategroyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PATestCategoryManager : NSObject
@property (nonatomic, weak, readonly) NSArray <NSString *>*stageNames;
@property (nonatomic, weak, readonly) NSArray <NSString *>*stageCodes;

+ (instancetype)sharedInstance;

- (NSString *)getCategoryIdForStageCode:(NSString *)stageCode categoryName:(NSString *)categoryName;

- (void)loadCategoriesOnSucess:(void(^)(void))success failure:(void(^)(void))failure;
@end

NS_ASSUME_NONNULL_END
