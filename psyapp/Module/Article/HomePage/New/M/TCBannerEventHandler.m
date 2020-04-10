//
//  TCBannerEventHandler.m
//  CheersgeniePlus
//
//  Created by mac on 2020/4/4.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCBannerEventHandler.h"
#import "TCBannerModel.h"
//#import "FEAppURLHandler.h"

#import "ArticleDetailViewController.h"
//#import "FECourseDetailViewController.h"
//#import "TCTestDetailViewController.h"

@implementation TCBannerEventHandler
+ (void)handleBannerClickForBanner:(TCBannerModel *)banner viewController:(nonnull UIViewController *)viewController{
    NSString *umEventLabel, *umEventFromId, *umEventFromName, *umEventToId;
    umEventFromId = banner.uniqueId.stringValue;
    umEventFromName = banner.describe;
    umEventToId = banner.value;
    
    UIViewController *targetViewController;
    
//    if(banner.type.integerValue== TCBannerTypeArticle){ //文章
//        ArticleDetailViewController *vc = [[ArticleDetailViewController alloc] init];
//        vc.articleId = banner.value;
//        targetViewController = vc;
//        umEventLabel = @"article";
//    }else if (banner.type.integerValue == TCBannerTypeTab){
//        [self switchToTabAtIndex:banner.value.integerValue];
//        umEventLabel = @"tab";
//    } else if (banner.type.integerValue == TCBannerTypeCourse) { //课程详情
//        NSString *courseId = banner.value;
//        if (![NSString isEmptyString:courseId]) {
//            FECourseDetailViewController *vc = [[FECourseDetailViewController alloc] initWithCourseId:courseId];
//            targetViewController = vc;
//        } else {
//            [self switchToTabAtIndex:1];
//        }
//        umEventLabel = @"course";
//    } else if(banner.type.integerValue == TCBannerTypeTest) { //测评详情
//        NSString *dimensionId = banner.value;
//        if (![NSString isEmptyString:dimensionId]) {
//            TCTestDetailViewController *vc = [[TCTestDetailViewController alloc] initWithDimensionId:dimensionId];
//            targetViewController = vc;
//        } else {
//           [self switchToTabAtIndex:2];
//        }
//        
//        umEventLabel = @"dimension";
//    } else if (banner.type.integerValue == TCBannerTypeURL) { //链接
//        NSString *URLString = banner.value;
//        [FEAppURLHandler handleWithURL:[NSURL URLWithString:URLString]];
//    }
    
    if (targetViewController) {
        [viewController.navigationController pushViewController:targetViewController animated:YES];
    }
    
}

+ (void)switchToTabAtIndex:(NSInteger)idx {
    if (idx >= 0 && idx < 4) {
        NSDictionary *info = @{@"tab_index": @(idx).stringValue};
        [NSNotificationCenter.defaultCenter postNotificationName:nc_main_tab_switch object:info];
    }
}
@end
