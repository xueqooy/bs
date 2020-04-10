//
//  UITableView+TCCommentAuthority.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/23.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (TCCommentAuthority)
@property (nonatomic) BOOL tc_commentDisabled;
@property (nonatomic, copy) NSString *tc_commentDisabledHint;
@end

NS_ASSUME_NONNULL_END
