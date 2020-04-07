//
//  TCCategoryService.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/3.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCCategoryService.h"

@implementation TCCategoryService
+ (void)getStageConfigOnSuccess:(success)success failure:(failure)failure {
    NSString *URLString = [UGTool replacingStrings:@[@"{realm}"] withObj:@[@"stage"] forURL:TC_URL_GET_CATEGORY_SYSTEM_CONFIG];
    [QSRequestBase get:URLString success:success failure:failure];
}

+ (void)getCategoriesByStage:(NSInteger)stage type:(TCCategoryType)type OnSuccess:(success)success failure:(failure)failure {
    NSString *URLString = [UGTool replacingStrings:@[@"{stage}", @"{type}"] withObj:@[@(stage), @(type)] forURL:TC_URL_GET_CATEGORY_TREE];
    [QSRequestBase get:URLString success:success failure:failure];
}
@end
