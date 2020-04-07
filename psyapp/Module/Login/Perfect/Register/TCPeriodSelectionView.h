//
//  TCPeriodSelectionView.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/16.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseAlertView.h"
#import "PISelectBox.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCPeriodSelectionView : FEBaseAlertView <PISelectBoxProtocal>
- (instancetype)initWithOptions:(NSArray <NSString *> *)options selectedIndex:(NSInteger)idx;
@property (nonatomic, copy) NSArray <NSString *> * options;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void (^onSelected)(NSString *content, NSInteger index);
@end

NS_ASSUME_NONNULL_END
