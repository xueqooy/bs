//
//  FECheckUpdateTableViewCell.h
//  smartapp
//
//  Created by mac on 2019/9/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FECheckUpdateTableViewCell : UITableViewCell
- (void)setVersionCode:(NSString *)version;

- (void)hasNewVersionTip:(BOOL)has;
@end

NS_ASSUME_NONNULL_END
