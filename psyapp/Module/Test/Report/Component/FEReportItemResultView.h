//
//  FEReportItemResultView.h
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEUIComponent.h"

NS_ASSUME_NONNULL_BEGIN
@interface FEReportItemResultViewNameCell : UICollectionViewCell
- (void)setName:(NSString *)name;
@end
@interface FEReportItemResultViewResultCell : UICollectionViewCell
- (void)setResult:(NSString *)result isBadTendency:(BOOL)isBadTendency;
@end

@interface FEReportItemResultView : FEUIComponent <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (instancetype)initWithItemName:(NSString *)name result:(id)result isBadTendency:(BOOL)isBadTendency projectedContentWidth:(CGFloat)width;;
@end

NS_ASSUME_NONNULL_END
