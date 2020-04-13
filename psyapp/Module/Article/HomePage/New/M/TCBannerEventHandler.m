//
//  TCBannerEventHandler.m
//  CheersgeniePlus
//
//  Created by mac on 2020/4/4.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCBannerEventHandler.h"
#import "TCBannerModel.h"
#import "QSWebViewBaseController.h"
#import "ArticleDetailViewController.h"
//#import "FECourseDetailViewController.h"
//#import "TCTestDetailViewController.h"
#import "ProfessionalViewController.h"
#import "FEOccupationLibViewController.h"
#import "UniversityListViewController.h"
@implementation TCBannerEventHandler
+ (void)handleBannerClickForBanner:(TCBannerModel *)banner viewController:(nonnull UIViewController *)viewController{
 
    UIViewController *targetViewController;
    
    if(banner.type.integerValue== BSBannerTypeArticle){ //文章
//        AVQuery *query = [AVQuery queryWithClassName:@"Article"];
//        [query whereKey:@"objectId" equalTo:banner.value];
//        AVObject *object = [query getFirstObject];
//        ArticleDetailViewController *vc = [[ArticleDetailViewController alloc] init];
//        vc.articleId = banner.value;
//        targetViewController = vc;
//        umEventLabel = @"article";
    } else if (banner.type.integerValue == BSBannerTypeTab){
        [self switchToTabAtIndex:banner.value.integerValue];
    } else if (banner.type.integerValue == BSBannerTypeUniversity) {
      
    } else if(banner.type.integerValue == BSBannerTypeMajor) {
       
        
    } else if (banner.type.integerValue == BSBannerTypeOccupation){
        
    } else if (banner.type.integerValue == BSBannerTypeLink) {
        NSString *URLString = banner.value;
        QSWebViewBaseController *qsWeb  = [[QSWebViewBaseController alloc] init];
        qsWeb.title = banner.describe;;
        qsWeb.url = URLString;
        targetViewController = qsWeb;
    } else if (banner.type.integerValue == BSBannerTypeLib) {
        [self gotoLibAtIndex:banner.value.integerValue currentViewController:viewController];
    } else if (banner.type.integerValue == BSBannerTypeOccupationArea) {
        FEOccupationLibViewController *vc = FEOccupationLibViewController.new;
        vc.areaName = banner.value;
        [viewController.navigationController pushViewController:vc animated:YES];
        targetViewController = vc;
    }
    
    if (targetViewController) {
        [viewController.navigationController pushViewController:targetViewController animated:YES];
    }
    
}

+ (void)gotoLibAtIndex:(NSInteger)idx currentViewController:(UIViewController *)viewController{
    if (idx == 0) {
        UniversityListViewController *vc = UniversityListViewController.new;
        [viewController.navigationController pushViewController:vc animated:YES];
    } else if (idx == 1) {
        ProfessionalViewController *vc = ProfessionalViewController.new;
        [viewController.navigationController pushViewController:vc animated:YES];
    } else if (idx == 2) {
        FEOccupationLibViewController *vc = FEOccupationLibViewController.new;
        [viewController.navigationController pushViewController:vc animated:YES];
    }
}

+ (void)switchToTabAtIndex:(NSInteger)idx {
    if (idx >= 0 && idx < 4) {
        NSDictionary *info = @{@"tab_index": @(idx).stringValue};
        [NSNotificationCenter.defaultCenter postNotificationName:nc_main_tab_switch object:info];
    }
}
@end
