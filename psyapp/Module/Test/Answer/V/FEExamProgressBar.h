//
//  FEExamProgressBar.h
//  smartapp
//
//  Created by mac on 2019/7/31.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEExamProgressBar : UIView
@property(nonatomic, copy) void (^definitionButtonClickHandler)(void);

- (void)setTimeWithString:(NSString *)timeString;
- (void)setCurrentProgress:(NSInteger)current total:(NSInteger)total;
- (void)setDefinitionButtonHidden:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
