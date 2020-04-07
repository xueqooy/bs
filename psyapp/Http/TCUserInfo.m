//
//  TCUserInfo.m
//  CheersgeniePlus
//
//  Created by mac on 2020/2/10.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCUserInfo.h"

@implementation TCUserInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"userId" : @"user_id",
        @"nickname" : @"nick_name",
        @"avatar" : @"avatar"
    };
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.userId forKey:@"user_id"];
    [coder encodeObject:self.nickname forKey:@"nick_name"];
    [coder encodeObject:self.avatar forKey:@"avatar"];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.userId = [coder decodeObjectForKey:@"user_id"];
        self.avatar = [coder decodeObjectForKey:@"avatar"];
        self.nickname = [coder decodeObjectForKey:@"nick_name"];
    }
    return self;
}

@end

@implementation TCChildInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"childId" : @"child_id",
        @"childName" : @"child_name",
        @"sex" : @"sex",
        @"birthday" : @"birthday",
        @"gradeName" : @"grade_name",
        @"period" : @"period",
        @"schoolId" : @"schoolId",
    };
}



- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.childId forKey:@"child_id"];
    [coder encodeObject:self.childName forKey:@"child_name"];
    [coder encodeObject:self.sex forKey:@"sex"];
    [coder encodeObject:self.birthday forKey:@"birthday"];
    [coder encodeObject:self.gradeName forKey:@"grade_name"];
    [coder encodeObject:self.period forKey:@"period"];
    [coder encodeObject:self.schoolId forKey:@"school_id"];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.childId = [coder decodeObjectForKey:@"child_id"];
        self.childName = [coder decodeObjectForKey:@"child_name"];
        self.birthday = [coder decodeObjectForKey:@"birthday"];
        self.gradeName = [coder decodeObjectForKey:@"grade_name"];
        self.sex = [coder decodeObjectForKey:@"sex"];
        self.period = [coder decodeObjectForKey:@"period"];
        self.schoolId = [coder decodeObjectForKey:@"school_id"];
    }
    return self;
}

- (TCPeriodStage)periodStage {
    TCPeriodStage stage = TCPeriodStageKindergarten;
    NSString *period = self.period;
    NSString *grade = self.gradeName;
    if ([period isEqualToString:@"幼儿园"]) {
        stage = TCPeriodStageKindergarten;
    } else if ([period isEqualToString:@"小学"]){
        if ([grade isEqualToString:@"一年级"]) {
            stage = TCPeriodStagePrimary13;
        } else if ([grade isEqualToString:@"二年级"]) {
            stage = TCPeriodStagePrimary13;
        } else if ([grade isEqualToString:@"三年级"]) {
            stage = TCPeriodStagePrimary13;
        } else if ([grade isEqualToString:@"四年级"]) {
            stage = TCPeriodStagePrimary46;
        } else if ([grade isEqualToString:@"五年级"]) {
            stage = TCPeriodStagePrimary46;
        } else if ([grade isEqualToString:@"六年级"]) {
            stage = TCPeriodStagePrimary46;
        }
    } else if ([period isEqualToString:@"初中"]) {
        stage = TCPeriodStageMiddle;
    } else if ([period isEqualToString:@"高中"]) {
        stage = TCPeriodStageHigh;
    }
    return stage;

}
@end

@implementation TCChildrenInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"items" : @"items",
    };
}

+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:TCChildInfo.class];
}

- (NSInteger)total {
    return self.items.count;
}



@end
