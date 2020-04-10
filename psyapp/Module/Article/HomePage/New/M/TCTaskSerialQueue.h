//
//  TCTaskSerialQueue.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/31.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCTaskSerialQueue : NSObject
@property (nonatomic) CGFloat executionInterval;
- (void)addTaskBlock:(void(^)(void))block;
- (void)start;
- (void)stop; 
- (void)next;
- (void)clear;
@end

NS_ASSUME_NONNULL_END
