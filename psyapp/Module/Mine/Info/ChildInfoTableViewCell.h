//
//  ChildInfoTableViewCell.h
//  smartapp
//
//  Created by lafang on 2018/10/25.
//  Copyright © 2018年 jeyie0. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CommonBlock)(NSInteger index);

@interface ChildInfoTableViewCell : UITableViewCell

-(void)updateCell:(NSString *)title rightStr:(NSString *)rightStr headImageUrl:(NSString *)headImageUrl;
-(void)updateUserHeadImage:(NSString *)avatarUrl;
@property(nonatomic,strong)CommonBlock commonBlock;
@property (nonatomic, strong) UIView *bottomLine;

@end
