//
//  AddItemViewsManager.m
//  smartapp
//
//  Created by lafang on 2019/3/11.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "AddItemViewsManager.h"
#import "UIColor+Category.h"
#import <Masonry/Masonry.h>
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"

@implementation AddItemViewsManager

+ (UIView *)addCommenTitleView:(UIView *)superView title:(NSString *)title{
    
    UIView *commenTitleView = [[UIView alloc] init];
    [superView addSubview:commenTitleView];
    [commenTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(superView);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *topLineLabel = [[UILabel alloc] init];
    topLineLabel.backgroundColor = UIColor.fe_backgroundColor;
    [commenTitleView addSubview:topLineLabel];
    [topLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(commenTitleView);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *leftLineLabel = [[UILabel alloc] init];
    leftLineLabel.backgroundColor = UIColor.fe_textColorHighlighted;
    [commenTitleView addSubview:leftLineLabel];
    [leftLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commenTitleView);
        make.top.equalTo(topLineLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(5, 20));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = UIColor.fe_titleTextColorLighten;
    [commenTitleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLineLabel.mas_right).offset(10);
        make.centerY.equalTo(leftLineLabel);
    }];
    
    UILabel *bottomLine = [[UILabel alloc] init];
    bottomLine.backgroundColor = UIColor.fe_separatorColor;
    [commenTitleView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(commenTitleView);
        make.bottom.equalTo(commenTitleView.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
    }];
    
    return commenTitleView;
    
}

+ (void)addContentItems:(UIView *)superView arrayData:(NSArray<ProfessionalIntroducesModel *> *)array{
    
    NSMutableArray<UIView *> *itemViews = [[NSMutableArray alloc] init];
    
    for(int i=0;i<array.count;i++){
        
        ProfessionalIntroducesModel *model = array[i];
        
        UIView *itemView = [[UIView alloc] init];
        [superView addSubview:itemView];
        [itemViews addObject:itemView];
        if(array.count==1){
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(superView);
                make.right.equalTo(superView);
                make.top.equalTo(superView);
                make.bottom.equalTo(superView);
            }];
        }else{
            if(i==0){
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(superView);
                    make.right.equalTo(superView);
                    make.top.equalTo(superView);
                }];
            }else if(i == array.count){
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(superView);
                    make.right.equalTo(superView);
                    make.top.equalTo(itemViews[i-1].mas_bottom);
                    make.bottom.equalTo(superView);
                }];
            }else{
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(superView);
                    make.right.equalTo(superView);
                    make.top.equalTo(itemViews[i-1].mas_bottom);
                }];
            }
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = model.title;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.numberOfLines = 0;
        [itemView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemView).offset(20);
            make.right.equalTo(itemView).offset(-20);
            make.top.equalTo(itemView).offset(20);
        }];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = model.content;
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.font = [UIFont systemFontOfSize:12];
        contentLabel.numberOfLines = 0;
        [itemView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemView).offset(20);
            make.right.equalTo(itemView).offset(-20);
            make.top.equalTo(titleLabel.mas_bottom).offset(20);
            make.bottom.equalTo(itemView);
        }];
    }
    
}

+ (void)addProfessionalItems:(UIView *)superView arrayData:(NSArray<ProfessionalCategoryModel *> *)array{
    
    NSMutableArray<UIView *> *itemViews = [[NSMutableArray alloc] init];
    
    for(int i=0;i<array.count;i++){
        
        ProfessionalCategoryModel *model = array[i];
        
        UIView *itemView = [[UIView alloc] init];
        [superView addSubview:itemView];
        [itemViews addObject:itemView];
        if(array.count==1){
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(superView);
                make.right.equalTo(superView);
                make.top.equalTo(superView);
                make.bottom.equalTo(superView);
            }];
        }else{
            if(i==0){
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(superView);
                    make.right.equalTo(superView);
                    make.top.equalTo(superView);
                }];
            }else if(i == array.count){
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(superView);
                    make.right.equalTo(superView);
                    make.top.equalTo(itemViews[i-1].mas_bottom);
                    make.bottom.equalTo(superView);
                }];
            }else{
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(superView);
                    make.right.equalTo(superView);
                    make.top.equalTo(itemViews[i-1].mas_bottom);
                }];
            }
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = model.majorName;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        [itemView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemView).offset(20);
            make.right.equalTo(itemView).offset(-40);
            make.top.equalTo(itemView).offset(15);
            make.bottom.equalTo(itemView).offset(-15);
        }];
        
        UIImageView *rightImage = [[UIImageView alloc] init];
        rightImage.image = [UIImage imageNamed:@"fire_common_right_next"];
        [itemView addSubview:rightImage];
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(itemView).offset(-20);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.equalTo(titleLabel);
        }];
    }
    
}

@end
