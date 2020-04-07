//
//  VerifyCodeTableViewCell.h
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/17.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface VerifyCodeTableViewCell : BaseTableViewCell
@property(nonatomic, copy) void(^completionHandler)(BOOL isFill, NSString *code);
@property(nonatomic, copy) void(^retransmissionHandler)();

@property(nonatomic, assign) NSTimeInterval retransmissionTimeInterval;
- (void)startCountDown;
- (void)setFirstResponder:(BOOL)fr;

@end

NS_ASSUME_NONNULL_END
