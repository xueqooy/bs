//
//  CollegeAdmissionTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/4/1.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "CollegeAdmissionTableViewCell.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>
#import "StringUtils.h"
#import "CommonBottomMenuView.h"
#import "YTKKeyValueStore.h"
#import "ConstantConfig.h"
#import "ProvinceRootModel.h"
#import "CareerService.h"

@interface CollegeAdmissionTableViewCell ()

@property(nonatomic,strong) UIView *itemView;
@property(nonatomic,strong) UIView *menuView;
@property(nonatomic,strong) UIButton *provinceBtn;
@property(nonatomic,strong) UIButton *kindBtn;

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UILabel *pcLabel;
@property(nonatomic,strong) UILabel *yearLabel;
@property(nonatomic,strong) UILabel *zdfpmLabel;
@property(nonatomic,strong) UILabel *xcLabel;
@property(nonatomic,strong) UILabel *plqsLabel;

@property(nonatomic,strong) UIView *listView;

//@property(nonatomic,strong) UILabel *moreLabel;

@property(nonatomic,assign) CGFloat tableWidth;

@end

@implementation CollegeAdmissionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        
        self.tableWidth = mScreenWidth/5;
        
        self.itemView = [[UIView alloc] init];
        [self.contentView addSubview:self.itemView];
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        
        self.menuView = [[UIView alloc] init];
        [self.itemView addSubview:self.menuView];
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemView);
            make.right.equalTo(self.itemView);
            make.top.equalTo(self.itemView);
            make.height.mas_equalTo(50);
        }];
        
        self.provinceBtn = [StringUtils createButton:@"生源地" color:@"666666" font:13];
        [self.provinceBtn addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.provinceBtn setImage:[UIImage imageNamed:@"career_filter_bottom"] forState:UIControlStateNormal];
        self.provinceBtn.layer.masksToBounds = YES;
        self.provinceBtn.layer.cornerRadius = 5;
        self.provinceBtn.layer.borderWidth = 1;
        self.provinceBtn.layer.borderColor = [UIColor colorWithHexString:@"666666"].CGColor;
        [self.menuView addSubview:self.provinceBtn];
        [self.provinceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.menuView).offset(mScreenWidth/4-40);
            make.centerY.equalTo(self.menuView);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        [self.provinceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.provinceBtn.imageView.size.width, 0, self.provinceBtn.imageView.size.width)];
        [self.provinceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.provinceBtn.titleLabel.bounds.size.width, 0, -self.provinceBtn.titleLabel.bounds.size.width)];
        

        
        self.kindBtn = [StringUtils createButton:@"文理" color:@"666666" font:13];
        [self.kindBtn addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.kindBtn setImage:[UIImage imageNamed:@"career_filter_bottom"] forState:UIControlStateNormal];
        self.kindBtn.layer.masksToBounds = YES;
        self.kindBtn.layer.cornerRadius = 5;
        self.kindBtn.layer.borderWidth = 1;
        self.kindBtn.layer.borderColor = [UIColor colorWithHexString:@"666666"].CGColor;
        [self.menuView addSubview:self.kindBtn];
        [self.kindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.menuView).offset(-(mScreenWidth/4-40));
            make.centerY.equalTo(self.menuView);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        [self.kindBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.kindBtn.imageView.size.width, 0, self.kindBtn.imageView.size.width)];
        [self.kindBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.kindBtn.titleLabel.bounds.size.width, 0, -self.kindBtn.titleLabel.bounds.size.width)];
        
        self.topView = [[UIView alloc] init];
        self.topView.backgroundColor = [UIColor colorWithHexString:@"ffab61"];
        [self.itemView addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.itemView);
            make.top.equalTo(self.menuView.mas_bottom);
            make.height.mas_equalTo(40);
        }];
        
        self.pcLabel = [StringUtils createLabel:@"批次" color:@"ffffff" font:13];
        self.pcLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:self.pcLabel];
        [self.pcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topView);
            make.centerY.equalTo(self.topView);
            make.width.mas_equalTo(self.tableWidth);
        }];
        
        self.yearLabel = [StringUtils createLabel:@"年份" color:@"ffffff" font:13];
        self.yearLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:self.yearLabel];
        [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pcLabel.mas_right);
            make.centerY.equalTo(self.topView);
            make.width.mas_equalTo(self.tableWidth);
        }];
        
        self.zdfpmLabel = [StringUtils createLabel:@"最低分/排名" color:@"ffffff" font:13];
        self.zdfpmLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:self.zdfpmLabel];
        [self.zdfpmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.yearLabel.mas_right);
            make.centerY.equalTo(self.topView);
            make.width.mas_equalTo(self.tableWidth);
        }];
        
        self.xcLabel = [StringUtils createLabel:@"线差" color:@"ffffff" font:13];
        self.xcLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:self.xcLabel];
        [self.xcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.zdfpmLabel.mas_right);
            make.centerY.equalTo(self.topView);
            make.width.mas_equalTo(self.tableWidth);
        }];
        
        self.plqsLabel = [StringUtils createLabel:@"录取数" color:@"ffffff" font:14];
        self.plqsLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:self.plqsLabel];
        [self.plqsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.xcLabel.mas_right);
            make.centerY.equalTo(self.topView);
            make.width.mas_equalTo(self.tableWidth);
        }];
        
        self.listView = [[UIView alloc] init];
        [self.itemView addSubview:self.listView];
        [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.itemView);
            make.top.equalTo(self.topView.mas_bottom);
            make.bottom.equalTo(self.itemView);
        }];
        
//        self.moreLabel = [StringUtils createLabel:@"查看跟多 >" color:@"3b96ff" font:14];
//        self.moreLabel.textAlignment = NSTextAlignmentCenter;
//        [self.itemView addSubview:self.moreLabel];
//        [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.itemView);
//            make.top.equalTo(self.listView.mas_bottom);
//            make.height.mas_equalTo(40);
//            make.bottom.equalTo(self.itemView);
//        }];
        
        
    }
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    return self;
}

-(void)filterBtnClick:(UIButton *)btn{
    if(btn == self.provinceBtn){
        //生源地筛查
        if(self.filterCallBack){
            self.filterCallBack(1);
        }
    }else{
        //文理科筛查
        if(self.filterCallBack){
            self.filterCallBack(2);
        }
    }
}

-(void)updateModel:(NSArray<UniversityAdminsionModel *> *)models curProvince:(NSString *)curProvince curKind:(NSString *)curKind{
    
    [self.provinceBtn setTitle:curProvince forState:UIControlStateNormal];
    
    [self.kindBtn setTitle:curKind forState:UIControlStateNormal];
    
    if(models && models.count>0){
        [self.listView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        NSMutableArray<UIView *> *itemViews = [[NSMutableArray alloc] init];
        for(int i=0;i<models.count;i++){
            UIView *itemView = [[UIView alloc] init];
            [self.listView addSubview:itemView];
            [itemViews addObject:itemView];
            
            if(i%2 == 0){
                itemView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
            }else{
                itemView.backgroundColor = [UIColor colorWithHexString:@"fff4e2"];
            }
            
            if(models.count == 1){
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.listView);
                    make.right.equalTo(self.listView);
                    make.top.equalTo(self.listView);
                    make.bottom.equalTo(self.listView);
                }];
            }else{
                if(i == 0){
                    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.listView);
                        make.right.equalTo(self.listView);
                        make.top.equalTo(self.listView);
                    }];
                }else if(i==models.count-1){
                    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.listView);
                        make.right.equalTo(self.listView);
                        make.top.equalTo(itemViews[i-1].mas_bottom);
                        make.bottom.equalTo(self.listView);
                    }];
                }else{
                    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.listView);
                        make.right.equalTo(self.listView);
                        make.top.equalTo(itemViews[i-1].mas_bottom);
                    }];
                }
            }
            
            UniversityAdminsionModel *model = models[i];
            for(int j=0;j<5;j++){
                UILabel *label;
                if(j==0){
                    
                    label = [StringUtils createLabel:[NSString stringWithFormat:@"%@%@",(model.bkcc ? model.bkcc : @""),model.batch] color:@"666666" font:12];
                }else if(j==1){
                    label = [StringUtils createLabel:[model.year stringValue] color:@"666666" font:12];
                }else if(j==2){
                    label = [StringUtils createLabel:[NSString stringWithFormat:@"%@/%@",[model.lowScore stringValue],[model.lowWc stringValue]] color:@"666666" font:12];
                }else if(j==3){
                    label = [StringUtils createLabel:[NSString stringWithFormat:@"%li",[model.lowScore integerValue]-[model.provinceScore integerValue]] color:@"666666" font:12];
                }else{
                    label = [StringUtils createLabel:[model.luquNum stringValue] color:@"666666" font:12];
                }
                label.textAlignment = NSTextAlignmentCenter;
                label.numberOfLines = 0;
                [itemView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(itemView).offset(j*self.tableWidth);
                    make.width.mas_equalTo(self.tableWidth);
                    make.top.equalTo(itemView).offset(10);
                    make.bottom.equalTo(itemView).offset(-10);
                }];
            }
            
        }
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
