//
//  PIBoxStateManager.h
//  smartapp
//
//  Created by mac on 2019/10/31.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIXibBaseBox.h"
#import "PIModel.h"


@interface PIBoxStateManager : NSObject
@property (atomic, assign) NSInteger completeCount;

- (instancetype)initWithBoxes:(NSArray <PIXibBaseBox *>*)boxes completeButton:(UIButton *)button completedHandler:(void(^)(void)) completeHandler;
@end


