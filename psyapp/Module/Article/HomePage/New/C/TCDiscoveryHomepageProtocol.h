//
//  TCDiscoveryHomepageProtocol.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/29.
//  Copyright © 2020 Cheersmind. All rights reserved.
//
#import "TCCategroyModel.h"

@protocol TCDiscoveryHomepageProtocol <NSObject>
@required
- (void)loadData;

@optional
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, copy) void (^dataLoadedBlock)(BOOL hasData);
@property (nonatomic, assign) void (^heightDidChange)(CGFloat height);
@end
