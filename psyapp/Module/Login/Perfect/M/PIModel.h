//
//  PIModel.h
//  smartapp
//
//  Created by mac on 2019/11/2.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PIModel : NSObject
@property (nonatomic, copy) NSString *invitationCode;
@property (nonatomic, copy) id grade;
@property (nonatomic, copy) id guardian;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *birthDay;
@property (nonatomic, copy) NSNumber *gender;

+ (instancetype)modelWithGuardian:(NSString *)guardian
                     name:(NSString *)name
                     nick:(NSString *)nick
                 birthDay:(NSString *)birthDay
                   gender:(NSNumber *)gender;

+ (instancetype)modelWithName:(NSString *)name
                 nick:(NSString *)nick
             birthDay:(NSString *)birthDay
               gender:(NSNumber *)gender;

+ (instancetype)modelWithNick:(NSString *)nick
             birthDay:(NSString *)birthDay
               gender:(NSNumber *)gender;

+ (instancetype)modelWithGuardian:(NSString *)guardian
                     nick:(NSString *)nick
                 birthDay:(NSString *)birthDay
                   gender:(NSNumber *)gender;


@end


