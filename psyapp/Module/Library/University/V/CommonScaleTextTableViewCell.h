//
//  CommonScaleTextTableViewCell.h
//  smartapp
//
//  Created by lafang on 2019/4/22.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEBaseViewController.h"

typedef void (^CommonBlock)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface CommonScaleTextTableViewCell : UITableViewCell

-(void)updateString:(NSString *)str isScale:(BOOL)isScale;

@property(nonatomic,strong)CommonBlock scaleCallback;

@end

NS_ASSUME_NONNULL_END
