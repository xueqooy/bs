//
//  PIModel.m
//  smartapp
//
//  Created by mac on 2019/11/2.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "PIModel.h"
#import "PICommonInfo.h"

@implementation PIModel
+ (instancetype)modelWithGuardian:(NSString *)guardian
                     name:(NSString *)name
                     nick:(NSString *)nick
                 birthDay:(NSString *)birthDay
                   gender:(NSNumber *)gender {
    PIModel *model = [PIModel new];
    model.invitationCode = nil;
    model.grade = nil;
    model.guardian = guardian;
    model.name = name;
    model.nick = nick;
    model.birthDay = birthDay;
    model.gender = gender;
    return model;
}

+ (instancetype)modelWithName:(NSString *)name
                 nick:(NSString *)nick
             birthDay:(NSString *)birthDay
                       gender:(NSNumber *)gender {
    return [self modelWithGuardian:@"" name:name nick:nick birthDay:birthDay gender:gender];
}

+ (instancetype)modelWithNick:(NSString *)nick
             birthDay:(NSString *)birthDay
                       gender:(NSNumber *)gender {
    return [self modelWithGuardian:@"" name:@"" nick:nick birthDay:birthDay gender:gender];
}

+ (instancetype)modelWithGuardian:(NSString *)guardian
                     nick:(NSString *)nick
                 birthDay:(NSString *)birthDay
                           gender:(NSNumber *)gender {
    return [self modelWithGuardian:guardian name:@"" nick:nick birthDay:birthDay gender:gender];
}

- (void)setGrade:(id)grade {
    if (grade == nil) return;
    if ([grade isKindOfClass:[NSString class]]) {
        NSString *gradeName = (NSString *)grade;
        NSNumber *gradeID;
        if ([gradeName isEqualToString:PILittle1]) {
            gradeID = @(21);
        } else if ([gradeName isEqualToString:PILittle2]) {
            gradeID = @(22);
        } else if ([gradeName isEqualToString:PILittle3]) {
            gradeID = @(23);
        } else if ([gradeName isEqualToString:PIMiddle1]) {
            gradeID = @(1);
        } else  if ([gradeName isEqualToString:PIMiddle2]) {
            gradeID = @(2);
        } else  if ([gradeName isEqualToString:PIMiddle3]) {
            gradeID = @(3);
        } else if ([gradeName isEqualToString:PIMiddle4]) {
            gradeID = @(4);
        } else if ([gradeName isEqualToString:PIMiddle5]) {
            gradeID = @(5);
        } else  if ([gradeName isEqualToString:PIMiddle6]) {
            gradeID = @(6);
        } else if ([gradeName isEqualToString:PIMiddle7]) {
            gradeID = @(7);
        } else if ([gradeName isEqualToString:PIMiddle8]) {
            gradeID = @(8);
        } else  if ([gradeName isEqualToString:PIMiddle9]) {
            gradeID = @(9);
        } else if ([gradeName isEqualToString:PIMiddle10]) {
            gradeID = @(10);
        } else  if ([gradeName isEqualToString:PIMiddle11]) {
            gradeID = @(11);
        } else if ([gradeName isEqualToString:PIMiddle12]) {
            gradeID = @(12);
        } else {
            gradeID = nil;
        }
        _grade = gradeID;
        return;
    }
    _grade = grade;
}

- (void)setGuardian:(id)guardian {
    if (guardian == nil) return;
       if ([guardian isKindOfClass:[NSString class]]) {
           NSString *guardianName = (NSString *)guardian;
           NSNumber *guardianID;
           if ([guardianName isEqualToString:PIGuardianFather]) {
               guardianID = @(1);
           } else if ([guardianName isEqualToString:PIGuardianMother]) {
               guardianID = @(2);
           } else if ([guardianName isEqualToString:PIGuardianGrandFather]) {
               guardianID = @(3);
           } else if ([guardianName isEqualToString:PIGuardianGrandMother]) {
               guardianID = @(4);
           } else  if ([guardianName isEqualToString:PIGuardianOther]) {
               guardianID = @(99);
           } else {
               guardianID = nil;
           }
           _guardian = guardianID;
           return;
       }
       _guardian = guardian;
}
@end
