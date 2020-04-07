//
//  BSUser.h
//  psyapp
//
//  Created by mac on 2020/4/7.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
NS_ASSUME_NONNULL_BEGIN

@interface BSUser : AVUser <AVSubclassing>
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSNumber *gradeNum;
@property (nonatomic, strong) AVFile *avatar;

@property (nonatomic, copy, readonly) NSString *gradeName;
@end

NS_ASSUME_NONNULL_END
