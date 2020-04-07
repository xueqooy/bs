//
//  FEMineTableViewCell.h
//  smartapp
//
//  Created by lafang on 2018/8/21.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEMineTableViewCell : UITableViewCell

@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *rightText;
@property (nonatomic,assign) NSInteger newsNum;
@property (nonatomic, strong) UIView *bottonLine;

@end
