//
//  FEOccupationTreeModel.h
//  smartapp
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FEOccupationTreeModel : NSObject

@property (nonatomic,copy) NSString *name;//标题

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, weak) FEOccupationTreeModel *parent; //父节点

@property (nonatomic,strong) NSArray *children;//子节点数组

- (id)initWithName:(NSString *)name children:(NSArray *)array parent:(FEOccupationTreeModel *)parent ID:(NSString *)ID;

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children parent:(FEOccupationTreeModel *)parent ID:(NSString *)ID ;


@end

