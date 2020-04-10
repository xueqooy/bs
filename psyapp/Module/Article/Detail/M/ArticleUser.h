//
//  ArticleUser.h
//  smartapp
//
//  Created by lafang on 2018/8/25.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"

@interface ArticleUser : FEBaseModel

@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *avatar;

@end
