//
//  TCDiscoverySearchPotocol.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/22.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCDiscoverySearchDataManager.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TCDiscoverySearchPotocol <NSObject>
@optional
@property (nonatomic, weak) TCDiscoverySearchDataManager *dataManager;
@property (nonatomic, copy) NSString *filter;
- (void)startSearchWithFilter:(NSString *)filter;
@property (nonatomic, copy) void (^countDidChange) (NSInteger count);
@end

NS_ASSUME_NONNULL_END
