//
//  UITabBar+Tip.h
//  FlyClip
//
//  Created by 都兴忱 on 2017/2/6.
//  Copyright © 2017年 tongboshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Tip)
//添加未读提示
- (void)showTipOnItemIndex:(NSInteger)index unread:(NSString *)unreads;
//隐藏未读提示
- (void)hideTipOnItemIndex:(NSInteger)index;
@end
