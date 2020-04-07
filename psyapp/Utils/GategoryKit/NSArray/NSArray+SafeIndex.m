//
//  NSArray+SafeIndex.m
//  RunTime
//
//  Created by 吴伟毅 on 18/8/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "NSArray+SafeIndex.h"
#import <objc/runtime.h>
#import "NSObject+Utils.h"
@implementation NSArray (SafeIndex)
+ (void)load
{
        [objc_getClass("__NSArray0") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(_0_safeObjectAtIndex:)];
    
        [objc_getClass("__NSSingleObjectArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(_singleI_safeObjectAtIndex:)];
    
        [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(_I_safeObjectIndex:)];
    
         [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(_I_safeObjectAtIndexedSubscript:)];
    
        [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(_M_safeObjectAtIndex:)];
    
        [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(_M_safeObjectAtIndexedSubscript:)];
}

- (id)_0_safeObjectAtIndex:(NSInteger)index{
#ifdef DEBUG
    NSLog(@"the array0 is empty");
#endif
    return nil;

}

- (id)_I_safeObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
#ifdef DEBUG
        NSLog(@"arrayI index:%ld crossover",index);
#endif
        return nil;
    }
    return [self _I_safeObjectIndex:index];
}

- (id)_I_safeObjectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
#ifdef DEBUG
        NSLog(@"arrayI index:%ld crossover",index);
#endif
        return nil;
    }
    return [self _I_safeObjectAtIndexedSubscript:index];
}

- (id)_singleI_safeObjectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
#ifdef DEBUG
        NSLog(@"arraySingleI index:%ld crossover",index);
#endif
        return nil;
    }
    return [self _singleI_safeObjectAtIndex:index];
}

- (id)_M_safeObjectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
#ifdef DEBUG
        NSLog(@"arrayM index:%ld crossover",index);
#endif
        return nil;
    }
    return [self _M_safeObjectAtIndex:index];
}

- (id)_M_safeObjectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
#ifdef DEBUG
        NSLog(@"arrayM index:%ld crossover",index);
#endif
        return nil;
    }
    return [self _M_safeObjectAtIndexedSubscript:index];
}



@end
