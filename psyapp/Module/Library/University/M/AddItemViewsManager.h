//
//  AddItemViewsManager.h
//  smartapp
//
//  Created by lafang on 2019/3/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ProfessionalIntroducesModel.h"
#import "ProfessionalCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddItemViewsManager : NSObject

+ (UIView *)addCommenTitleView:(UIView *)superView title:(NSString *)title;

+ (void)addContentItems:(UIView *)superView arrayData:(NSArray<ProfessionalIntroducesModel *> *)array;

+ (void)addProfessionalItems:(UIView *)superView arrayData:(NSArray<ProfessionalCategoryModel *> *)array;

@end

NS_ASSUME_NONNULL_END
