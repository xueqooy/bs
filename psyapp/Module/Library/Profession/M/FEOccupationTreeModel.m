//
//  FEOccupationTreeModel.m
//  smartapp
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEOccupationTreeModel.h"

@implementation FEOccupationTreeModel
- (id)initWithName:(NSString *)name children:(NSArray *)children parent:(FEOccupationTreeModel *)parent ID:(NSString *)ID
{
    self = [super init];
    if (self) {
        self.children = children;
        self.name = name;
        self.ID = ID;
        self.parent = parent;
    }
    return self;
}
+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children parent:(FEOccupationTreeModel *)parent ID:(NSString *)ID 
{
    return [[self alloc] initWithName:name children:children parent:parent ID:ID];
}
@end
