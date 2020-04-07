//
//  FEEvaluationView.h
//  smartapp
//
//  Created by mac on 2019/10/13.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCPopupContainerView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^TCConfirmBlock)(NSInteger level);

@interface FEEvaluationView : UIView <TCPopupContainerViewProtocol>
@property (nonatomic, copy) NSString *explain;
@property (nonatomic, copy) NSArray *starDescriptions;
@property (nonatomic, copy) TCConfirmBlock confirmBlock;
+ (instancetype)loadFromNib;



//+ (void)showTo:(UIView *)view confirmHandler:(void(^)(NSInteger selectedIndex))confirmHandler;
//+ (void)hide;
@end

NS_ASSUME_NONNULL_END
