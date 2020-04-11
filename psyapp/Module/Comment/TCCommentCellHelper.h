//
//  TCCommentCellHelper.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/23.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCCommentTableViewCell;
@class CommentModel;
NS_ASSUME_NONNULL_BEGIN

@interface TCCommentCellHelper : NSObject
- (instancetype)initWithCell:(TCCommentTableViewCell *)cell;

- (void)reply;
- (void)moreWithRepliedBlock:(void(^)(void))repliedBlock;
- (void)thumbUp:(CommentModel *)model completion:(void(^)(BOOL success))completion;
@end

NS_ASSUME_NONNULL_END
