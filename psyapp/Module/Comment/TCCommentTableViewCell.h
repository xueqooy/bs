//
//  TCCommentTableViewCell.h
//  smartapp
//
//  Created by mac on 2019/7/26.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface TCCommentTableViewCell : UITableViewCell

@property (nonatomic, strong, nullable) CommentModel * model;

@property (nonatomic, assign) BOOL canCancelThumpUp; //YES by default
@property (nonatomic, assign) BOOL separatorHidden;

@property (nonatomic) BOOL replyDisabled;
@property (nonatomic) BOOL prefersReplyHidden;

@property (nonatomic, copy, nullable) void (^ replySuccessBlock)(void);
@end


