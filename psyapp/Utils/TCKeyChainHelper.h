//
//  TCKeyChainHelper.h
//  CheersgeniePlus
//
//  Created by mac on 2020/2/26.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCKeyChainHelper : NSObject
+ (void)save:(NSString*)service data:(id)data;
+ (id)load:(NSString*)service;
+ (void)deleteKeyData:(NSString*)service;
@end

NS_ASSUME_NONNULL_END
