//
//  FEOtherFollowsTableViewCell.h
//  smartapp
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEOtherFollowsTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^clickHandler)(void);

- (void)updataWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
