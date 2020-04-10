//
//  CommentModel.m
//  smartapp
//
//  Created by lafang on 2018/8/28.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"commentId":@"id",
             @"commentInfo":@"comment_info",
             @"createTime":@"create_time",
             @"type":@"type",
             @"userData":@"user_data",
             @"thumbUpNum" : @"thumb_up_num",
             @"myThumbUpRefId" : @"my_thumb_up_ref_id",
             @"subCommentNum" : @"sub_comment_num",
             @"firstSubComment" : @"first_sub_comment"
             };
}

+ (NSValueTransformer *)userDataJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:TCUserInfo.class];
    
}


- (NSString *)cacheUniqueKey {
    if (self.subCommentNum == nil || self.firstSubComment == nil || self.subCommentNum.integerValue <= 0) {
        return self.commentId;
    } else {
        return [NSString stringWithFormat:@"%@_%@", self.commentId, self.subCommentNum];
    }
}

- (BOOL)alreadyThumbUp {
    if (self.myThumbUpRefId == nil) return NO;
    if ([self.myThumbUpRefId isEqualToNumber:@0]) {
        return NO;
    }
    return YES;
}

- (void)setAlreadyThumbUp:(BOOL)alreadyThumbUp {
    if (alreadyThumbUp) {
        self.myThumbUpRefId = @1;
    } else {
        self.myThumbUpRefId = @0;
    }
}
@end
