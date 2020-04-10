//
//  FECommentManager.h
//  smartapp
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentRootMdoel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol FECommentContentHeightCompution <NSObject>

- (CGFloat)heightForComment:(CommentModel *)comment atIndex:(NSInteger)index;

@end

typedef enum FECommentType {
    FECommentTypeArticle = 0,
    FECommentTypeCourseDetail = 1,
    FECommentTypeTestDetail = 3,
    FECommentTypeReply = 4//评论的评论
} FECommentType;

typedef void(^CommentResultBlock)(BOOL success, CommentModel *_Nullable model);

#define Page_CommentDataIsEmptyOrUnrquest 0
@interface FECommentManager : NSObject
@property (nonatomic, assign) FECommentType type;
@property (nonatomic, strong) NSString *contentId;
@property (nonatomic, assign) NSUInteger onceRequestCount;

@property (nonatomic, strong, readonly) CommentRootMdoel *commentRootModel;
@property (nonatomic, copy,   readonly) NSArray <CommentModel *> *commentModels;
@property (nonatomic, assign, readonly) NSInteger count;
@property (nonatomic, assign, readonly) NSInteger total;

@property (nonatomic, assign, readonly) BOOL hasLoadAll;
@property (nonatomic, assign, readonly) BOOL isEmpty;
@property (nonatomic, assign, readonly) NSInteger page;
@property (nonatomic, weak) id <FECommentContentHeightCompution> computer;


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithContentId:(NSString *)contentId type:(FECommentType)type NS_DESIGNATED_INITIALIZER;

- (void)loadCommentDataWithSuccess:( void (^ _Nullable )(void))success failure:(void (^ __nullable)(void))failure;
- (void)commitComment:(NSString *)comment completion:(CommentResultBlock _Nullable)completion;
- (CGFloat)heightForCommentContentAtIndex:(NSInteger)index;
- (void)resetData;

+ (void)prepareToReplyCommentId:(NSString *)commentId nickName:(NSString *)nickname completion:(CommentResultBlock _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
