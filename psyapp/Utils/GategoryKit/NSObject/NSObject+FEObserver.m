//
//  NSObject+FEObserver.m
//  FEKVOBlock
//
//  Created by xueqooy on 2019/9/2.
//  Copyright © 2019年 xue. All rights reserved.
//

#import "NSObject+FEObserver.h"
#import <objc/runtime.h>

#define TIMES_FOREVER -1
static const void *OBSERVER_INfO_KEY = "observerInfoKey";

static void
p_addObserver(NSObject *subject, NSObject *observer, NSString *keyPath, NSInteger times, FEObserverBlock block);

static void
p_observeValue(NSString *keyPath, NSObject *subject, NSDictionary<NSKeyValueChangeKey,id> *change, void *context);

static void
p_removeObserver(NSObject *subject, NSObject *observer, NSString *keyPath);

static void
p_removeAllObservers(NSObject *subject, NSString *keyPath);

static void
p_removeObserverIfNeed(NSObject *subject, NSMutableDictionary *observerInfo, void *context);

static BOOL
p_hasObserver(NSObject *subject, NSObject *observer, NSString *keyPath);

static void
p_logKVOInfo(NSObject *subject);

@implementation NSObject (FEObserver)
- (void)fe_addObserver:(NSObject *)obsever forKeyPath:(NSString *)keyPath withBlock:(FEObserverBlock)block {
    if (obsever && (keyPath && keyPath.length != 0) && block) {
        p_addObserver(self, obsever, keyPath, TIMES_FOREVER, block);
    }
}

- (void)fe_addObserver:(NSObject *)obsever forKeyPath:(NSString *)keyPath withOnceBlock:(FEObserverBlock)block {
    if (obsever && (keyPath && keyPath.length != 0) && block) {
        p_addObserver(self, obsever, keyPath, 1, block);
    }
}

- (void)fe_addObserver:(NSObject *)obsever forKeyPath:(NSString *)keyPath times:(NSInteger)times withBlock:(FEObserverBlock)block {
    if (obsever && (keyPath && keyPath.length != 0) && block && times > 0) {
        p_addObserver(self, obsever, keyPath, times, block);
    }
}

- (void)fe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    if (observer && (keyPath && keyPath.length != 0)) {
        p_removeObserver(self, observer, keyPath);
    }
}

- (void)fe_removeAllObserversForKeyPath:(NSString *)keyPath {
    if (keyPath && keyPath.length != 0) {
        p_removeAllObservers(self, keyPath);
    }
}

- (BOOL)fe_hasObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    if (observer && (keyPath && keyPath.length != 0)) {
        return p_hasObserver(self, observer, keyPath);
    }
    return NO;
}

- (void)fe_logKVOInfo {
    p_logKVOInfo(self);
}
@end


#pragma mark -
#pragma mark ObserverProxy
//实际的观察者
@interface _ObserverProxy : NSObject
+ (instancetype)sharedProxy;
@end

@implementation _ObserverProxy
+ (instancetype)sharedProxy {
    static _ObserverProxy* sharedProxy;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedProxy = [self new];
    });
    return sharedProxy;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    p_observeValue(keyPath, object, change, context);
}
@end

#pragma mark -
#pragma mark FEObserverBlockKeeper
//保存block和名义上的观察者，和被观察对象构成组合关系
@interface _ObserverBlockKeeper : NSObject
@property(nonatomic, weak) NSObject *observer;
@property(nonatomic, copy) FEObserverBlock block;
@property(nonatomic, assign) NSInteger times;
@end

@implementation _ObserverBlockKeeper
@end

#pragma mark -
#pragma mark ObserverKeyPathContext
@interface _ObserverKeyPathContext : NSObject
@property(nonatomic, assign) NSObject *subject;//保证观察者移除，关键字需要用assign
@property(nonatomic, copy) NSString *keyPath;
@property(nonatomic, strong) NSMutableArray <_ObserverBlockKeeper *>*blockKeepers;
@end

@implementation _ObserverKeyPathContext
- (void)dealloc {
    //如果subject实际已经释放，则subject指向的是僵尸对象，通过僵尸对象移除观察者 
    if (_subject) {
        [_subject removeObserver:[_ObserverProxy sharedProxy] forKeyPath:_keyPath];
        _subject = nil;
    }
    
}
@end

#pragma mark -
#pragma mark  实现
void p_addObserver(NSObject *subject, NSObject *observer, NSString *keyPath, NSInteger times, FEObserverBlock block) {
    
    NSMutableDictionary *observerInfo;
    _ObserverKeyPathContext *keyPathContext;
    
    if ((void)(observerInfo = objc_getAssociatedObject(subject, OBSERVER_INfO_KEY)), !observerInfo) {
        observerInfo = @{}.mutableCopy;
        objc_setAssociatedObject(subject, OBSERVER_INfO_KEY, observerInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if ((void)(keyPathContext = observerInfo[keyPath]), !keyPathContext) {
        keyPathContext = [_ObserverKeyPathContext new];
        keyPathContext.keyPath = keyPath;
        keyPathContext.blockKeepers = @[].mutableCopy;
        keyPathContext.subject = subject;
        
        [observerInfo setObject:keyPathContext forKey:keyPath];
        
        [subject addObserver:[_ObserverProxy sharedProxy] forKeyPath:keyPath options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(keyPathContext)];
    }
   
    
    _ObserverBlockKeeper *blockKeeper = [_ObserverBlockKeeper new];
    blockKeeper.observer = observer;
    blockKeeper.block = block;
    blockKeeper.times = times;
    [keyPathContext.blockKeepers addObject:blockKeeper];
}

void p_observeValue(NSString *keyPath, NSObject *subject, NSDictionary<NSKeyValueChangeKey,id> *change, void *context) {
    id newValue = change[NSKeyValueChangeNewKey];
    id oldValue = change[NSKeyValueChangeOldKey];
    
    NSMutableDictionary *observerInfo = objc_getAssociatedObject(subject, OBSERVER_INfO_KEY);
    _ObserverKeyPathContext *keyPathContext = (__bridge _ObserverKeyPathContext *)context;
 
    int count = (int)keyPathContext.blockKeepers.count;
    for (int i = count - 1; i >= 0; i --) {
        _ObserverBlockKeeper *blockKeeper = keyPathContext.blockKeepers[i];
        if (blockKeeper.observer) {
            blockKeeper.block(oldValue, newValue);
            
            if (--blockKeeper.times == 0) {
                [keyPathContext.blockKeepers removeObject:blockKeeper];
                p_removeObserverIfNeed(subject, observerInfo, context);
            }
        }
    }    
}

static void p_removeObserver(NSObject *subject, NSObject *observer, NSString *keyPath) {
    NSMutableDictionary *observerInfo;
    if ((void)(observerInfo = objc_getAssociatedObject(subject, OBSERVER_INfO_KEY)), observerInfo) {
        _ObserverKeyPathContext *keyPathContext;
        if ((void)(keyPathContext = observerInfo[keyPath]), keyPathContext) {
            int count = (int)keyPathContext.blockKeepers.count;
            for (int i = count - 1; i >= 0; i --) {
                _ObserverBlockKeeper *blockKeeper = keyPathContext.blockKeepers[i];
                if (blockKeeper.observer == observer || blockKeeper.observer == nil) {
                    [keyPathContext.blockKeepers removeObjectAtIndex:i];
                }
            }
            p_removeObserverIfNeed(subject, observerInfo, (__bridge void *)(keyPathContext));
        }
    }
}

void p_removeAllObservers(NSObject *subject, NSString *keyPath) {
    NSMutableDictionary *observerInfo;
    if ((void)(observerInfo = objc_getAssociatedObject(subject, OBSERVER_INfO_KEY)), observerInfo) {
        _ObserverKeyPathContext *keyPathContext;
        if ((void)(keyPathContext = observerInfo[keyPath]), keyPathContext) {
            [keyPathContext.blockKeepers removeAllObjects];
            p_removeObserverIfNeed(subject, observerInfo, (__bridge void *)(keyPathContext));
        }
    }
}

void p_removeObserverIfNeed(NSObject *subject, NSMutableDictionary *observerInfo, void *context) {
    _ObserverKeyPathContext *keyPathContext = (__bridge _ObserverKeyPathContext *)context;
    if (keyPathContext.blockKeepers.count == 0) {
        [observerInfo removeObjectForKey:keyPathContext.keyPath];
    }
    if (observerInfo.count == 0) {
        objc_setAssociatedObject(subject, OBSERVER_INfO_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

BOOL p_hasObserver(NSObject *subject, NSObject *observer, NSString *keyPath) {
    NSMutableDictionary *observerInfo;
    _ObserverKeyPathContext *keyPathContext;
    
    if ((void)(observerInfo = objc_getAssociatedObject(subject, OBSERVER_INfO_KEY)), observerInfo) {
        if ((void)(keyPathContext = observerInfo[keyPath]), keyPathContext) {
            __block BOOL found = NO;
            [keyPathContext.blockKeepers enumerateObjectsUsingBlock:^(_ObserverBlockKeeper * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.observer == observer) {
                    found = YES;
                    *stop = YES;
                }
            }];
            return found;
        }
    }
   
    return NO;
}
#define KVOLog(format, ...) printf("%s\n",[[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);

void p_logKVOInfo(NSObject *subject) {
    NSMutableDictionary *observerInfo;
    __block _ObserverKeyPathContext *keyPathContext;
    if ((void)(observerInfo = objc_getAssociatedObject(subject, OBSERVER_INfO_KEY)), observerInfo) {
        KVOLog(@"%@ {", subject)
        NSArray *allKeyPaths = observerInfo.allKeys;
        [allKeyPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *keyPath = obj;
            if ((void)(keyPathContext = observerInfo[keyPath]), keyPathContext) {
                KVOLog(@"\t%@ : {", keyPath)
                if (keyPathContext.blockKeepers.count > 0) {
                    [keyPathContext.blockKeepers enumerateObjectsUsingBlock:^(_ObserverBlockKeeper * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        KVOLog(@"\t\t%@ : %@,", obj.observer, obj.block)
                    }];
                }
                KVOLog(@"\t}")
            }
        }];
        KVOLog(@"}");
        
    }
    
}
