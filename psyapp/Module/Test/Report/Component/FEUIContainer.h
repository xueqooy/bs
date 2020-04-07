//
//  FEUIContainer.h
//  smartapp
//
//  Created by mac on 2019/12/16.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEUIComponent.h"

NS_ASSUME_NONNULL_BEGIN
//抽象类
@interface FEUIContainer : FEUIComponent {
    @protected
    NSMutableArray <FEUIComponent *> *_children;
    __weak MASConstraint *_endConstraint;
    __weak MASConstraint *_beginConstraint;

    UIEdgeInsets _padding;
    CGFloat _spacing;
}

- (instancetype)initWithChildren:(NSArray<FEUIComponent *> *)children padding:(UIEdgeInsets)padding spacing:(CGFloat)spacing;
+ (instancetype)children:(NSArray<FEUIComponent *> *)children padding:(UIEdgeInsets)padding spacing:(CGFloat)spacing;
@end

@interface FEUIContainer (Mutability)
- (void)updateChildren:(NSArray <FEUIComponent *>*)children;
- (void)appendChildren:(NSArray <FEUIComponent *>*)children;
- (BOOL)insertChild:(FEUIComponent *)child atIndex:(NSUInteger)index;//TODO
- (BOOL)insertChildren:(NSArray <FEUIComponent *>*)children atIndex:(NSUInteger)index;//TODO
- (BOOL)removeChildAtIndex:(NSUInteger)index;        //TODO
- (BOOL)removeChildrenAtIndexes:(NSIndexSet *)indexes;  //TODO
- (BOOL)removeNonemptyChildAtIndex:(NSUInteger)index;        //TODO
- (BOOL)removeNonemptyChildrenAtIndexes:(NSIndexSet *)indexes; //TODO
- (void)removeLastChild;
- (void)removeLastNonemptyChild;
- (void)compact; //删除空组件
@end

@interface FEUIContainer (ChildGetter)
- (NSPointerArray *)nonemptyChildren;
- (FEUIComponent *)firstNonemptyChild;
- (FEUIComponent *)lastNonemptyChild;
- (FEUIComponent *)upwardClosestNonemptyChildTo:(FEUIComponent *)child;
- (FEUIComponent *)downwardClosestNonemptyChildTo:(FEUIComponent *)child;
@end
NS_ASSUME_NONNULL_END
