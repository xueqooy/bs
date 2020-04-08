//
//  CommonBottomMenuView.h
//  smartapp
//
//  Created by lafang on 2019/4/1.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^CommonBlock)(NSInteger index);

@interface CommonBottomMenuView : UIView

-(instancetype)initWithData:(NSArray<NSString *> *)array title:(NSString *)title;

- (void)showInView:(UIView *)view;

@property(nonatomic,strong)CommonBlock menuCallBack;

@end

NS_ASSUME_NONNULL_END
