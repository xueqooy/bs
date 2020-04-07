//
//  BSUser.m
//  psyapp
//
//  Created by mac on 2020/4/7.
//  Copyright © 2020 cheersmind. All rights reserved.
//

#import "BSUser.h"

@implementation BSUser
@dynamic nickname;
@dynamic realName;
@dynamic gender;
@dynamic gradeNum;
@dynamic avatar;
+ (NSString *)parseClassName {
    return @"_User";
}

- (NSString *)gradeName {
    if ([self.gradeNum isEqualToNumber:@10]) {
        return @"高一";
    } else if ([self.gradeNum isEqualToNumber:@11]) {
        return @"高二";
    } else if ([self.gradeNum isEqualToNumber:@12]) {
        return @"高三";
    }
    return nil;
}
@end
