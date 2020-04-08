//
//  EnrollmentNavigationModel.h
//  smartapp
//
//  Created by lafang on 2019/3/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "EnrollmentNavigationItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EnrollmentNavigationModel : FEBaseModel

//"name": "普通高考报考专区",
//"items": [{

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSArray *items;

@end

NS_ASSUME_NONNULL_END
