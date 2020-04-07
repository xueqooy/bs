//
//  InvitationCodeTableViewCell.h
//  smartapp
//
//  Created by mac on 2019/7/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvitationCodeTableViewCell : BaseTableViewCell
@property (nonatomic, copy) void(^textChangedHandler)(BOOL filled, NSString *code);
- (void)setResultText:(NSString *)text;
- (void)setFirstResponder:(BOOL)fr;
- (void)clearContent;
@end

NS_ASSUME_NONNULL_END
