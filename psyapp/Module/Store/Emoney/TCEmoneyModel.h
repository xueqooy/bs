//
//  TCEmoneyModel.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/20.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCEmoneyModel : FEBaseModel
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *emoneyValue;
@property (nonatomic, copy) NSString *appStoreProductId;

//custom
@property (nonatomic, assign) CGFloat priceYuan;
@property (nonatomic, assign) CGFloat emoneyCount;
@end

@interface TCEmoneyListModel : FEBaseModel
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSMutableArray <TCEmoneyModel *>*items;
@end

@interface TCMyEmoneyBalanceModel : FEBaseModel
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *buyTotal;
@property (nonatomic, strong) NSNumber *exchangeTotal;
@property (nonatomic, strong) NSNumber *balance;

//custom
@property (nonatomic, assign) CGFloat balanceCount;
@end
NS_ASSUME_NONNULL_END
