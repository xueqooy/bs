//
//  FEReportFlowLayoutCollectionView.h
//  smartapp
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEUIComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEReportFlowLayoutTagView : FEUIComponent
- (instancetype)initWithTitle:(NSString *)title itemNames:(NSArray <NSString *>*)itemNames projectedWidth:(CGFloat )width;

@property (nonatomic, copy) void (^tagClickHandler)(NSInteger idx);
@end

NS_ASSUME_NONNULL_END
