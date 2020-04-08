//
//  ZJChooseViewOneLeftCell.h
//  smartapp
//
//  Created by lafang on 2019/2/21.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJChooseViewOneLeftCell : UITableViewCell

@property(nonatomic ,strong) UILabel        *titleLab;
@property(nonatomic ,strong) UIImageView    *arrowImgV;

// oneView isSelected
@property(nonatomic ,assign) BOOL isSelected;

// threeView isSelected
@property(nonatomic ,assign) BOOL threeIsSelected;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
