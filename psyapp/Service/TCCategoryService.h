//
//  TCCategoryService.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/3.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSRequestBase.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, TCCategoryType) {
    TCCategoryTypeArticle = 1, //发现文章
    TCCategoryTypeTest  = 2,
    TCCategoryTypeCourse = 4
};


@interface TCCategoryService : NSObject
//https://www.tapd.cn/22217601/markdown_wikis/#1122217601001001909@toc1
+ (void)getStageConfigOnSuccess:(success)success failure:(failure)failure;

//https://www.tapd.cn/22217601/markdown_wikis/#1122217601001001909@toc3
+ (void)getCategoriesByStage:(NSInteger)stage type:(TCCategoryType)type OnSuccess:(success)success failure:(failure)failure;
@end

NS_ASSUME_NONNULL_END
