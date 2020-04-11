//
//  TCCommentCellHelper.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/23.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCCommentCellHelper.h"
#import "FECommentManager.h"
#import "TCHTTPService.h"

#import "UITableView+TCCommentAuthority.h"
#import "TCCommentTableViewCell.h"

#import "FECommentViewController.h"
@implementation TCCommentCellHelper {
    __weak TCCommentTableViewCell *_cell;
}

- (instancetype)initWithCell:(TCCommentTableViewCell *)cell {
    self = [super init];
    _cell = cell;
    return self;
}

- (void)reply {
    UITableView *tableView = _cell.qmui_tableView;
    if (tableView) {
        //根据业务，是否能够评论
        if (tableView.tc_commentDisabled) return;
    }
    
    if (_cell == nil) return;
    [FECommentManager prepareToReplyCommentId:_cell.model.commentId nickName:_cell.model.userData.nickname completion:^(BOOL success, CommentModel *model) {
        if (success) {
            //尽量只刷新改行cell
            if (model) {
                self->_cell.model.firstSubComment = model;
                NSInteger subCommentNum = self->_cell.model.subCommentNum? self->_cell.model.subCommentNum.integerValue : 0;
                if (subCommentNum>= 0) {
                    subCommentNum += 1;
                    self->_cell.model.subCommentNum = @(subCommentNum);
                }
                
                [self reloadIndexPathOfCell];
            }
            
            [QSToast toastWithMessage:@"回复成功"];
            if (self->_cell.replySuccessBlock) self->_cell.replySuccessBlock();
        }
    }];
}

- (void)reloadIndexPathOfCell {
    UITableView *locatedTabelView = _cell.qmui_tableView;
    if (locatedTabelView) {
        //获取indexPath
        NSIndexPath *indexPath = [locatedTabelView indexPathForCell:_cell];
        
        //刷新indexPath所在cell
        [locatedTabelView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)moreWithRepliedBlock:(void (^)(void))repliedBlock {
    UIViewController *visibleViewController = QMUIHelper.visibleViewController;
    if (visibleViewController.navigationController == nil) return;//暂时不考虑present
    FECommentViewController *commentViewController = [[FECommentViewController alloc] initWithCommentModel:_cell.model];
    commentViewController.repliedBlock = repliedBlock;
    UITableView *tableView = _cell.qmui_tableView;
    if (tableView) {
        //根据业务，是否能够评论
        if (tableView.tc_commentDisabled) {
            commentViewController.commentDisabled = YES;
        }
    }
    [visibleViewController.navigationController pushViewController:commentViewController animated:YES];
}

- (void)thumbUp:(CommentModel *)model completion:(void (^)(BOOL))completion{
    AVObject *object = [AVObject objectWithClassName:@"Comment" objectId:model.commentId];
    [object fetchInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        NSMutableArray <BSUser *>*users = [object objectForKey:@"thumpUpUsers"];
        if (users == nil) users = @[].mutableCopy;
        if (model.alreadyThumbUp == NO) {
            for (BSUser *user in users) {
                if([user.objectId isEqualToString:BSUser.currentUser.objectId]) {
                    [users removeObject:user];
                    break;
                }
            }
            [object setObject:users forKey:@"thumpUpUsers"];
            [object incrementKey:@"thumpUp" byAmount:@(-1)];
            [object saveInBackground];
        } else {
            for (BSUser *user in users) {
                if([user.objectId isEqualToString:BSUser.currentUser.objectId]) {
                    return;
                }
            }
            [users addObject:BSUser.currentUser];
            [object setObject:users forKey:@"thumpUpUsers"];
            [object incrementKey:@"thumpUp"];
            [object saveInBackground];
        }
    }];

}
@end
