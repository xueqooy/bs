//
//  TCDeviceAccount.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/26.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCAccountProtocol.h"

@interface TCDeviceAccount : NSObject <UCAccountProtocol>
@property (nonatomic, strong) TCUserInfo *userInfo;
@property (nonatomic, strong) TCChildrenInfo *children;
@property (nonatomic, weak) TCChildInfo *currentChild;
@property (nonatomic, copy) NSString *loginName;  //UUID
@property (nonatomic,strong)NSString *careerChildExamId;

@property (nonatomic,copy) NSString *accessToken;
@property (nonatomic,copy) NSString *refreshToken;
@property (nonatomic,copy) NSString *serverTime;
@property (nonatomic, copy) NSString *tokenExpiresIn;
@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign, readonly) BOOL alreadyPecfectInfo;


+ (instancetype)deviceAccount;
@end

