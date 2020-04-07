//
//  UITextField+ExtentRange.h
//  CheersgeniePlus
//
//  Created by xueqooy on 2019/7/16.
//  Copyright © 2019 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (ExtentRange)

- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
