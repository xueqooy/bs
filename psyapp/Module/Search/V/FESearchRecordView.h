//
//  FESearchRecordView.h
//  smartapp
//
//  Created by xueqooy on 2019/7/12.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FESearchRecordView : UIView
@property (nonatomic, copy) void(^selectCompletionHandler)(NSString *searchString);

- (void)setMaximumCapacityOfRecords:(NSInteger)n;
- (void)saveSearchRecord:(NSString *)aRecord;
- (void)reloadRecords;

@end

NS_ASSUME_NONNULL_END
