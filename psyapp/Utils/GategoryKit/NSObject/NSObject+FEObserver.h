//
//  NSObject+FEObserver.h
//  FEKVOBlock
//
//  Created by xueqooy on 2019/9/2.
//  Copyright © 2019年 xue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FEObserverBlock)(id _Nullable oldValue, id _Nullable newValue);
NS_ASSUME_NONNULL_BEGIN
@interface NSObject (FEObserver)
/**
 一直监听，直到对象被释放或移除观察者
 */
- (void)fe_addObserver:(NSObject *)obsever forKeyPath:(NSString *)keyPath withBlock:(FEObserverBlock)block;
/**
 监听有限次数的值变化或者对象被释放或移除观察者后中止
 times <= 0，则不进行监听
 */
- (void)fe_addObserver:(NSObject *)obsever forKeyPath:(NSString *)keyPath times:(NSInteger)times withBlock:(FEObserverBlock)block;
/**
 监听一次的值变化或者对象被释放或移除观察者后中止
 */
- (void)fe_addObserver:(NSObject *)obsever forKeyPath:(NSString *)keyPath withOnceBlock:(FEObserverBlock)block;
/**
 移除对应keyPath的指定观察者
 */
- (void)fe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
/**
 移除对应keyPath的所有观察者
 */
- (void)fe_removeAllObserversForKeyPath:(NSString *)keyPath;

/**
 判断对应keyPath是否有指定观察者
 */
- (BOOL)fe_hasObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

/**
  打印KVO信息
 */
- (void)fe_logKVOInfo;
NS_ASSUME_NONNULL_END
@end

