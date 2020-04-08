//
//  ProfessionalZhuankeView.h
//  smartapp
//
//  Created by lafang on 2019/3/10.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfessionalRootModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^CommonBlock)(NSInteger index);

@interface ProfessionalZhuankeView : UIView

-(instancetype)initWithController:(FEBaseViewController *)controller;

@property(nonatomic,strong)CommonBlock commonBlock;

@end

NS_ASSUME_NONNULL_END
