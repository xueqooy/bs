//
//  UCAccountProtocol.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/28.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UCAccountProtocol <NSObject>
@property (nonatomic, strong) TCUserInfo *userInfo;
@property (nonatomic, strong) TCChildrenInfo *children;
@property (nonatomic, weak) TCChildInfo *currentChild;//便于以后多孩子时修改
@property (nonatomic, copy) NSString *loginName;

@property (nonatomic,copy) NSString *accessToken;
@property (nonatomic,copy) NSString *refreshToken;
@property (nonatomic,copy) NSString *serverTime;
@property (nonatomic, copy) NSString *tokenExpiresIn;
@property (nonatomic, copy) NSString *code;
@property (nonatomic,strong)NSString *careerChildExamId;

@optional
- (void)resetData;
@end

NS_ASSUME_NONNULL_END
