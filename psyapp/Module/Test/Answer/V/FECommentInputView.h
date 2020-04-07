//
//  FECommentInputView.h
//  smartapp
//
//  Created by mac on 2019/8/16.
//  Copyright © 2019 xueqooy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FECommentInputViewResult)(NSString *content, BOOL isSend);

@interface FECommentInputView : UIView

- (void)show;

-(void)setContent:(NSString *)content;

@property(nonatomic,copy) NSString *placeholder;
@property(nonatomic,copy) FECommentInputViewResult result;
@end

NS_ASSUME_NONNULL_END
