//
//  ProfessionalAdmissionTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/4/1.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfessionalAdminsionModel.h"
#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^CommonBlock)(NSInteger index);

@interface ProfessionalAdmissionTableViewCell : UITableViewCell

-(void)updateModel:(NSArray<ProfessionalAdminsionModel *> *)models curProvince:(NSString *)curProvince curYear:(NSString *)curYear curKind:(NSString *)curKind;

@property(nonatomic,strong)CommonBlock filterCallBack;

@end

NS_ASSUME_NONNULL_END
