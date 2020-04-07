//
//  LoginInfoPerfectionView.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/12.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoginInfoPerfectionView : UIView
@property (nonatomic, strong) PIModel *userInfo;
@property (nonatomic, copy) NSString *existingNickname;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
