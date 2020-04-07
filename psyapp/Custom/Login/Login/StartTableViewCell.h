//
//  StartTableViewCell.h
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/15.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
 登录和注册按钮样式
 */
@interface StartTableViewCell : BaseTableViewCell
@property (nonatomic, copy) void (^callBack)(void);
- (void)setTilte:(NSString *)title registerType:(BOOL)type;
@end

NS_ASSUME_NONNULL_END
