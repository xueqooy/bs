//
//  TCLoginViewStacker.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/11.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCLoginViewStacker : NSObject
@property (nonatomic, weak, readonly) UIView *currentView;


- (instancetype)initWithViewController:(UIViewController *)viewController;
- (void)pushView:(UIView *)view onCompletion:(void (^ __nullable)(UIView *view))completion;
- (void)popViewOnCompletion:(void (^ __nullable)(UIView *view))completion;
- (void)replaceCurrentViewWithView:(UIView *)view;

@property (nonatomic, copy) void (^viewCountChangeHandler)(NSInteger viewCount);
@end

NS_ASSUME_NONNULL_END
