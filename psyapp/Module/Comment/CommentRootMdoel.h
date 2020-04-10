//
//  CommentRootMdoel.h
//  smartapp
//
//  Created by lafang on 2018/8/28.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import "FEBaseModel.h"
#import "CommentModel.h"
@interface CommentRootMdoel : FEBaseModel

@property(nonatomic,assign) NSInteger total;

@property(nonatomic,strong) NSMutableArray <CommentModel *>*items;



//custom
@property (nonatomic, assign) NSInteger page;

@end
