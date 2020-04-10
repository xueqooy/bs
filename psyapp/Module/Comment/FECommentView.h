//
//  FECommentView.h
//  smartapp
//
//  Created by mac on 2019/7/29.
//  Copyright © 2019 xueqooy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSUInteger, FECommentViewComponent) {
    FECommentViewComponentDiscuss = 1 << 0,
    FECommentViewComponentLike = 1 << 1,
    FECommentViewComponentCollect = 1 << 2,
    FECommentViewComponentList = 1 << 3,
    FECommentViewComponentNone = 1 << 10
};
typedef void(^ButtonClickHandler)(FECommentViewComponent type);
typedef void(^CommentSendHandler)(NSString *content);

@interface FECommentView : UIView

@property(nonatomic, copy) ButtonClickHandler componentClickHandler;
@property(nonatomic, copy) CommentSendHandler commentSendHandler;
@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic, assign) BOOL autoSwitchButtonIcon;
@property(nonatomic, assign) BOOL editable;


+ (instancetype)createCommentViewWithComponent:(FECommentViewComponent)components;
- (void)setCount:(NSInteger)count forComponent:(FECommentViewComponent)component;
- (void)setSelected:(BOOL)selected forComponent:(FECommentViewComponent)component;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
