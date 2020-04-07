//
//  PIGenderBox.h
//  smartapp
//
//  Created by mac on 2019/10/30.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "PIXibBaseBox.h"

NS_ASSUME_NONNULL_BEGIN

@interface PIGenderBox : PIXibBaseBox
@property (nonatomic, assign, readonly) NSInteger selectedIndex;
@property (nonatomic, copy) NSString *title;
@end
NS_ASSUME_NONNULL_END
