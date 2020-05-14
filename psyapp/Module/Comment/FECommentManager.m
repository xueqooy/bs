//
//  FECommentManager.m
//  smartapp
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FECommentManager.h"
#import "FECommentInputView.h"
#import "EvaluateService.h"
@interface FECommentManager ()
@property (nonatomic, strong) CommentRootMdoel *commentRootModel;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *heightArray;
@property (nonatomic, assign) BOOL hasLoadAll;
@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, assign) NSInteger page;
@end

@implementation FECommentManager

- (instancetype)initWithContentId:(NSString *)contentId type:(FECommentType)type{
    self = [super init];
    _type = type;
    _page = Page_CommentDataIsEmptyOrUnrquest;
    _onceRequestCount = 5;
    _contentId = contentId;
    return self;
}

- (void)setContentId:(NSString *)contentId {
    _contentId = contentId;
    [self resetData];
}

- (void)setType:(FECommentType)type {
    _type = type;
    [self resetData];
}

- (BOOL)hasLoadAll {
    return _commentRootModel.total <= _commentRootModel.items.count;
}

- (BOOL)isEmpty {
    return (_commentRootModel == nil) || (_commentRootModel.total == 0) || (_commentRootModel.items.count == 0);
}

- (NSArray<CommentModel *> *)commentModels {
    return _commentRootModel?_commentRootModel.items : nil;
}

- (NSInteger)count {
    return self.commentModels? self.commentModels.count : 0;
}

- (NSInteger)total {
    return self.commentRootModel.total;
}

-(void)loadCommentDataWithSuccess:(void (^)(void))success failure:(void (^)(void))failure{
    if ([NSString isEmptyString:_contentId]) return;
    
    if (self.isEmpty) {
        _commentRootModel = [CommentRootMdoel new];
        _commentRootModel.items = @[].mutableCopy;
        _page = Page_CommentDataIsEmptyOrUnrquest;
    }
    
    _page ++;
    //第一次请求page = 1;
    AVQuery *commentQuery = [AVQuery queryWithClassName:@"Comment"];
    if (_page == 1) {
        self.commentRootModel.total = [commentQuery countObjects];
    }
    commentQuery.limit = _onceRequestCount;
    commentQuery.skip = (_page - 1) * _onceRequestCount;
    [commentQuery orderByDescending:@"thumpUp"];
    [commentQuery whereKey:@"targetId" equalTo:self.contentId];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            self->_page --;
            [HttpErrorManager showErorInfo:error];
            if (failure) failure();
        } else {
            for (AVObject *object in objects) {
                CommentModel *comment = [[CommentModel alloc] initWithAVObject:object];
                [self.commentRootModel.items addObject:comment];
            }
            if (success) success();
        }
    }];
}

- (void)commitComment:(NSString *)comment completion:(CommentResultBlock)completion{
    [FECommentManager commitComment:comment type:self.type forContentId:self.contentId completion:completion];
}

- (void)setComputer:(id<FECommentContentHeightCompution>)computer {
    _computer = computer;
    _heightArray = @[].mutableCopy;
}

- (CGFloat)heightForCommentContentAtIndex:(NSInteger)index {
    if (_computer == nil || _heightArray == nil || _heightArray.count == 0) return 0;
    if (index < 0 || index > _heightArray.count - 1) return 0;
    
    return _heightArray[index].floatValue;
}


- (void)resetData {
    _page = Page_CommentDataIsEmptyOrUnrquest;
    _commentRootModel = nil;
    _heightArray = nil;
}

+ (void)commitComment:(NSString *)comment type:(FECommentType)type forContentId:(NSString *)contentId completion:(CommentResultBlock) completion{
    NSArray *bans = @[@"傻", @"笨蛋", @"愚蠢", @"恶心", @"SB", @"麻痹", @"智障", @"共产党", @"尼玛", @"全家死", @"你妈", @"死", @"白痴", @"贱货", @"滚"];
    for (NSString *ban in bans) {
        if ([comment containsString:ban]) {
            [QSToast toastWithMessage:@"评论中包含违禁词，不允许发布"];
             if (completion) completion(NO, nil);
            return;
        }
    }
    if ([comment containsString:@"傻子"])
    
    if ([NSString isEmptyString:contentId]) {
        [QSToast toastWithMessage:@"评论对象缺失"];
        if (completion) completion(NO, nil);
        return;
    }
    
    if ([NSString isEmptyString:comment]) {
        [QSToast toastWithMessage:@"评论内容不能为空"];
        if (completion) completion(NO, nil);
        return;
    }
    
    [QSLoadingView show];
    AVObject *object = [AVObject objectWithClassName:@"Comment"];
    [object setObject:contentId forKey:@"targetId"];
    [object setObject:comment forKey:@"content"];
    [object setObject:BSUser.currentUser forKey:@"user"];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [QSLoadingView dismiss];
        if (succeeded) {
            CommentModel *model = [[CommentModel alloc] initWithAVObject:object];
            if (completion) completion(YES, model);

            if (type == FECommentTypeReply) {
                AVObject *rootComment = [AVObject objectWithClassName:@"Comment" objectId:contentId];
                [rootComment fetchInBackgroundWithBlock:^(AVObject * _Nullable _object, NSError * _Nullable error) {
                    if (_object) {
                        [_object setObject:object forKey:@"firstSubComment"];
                        [_object incrementKey:@"subCommentNum"];
                        [_object saveInBackground];
                    }
                }];
                
            }
        } else {
            [HttpErrorManager showErorInfo:error];
            if (completion) completion(NO, nil);
        }
    }];

}

+ (void)prepareToReplyCommentId:(NSString *)commentId  nickName:(NSString *)nickname completion:(CommentResultBlock)completion {
    FECommentInputView *commentView = [[FECommentInputView alloc] init];
    commentView.placeholder = nickname? [NSString stringWithFormat:@"回复 %@", nickname] : @"回复";
    
    commentView.result = ^(NSString *inputText,BOOL isSure) {
        if(isSure){
            [self commitComment:inputText type:FECommentTypeReply forContentId:commentId completion:completion];
        }
    };
    [commentView show];
}
@end
