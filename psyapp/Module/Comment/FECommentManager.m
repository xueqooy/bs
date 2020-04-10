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
    _onceRequestCount = 10;
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
    [EvaluateService articleCommentList:self.contentId type:self.type page:self.page size:self.onceRequestCount success:^(id data) {
        CommentRootMdoel *model = [MTLJSONAdapter modelOfClass:CommentRootMdoel.class fromJSONDictionary:data error:nil];
        if (model && model.items.count != 0) {
            [_commentRootModel.items addObjectsFromArray:model.items];
            _commentRootModel.total = model.total;
//            [self _markType];
            [self _computeHeight:model.items];
        }
        if (success) success();
    } failure:^(NSError *error) {
        _page --;
        [HttpErrorManager showErorInfo:error showView:mKeyWindow];
        if (failure) failure();
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

//- (void)_markType {
//    for (CommentModel *model in self.commentModels) {
//        model.type = self.type;
//    }
//}

- (void)_computeHeight:(NSArray <CommentModel*> *)commentModels {
    if (_computer && [_computer respondsToSelector:@selector(heightForComment:atIndex:)]) {
        if (_heightArray == nil) {
            _heightArray = @[].mutableCopy;
        }
        NSInteger beginIndex = self.count;
        for (int i = 0; i < commentModels.count; i ++) {
            CommentModel *item = commentModels[i];
            NSNumber *heightNumber = @([_computer heightForComment:item atIndex:beginIndex + i]);
            [_heightArray addObject:heightNumber];
        }
    }
}

+ (void)commitComment:(NSString *)comment type:(FECommentType)type forContentId:(NSString *)contentId completion:(CommentResultBlock) completion{
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
    [EvaluateService articleComment:contentId commentInfo:comment type:type success:^(id data) {
        [QSLoadingView dismiss];
        CommentModel *model = [MTLJSONAdapter modelOfClass:CommentModel.class fromJSONDictionary:data error:nil];
        if(model){
            if (completion) completion(YES, model);
        } else {
            if (completion) completion(NO, nil);
        }
    } failure:^(NSError *error) {
        [QSLoadingView dismiss];
        NSDictionary *errorDic = [HttpErrorManager showErorInfo:error];
        if([errorDic[@"code"] isEqualToString:@"PSY_COMMENT_TIME_INVALID"]){
            [QSToast toast:mKeyWindow message:@"评论过于频繁，等稍后再评论"];
            if (completion) completion(NO, nil);
        } else {
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
