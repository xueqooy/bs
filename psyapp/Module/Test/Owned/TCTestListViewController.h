//
//  TCTestListViewController.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/13.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCTestListViewController : FEBaseViewController
@property (nonatomic, strong, nullable) NSString *categoryId;
- (instancetype)initWithCategoryId:(NSString *)categoryId ;
@property (nonatomic, assign) BOOL isOwnedList;

- (void)updateListData;
@end

NS_ASSUME_NONNULL_END
