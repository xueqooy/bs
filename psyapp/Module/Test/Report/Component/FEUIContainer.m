//
//  FEUIContainer.m
//  smartapp
//
//  Created by mac on 2019/12/16.
//  Copyright © 2019 jeyie0. All rights reserved.
//
#import <NSPointerArray+QMUI.h>
#import "FEUIContainer.h"

@implementation FEUIContainer
- (instancetype)initWithFrame:(CGRect)frame {
    if ([self isMemberOfClass:FEUIContainer.class]) {
        [self doesNotRecognizeSelector:_cmd];
        return nil;
    } else {
        self = [super initWithFrame:frame];
        return self;
    }
}

- (instancetype)init {
    if ([self isMemberOfClass:FEUIContainer.class]) {
        [self doesNotRecognizeSelector:_cmd];
        return nil;
    } else {
        self = [super init];
        return self;
    }
}

- (instancetype)initWithChildren:(NSArray<FEUIComponent *> *)children padding:(UIEdgeInsets)padding spacing:(CGFloat)spacing {
    self = [super init];
    _children = children.mutableCopy;
    _padding = padding;
    _spacing = spacing;
    [self build];
    return self;
}

+ (instancetype)children:(NSArray<FEUIComponent *> *)children padding:(UIEdgeInsets)padding spacing:(CGFloat)spacing {
    return [[self alloc] initWithChildren:children padding:padding spacing:spacing];
}


- (void)build {
    if (self.nonemptyChildren.count == 0) { //children 全部为空的,将容器设置为空
        [self setEmpty:YES];
        return;
    }
   
    [self buildWithFirstDependentComponent:self children:_children];
}

- (void)buildWithFirstDependentComponent:(FEUIComponent *)first children:(NSArray <FEUIComponent *>*)children {    
}

@end


@implementation FEUIContainer (Mutability)

- (void)updateChildren:(NSArray <FEUIComponent *>*)children {
    [_children makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _endConstraint = nil;
    _children = children.mutableCopy;
    [self build];
}
- (void)appendChildren:(NSArray <FEUIComponent *>*)children {
    if (children == nil || children.count == 0) {
        return;
    }
    
    BOOL isAllEmpty = YES;
    for (FEUIComponent *child in children) {
        if (child.isEmpty == NO) {
            isAllEmpty = NO;
            break;
        }
    }
    
    if (isAllEmpty) {
        [_children addObjectsFromArray:children];
        return;
    }
    
    FEUIComponent *firstDependentComponent = self.lastNonemptyChild;
    if (firstDependentComponent == nil) {
        firstDependentComponent = self;
    }
    [_children addObjectsFromArray:children];
    [_endConstraint uninstall];
    [self buildWithFirstDependentComponent:firstDependentComponent children:children];
}

- (BOOL)insertChild:(FEUIComponent *)child atIndex:(NSUInteger)index {
    return [self insertChildren:@[child] atIndex:index];
}

- (BOOL)removeChildAtIndex:(NSUInteger)index {
    return [self removeChildrenAtIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (BOOL)removeNonemptyChildAtIndex:(NSUInteger)index {
    return [self removeChildrenAtIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (BOOL)insertChildren:(NSArray <FEUIComponent *>*)children atIndex:(NSUInteger)index {//TODO
    if (index < 0 || index > _children.count || children.count == 0 || children == nil) {
        return NO;
    }
    [_children insertObjects:children atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, children.count)]];
    return YES;
}

- (BOOL)removeChildrenAtIndexes:(NSIndexSet *)indexes {  //TODO
    if ([indexes indexLessThanIndex:0] != NSNotFound || [indexes indexGreaterThanOrEqualToIndex:_children.count] != NSNotFound || _children.count == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)removeNonemptyChildrenAtIndexes:(NSIndexSet *)indexes { //TODO
    NSPointerArray *nonemptyChildren = self.nonemptyChildren;
    if ([indexes indexLessThanIndex:0] != NSNotFound || [indexes indexGreaterThanOrEqualToIndex:nonemptyChildren.count] != NSNotFound || nonemptyChildren.count == 0) {
        return NO;
    }
    return YES;
}

- (void)removeLastChild {
    if (_children.count == 0) {
        return;
    }
    FEUIComponent *lastChild = _children[_children.count - 1];
    FEUIComponent *lastNonemptyChild = self.lastNonemptyChild;
    
    if (lastChild == lastNonemptyChild) {
        [self removeLastNonemptyChild];
    } else {
        [lastChild removeFromSuperview];
        [_children removeLastObject];
    }
}

- (void)removeLastNonemptyChild {
    if (0 == self.nonemptyChildren.count) {
        return;
    }
    
    FEUIComponent *lastNonemptyChild = self.lastNonemptyChild;
    if (lastNonemptyChild) {
        [lastNonemptyChild removeFromSuperview];
        [_children removeObject:lastNonemptyChild];
    }
}

- (void)compact {
    NSMutableIndexSet *shouldRemovedIndexset = [NSMutableIndexSet indexSet];
    [_children enumerateObjectsUsingBlock:^(FEUIComponent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isEmpty) {
            [shouldRemovedIndexset addIndex:idx];
        }
    }];
    [_children removeObjectsAtIndexes:shouldRemovedIndexset];
}

@end

@implementation FEUIContainer (ChildGetter)
- (NSPointerArray *)nonemptyChildren {
    NSPointerArray *nonemptyChildren = [NSPointerArray weakObjectsPointerArray];
    for (FEUIComponent *child in _children) {
        if (NO == child.isEmpty) {
            [nonemptyChildren addPointer:(__bridge void *)(child)];
        }
    }
    return nonemptyChildren;
}

- (FEUIComponent *)firstNonemptyChild {
    NSPointerArray *nonemptyChildren = self.nonemptyChildren;
    if (0 == nonemptyChildren.count) {
        return nil;
    }
    return [nonemptyChildren pointerAtIndex:0];
}

- (FEUIComponent *)lastNonemptyChild {
    NSPointerArray *nonemptyChildren = self.nonemptyChildren;
    if (0 == nonemptyChildren.count) {
        return nil;
    }
    return [nonemptyChildren pointerAtIndex:nonemptyChildren.count - 1];
}



- (FEUIComponent *)upwardClosestNonemptyChildTo:(FEUIComponent *)child {
    if ([_children containsObject:child] == NO) {
        return nil;
    }
    
    NSPointerArray *nonemptyChildren = self.nonemptyChildren;
    if (nonemptyChildren.count == 0) {
        return nil;
    }
    
    NSInteger beginIndex = [_children indexOfObject:child] - 1;
    for (; beginIndex >= 0; beginIndex --) {
        FEUIComponent *otherChild = _children[beginIndex];
        if ([nonemptyChildren qmui_containsPointer:(__bridge void * _Nullable)(otherChild)]) {
            return otherChild;
        }
    }
    return nil;
}

- (FEUIComponent *)downwardClosestNonemptyChildTo:(FEUIComponent *)child {
    if ([_children containsObject:child] == NO) {
        return nil;
    }
    
    NSPointerArray *nonemptyChildren = self.nonemptyChildren;
    if (nonemptyChildren.count == 0) {
        return nil;
    }
    
    NSInteger beginIndex = [_children indexOfObject:child] + 1;
    for (; beginIndex < _children.count; beginIndex ++) {
        FEUIComponent *otherChild = _children[beginIndex];
        if ([nonemptyChildren qmui_containsPointer:(__bridge void * _Nullable)(otherChild)]) {
            return otherChild;
        }
    }
    return nil;
}



@end
