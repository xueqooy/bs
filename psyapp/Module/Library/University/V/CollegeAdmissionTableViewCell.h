//
//  CollegeAdmissionTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/4/1.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversityAdminsionModel.h"
#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^CommonBlock)(NSInteger index);

@interface CollegeAdmissionTableViewCell : UITableViewCell

-(void)updateModel:(NSArray<UniversityAdminsionModel *> *)models curProvince:(NSString *)curProvince curKind:(NSString *)curKind;

@property(nonatomic,strong)CommonBlock filterCallBack;

@end

NS_ASSUME_NONNULL_END
