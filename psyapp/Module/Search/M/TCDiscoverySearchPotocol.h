//
//  TCDiscoverySearchPotocol.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/22.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TCDiscoverySearchPotocol <NSObject>
@property (nonatomic, weak) TCDiscoverySearchDataManager *dataManager;
@property (nonatomic, copy) NSString *filter;
- (void)startSearchWithFilter:(NSString *)filter;
@end

NS_ASSUME_NONNULL_END
