//
//  PIBirthDaySelector.h
//  smartapp
//
//  Created by mac on 2019/11/2.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PISelectBox.h"

NS_ASSUME_NONNULL_BEGIN

@interface PIBirthDaySelector : NSObject <PISelectBoxProtocal>
- (instancetype)initWithYearSum:(NSUInteger)sum defaultYearWithYearsAgo:(NSUInteger)yearsAgo;
@end

NS_ASSUME_NONNULL_END
