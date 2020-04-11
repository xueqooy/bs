//
//  CommentModel.h
//  smartapp
//
//  Created by lafang on 2018/8/28.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "TCUserInfo.h"

@interface CommentModel : FEBaseModel

@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *commentInfo;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *thumbUpNum;
@property (nonatomic, strong) NSNumber *myThumbUpRefId;
@property (nonatomic, strong) NSNumber *subCommentNum;
@property (nonatomic, strong) TCUserInfo *userData;//弃用
@property (nonatomic, strong) CommentModel *firstSubComment;
@property (nonatomic, strong) BSUser *user;

//custom
@property (nonatomic, copy) NSString *cacheUniqueKey;
@property (nonatomic) BOOL alreadyThumbUp;



@end
