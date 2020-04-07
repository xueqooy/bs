//
//  SharedLabelTableViewCell.h
//  smartapp
//
//  Created by mac on 2019/7/20.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SharedLabelTableViewCell : BaseTableViewCell
- (void)setHeadingText:(NSString *)heading mainBodyText:(NSString *)main;
@end

NS_ASSUME_NONNULL_END
