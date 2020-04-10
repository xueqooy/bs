//
//  FEDiscussViewController.h
//  smartapp
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEBaseViewController.h"
#import "FECommentManager.h"

@interface FECommentViewController : FEBaseViewController
@property (nonatomic, copy) NSString *contentId;
@property (nonatomic) FECommentType type;
@property (nonatomic, copy) void (^commentCountChangedHandler)(NSInteger count);
- (instancetype)initWithContentId:(NSString *)contentId type:(FECommentType)type;

- (void)reloadData;

@property (nonatomic) BOOL commentDisabled;
@property (nonatomic, copy) void (^repliedBlock)(void);
@property (nonatomic, strong) CommentModel *commentModel;
- (instancetype)initWithCommentModel:(CommentModel *)commentModel;
@end

