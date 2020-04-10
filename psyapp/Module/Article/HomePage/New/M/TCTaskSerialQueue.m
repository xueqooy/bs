//
//  TCTaskSerialQueue.m
//  CheersgeniePlus
//
//  Created by mac on 2020/3/31.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import "TCTaskSerialQueue.h"
@interface TCTaskSerialQueue ()
@property (nonatomic) NSMutableArray <void(^)(void)>*taskQueue;
@end
@implementation TCTaskSerialQueue {
    BOOL _stop;
}
- (instancetype)init {
    self = [super init];
    _executionInterval = 0;
    _taskQueue = @[].mutableCopy;
    _stop = YES;
    return self;
}

- (void)addTaskBlock:(void (^)(void))block{
    if (block != nil) {
        if (NO == [_taskQueue containsObject:block]) {
            [_taskQueue addObject:block];
        }
    }
}

- (void)start {
    if (_stop == NO) return;
    _stop = NO;
    NSInteger i = 0;
    NSMutableIndexSet *excutedIndex = [NSMutableIndexSet indexSet];
    for (void(^block)(void) in _taskQueue) {
        if (!_stop) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * _executionInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                block();
                [excutedIndex addIndex:i];
            });
        }
    }
    
    if (excutedIndex.count > 0) {
        [_taskQueue removeObjectsAtIndexes:excutedIndex];
    }
}

- (void)stop {
    _stop = YES;
}

- (void)next {
    if (_taskQueue.count == 0) {
        return;
    }
    void (^block)(void) = _taskQueue.firstObject;
    [_taskQueue removeObject:block];
    block();
}

- (void)clear {
    _stop = YES;
    [_taskQueue removeAllObjects];
}
@end
