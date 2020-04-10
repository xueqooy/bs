//
//  TCTitleHeaderView.h
//  CheersgeniePlus
//
//  Created by mac on 2020/3/24.
//  Copyright © 2020 Cheersmind. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCTitleHeaderView : UIView <UITableViewDelegate>
@property (nonatomic) NSInteger section;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) QMUIButton *button;
@property (nonatomic) CGFloat spacingBetweenImageAndTitle;
@property (nonatomic) UIEdgeInsets insets;

@end

NS_ASSUME_NONNULL_END
