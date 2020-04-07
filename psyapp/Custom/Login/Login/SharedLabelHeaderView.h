//
//  SharedLabelHeaderView.h
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/16.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SharedLabelHeaderView : UIView
- (instancetype)initWithHeadingText:(NSString *)heading mainBodyText:(NSString *)main;
- (void)setHeadingText:(NSString *)heading;
- (void)setMainBodyText:(NSString *)main;
@end

NS_ASSUME_NONNULL_END
