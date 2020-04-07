//
//  FEUIColumn.m
//  smartapp
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEUIColumn.h"

@implementation FEUIColumn
#pragma mark - Override
- (void)removeLastNonemptyChild {
    [super removeLastNonemptyChild];
    
    FEUIComponent *lastNonemptyChild = self.lastNonemptyChild;
    
    if (lastNonemptyChild == nil) {
        return;
    }
    
    [lastNonemptyChild mas_updateConstraints:^(MASConstraintMaker *make) {
        _endConstraint =  make.bottom.offset(-_padding.bottom);
    }];
    
}

- (BOOL)insertChildren:(NSArray<FEUIComponent *> *)children atIndex:(NSUInteger)index {
    if ([super insertChildren:children atIndex:index] == NO) {
        return NO;
    }
    //TODO
//    BOOL isAllEmpty = YES;
//    for (FEUIComponent *child in children) {
//        if (child.isEmpty == NO) {
//            isAllEmpty = NO;
//            break;
//        }
//    }
//
//    FEUIComponent *firstNonemptyChild = self.firstNonemptyChild;
//    NSInteger idxOfFirstNonempty = [_children indexOfObject:firstNonemptyChild];
//    if (index <= idxOfFirstNonempty && !isAllEmpty) {
//        [_beginConstraint uninstall];
//        [self buildWithFirstDependentComponent:self children:children];
//    } else if (index < idxOfFirstNonempty)
    return YES;
}


- (void)buildWithFirstDependentComponent:(FEUIComponent *)first children:(NSArray <FEUIComponent *>*)children {
    FEUIComponent *previousComponent = first;
    FEUIComponent *lastNonemptyChild = self.lastNonemptyChild;
    for (FEUIComponent *child in children) {
        if (child.isEmpty) {
            [self addSubview:child];
            child.hidden = YES;
            continue;
        }
        
        [self addSubview:child];
        [child mas_makeConstraints:^(MASConstraintMaker *make) {
            //top
            if (self == previousComponent) {
                _beginConstraint = make.top.offset(_padding.top);
            } else {
                make.top.equalTo(previousComponent.mas_bottom).offset(_spacing);
            }
            
            //left
            make.left.offset(_padding.left);
            
            //right
            make.right.offset(-_padding.right);

            //bottom
            if (child == lastNonemptyChild) {
               _endConstraint = make.bottom.offset(-_padding.bottom);
            }
        }];
            
        previousComponent = child;
    }
    
    if ([children containsObject:lastNonemptyChild] == NO) { //不是插在末尾
        if (previousComponent != first) { //存在不为空的child
            FEUIComponent *downwardClosestChild = [self downwardClosestNonemptyChildTo:previousComponent];
            [downwardClosestChild mas_updateConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(previousComponent.mas_bottom).offset(_spacing);
            }];
        }
    }
}

//当child改变empty时，容器会刷新布局约束
- (void)updateContraintsForComponent:(FEUIComponent *)component {
    if ([_children containsObject:component]) {
        FEUIComponent *upwardClosestChild = [self upwardClosestNonemptyChildTo:component];
        FEUIComponent *downwardClosestChild = [self downwardClosestNonemptyChildTo:component];
        [component removeContraintsInSuper];
        if (component.isEmpty) {
            component.hidden = YES;
            if (upwardClosestChild && downwardClosestChild) {
                [downwardClosestChild mas_updateConstraints:^(MASConstraintMaker *make) {
                   make.top.equalTo(upwardClosestChild.mas_bottom).offset(_spacing);
                }];
            } else if (upwardClosestChild && !downwardClosestChild) {
                [upwardClosestChild mas_updateConstraints:^(MASConstraintMaker *make) {
                    _endConstraint =  make.bottom.offset(-_padding.bottom);
                }];
            } else if (!upwardClosestChild && downwardClosestChild) {
                [downwardClosestChild mas_updateConstraints:^(MASConstraintMaker *make) {
                   _beginConstraint = make.top.offset(_padding.top);
                }];
            } else if (!upwardClosestChild && !downwardClosestChild) {
                [self setEmpty:YES];
            }
        } else {
            component.hidden = NO;
            if (upwardClosestChild && downwardClosestChild) {
                [component mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(upwardClosestChild.mas_bottom).offset(_spacing);
                    make.left.offset(_padding.left);
                    make.right.offset(-_padding.right);
                }];
                [downwardClosestChild mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(component.mas_bottom).offset(_spacing);
                }];
            } else if (upwardClosestChild && !downwardClosestChild) {
                [_endConstraint uninstall];
                [component mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(upwardClosestChild.mas_bottom).offset(_spacing);
                    make.left.offset(_padding.left);
                    make.right.offset(-_padding.right);
                    _endConstraint =  make.bottom.offset(-_padding.bottom);
                }];
            } else if (!upwardClosestChild && downwardClosestChild) {
                [_beginConstraint uninstall];
                [component mas_makeConstraints:^(MASConstraintMaker *make) {
                    _beginConstraint = make.top.offset(_padding.top);
                    make.left.offset(_padding.left);
                    make.right.offset(-_padding.right);
                }];
                [downwardClosestChild mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(component.mas_bottom).offset(_spacing);
                }];
            } else if (!upwardClosestChild && !downwardClosestChild) {
                [component mas_makeConstraints:^(MASConstraintMaker *make) {
                    _beginConstraint = make.top.offset(_padding.top);
                    make.left.offset(_padding.left);
                    make.right.offset(-_padding.right);
                    _endConstraint =  make.bottom.offset(-_padding.bottom);
                }];
            }
        }
    }
}
@end
