//
//  TCTestHistoryRecordView.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/7.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCPopupContainerView.h"
#import "TCTestHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TCTestHistoryRecordView : UIView <TCPopupContainerViewProtocol>
@property (nonatomic, copy) NSArray <TCTestHistoryModel *>*historyRecord;
@property (nonatomic, copy) void(^onTap) (NSString *childDimensionId);
@property (nonatomic, copy) void(^onStartTestButtonClick)(void);
@end

NS_ASSUME_NONNULL_END
