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
@property (nonatomic, copy) NSString *key;
- (void)setMaximumCapacityOfRecords:(NSInteger)n;
- (void)saveSearchRecord:(NSString *)aRecord;
- (void)reloadRecords;


- (instancetype)initWithKey:(NSString *)key;
@end

@interface FESearchRecordView (Popular)
@property (nonatomic, copy) NSArray <NSString *>*popularSearchTextArray;

@end

NS_ASSUME_NONNULL_END
