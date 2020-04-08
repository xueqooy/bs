//
//  ZJChooseOneRightCell.h
//  smartapp
//
//  Created by lafang on 2019/2/21.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJChooseOneRightCell : UITableViewCell

@property(nonatomic ,strong) UILabel        *titleLab;

@property(nonatomic ,strong) UILabel        *detailLab;

@property(nonatomic ,assign) BOOL isSelected;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
