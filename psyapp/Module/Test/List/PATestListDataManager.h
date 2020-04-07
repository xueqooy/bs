//
//  PATestListDataManager.h
//  psyapp
//
//  Created by mac on 2020/3/14.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPagedDataManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface PATestListDataManager : NSObject
@property (nonatomic, strong) TCPagedDataManager *list;
@property (nonatomic, copy) NSString *stageCode;
@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, assign) BOOL loaded;

- (void)getProductListOnSuccess:(nonnull void (^)(void))success failure:(nonnull void (^)(void))failure;
@end

NS_ASSUME_NONNULL_END
