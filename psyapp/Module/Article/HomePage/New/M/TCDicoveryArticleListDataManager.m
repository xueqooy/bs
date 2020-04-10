//
//  TCDicoveryArticleListDataManager.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/29.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCDicoveryArticleListDataManager.h"
#import "TCCategroyModel.h"
#import "TCHTTPService.h"
@implementation TCDicoveryArticleListDataManager
- (void)getArticleCategoryOnSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    NSMutableArray *temp = @[].mutableCopy;
    
    AVQuery *query = [AVQuery queryWithClassName:@"ArticleCategory"];
    [query whereKeyExists:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error == nil) {
            for (AVObject *object in objects) {
                NSString *name = [object objectForKey:@"name"];
                TCCategroyModel *category = TCCategroyModel.new;
                category.name = name;
                [temp addObject:category];
            }
           

            self.categories = temp.copy;
            if (success) success();
        } else {
            if (failure) failure();
        }
    }];
}
@end
