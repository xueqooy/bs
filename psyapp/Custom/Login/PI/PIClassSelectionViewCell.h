//
//  PIClassSelectionViewCell.h
//  ClassSelection
//
//  Created by xueqooy on 2019/10/30.
//  Copyright © 2019年 cheers-genius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIClassSelectionViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^touchHandler)(NSString *content);
- (void)setState:(BOOL)seleted;

@end
