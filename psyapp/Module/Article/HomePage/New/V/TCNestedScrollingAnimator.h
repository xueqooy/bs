//
//  TCNestedScrollingAnimator.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/28.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCNestedSimultaneousScrollView : UIScrollView
@property (nonatomic, copy, nullable) NSArray *mutexViews;
@end

@interface TCNestedSimultaneousTableView : UITableView
@end


NS_ASSUME_NONNULL_BEGIN

@interface TCNestedScrollingAnimator : NSObject <UIScrollViewDelegate> 
@property (nonatomic, weak) UIScrollView *primaryScrollView;
@property (nonatomic, weak) UIScrollView *secondaryScrollView;

@property (nonatomic, readonly) BOOL primaryScrollEnabled;
@property (nonatomic, readonly) BOOL secondaryScrollEnabled;

@property (nonatomic) BOOL secondaryScrollViewTopBounces; //默认NO

@property (nonatomic) CGFloat offsetYToEnableSecondaryScroll;

@property (nonatomic, copy) void (^primaryScrollableBlock)(void);
@end

NS_ASSUME_NONNULL_END
