//
//  FEOuccupationTreeViewCell.h
//  smartapp
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RATreeView.h>
NS_ASSUME_NONNULL_BEGIN

@interface FEOuccupationTreeViewCell : UITableViewCell
- (void)setCellWith:(NSString *)title level:(NSInteger)level children:(NSInteger )children;
+ (instancetype)treeViewCellWith:(RATreeView *)treeView;
- (void)setExpantionStatus:(BOOL)expand;
@end

NS_ASSUME_NONNULL_END
