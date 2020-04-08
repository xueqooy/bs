
//
//  FacultyStrengthTableViewCell.m
//  smartapp
//  师资力量cell
//  Created by lafang on 2019/3/13.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FacultyStrengthTableViewCell.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>
#import "FacultyStrengthView.h"

@interface FacultyStrengthTableViewCell ()

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIView *itemsView;

@end

@implementation FacultyStrengthTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.contentView).offset(10);
        }];
        
        self.itemsView = [[UIView alloc] init];
        [self.contentView addSubview:self.itemsView];
        [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView);
//            make.height.mas_equalTo(100);
        }];
        
        
        
    }
    self.contentView.backgroundColor = [UIColor whiteColor];
    return self;
}

-(void)updateModel:(UniverSitynameItemModel *)univerSitynameItemModel{
    if(!univerSitynameItemModel){
        return;
    }
    
    self.univerSitynameItemModel = univerSitynameItemModel;
    
    self.titleLabel.text = univerSitynameItemModel.type;
    
    NSArray<UniverSitynameItemModel *> *items = univerSitynameItemModel.items;
    
    CGFloat w = mScreenWidth/3;
    
    NSInteger row = items.count/3;
    if(items.count%3>0){
        row ++;
    }
    
    [self.itemsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(80 * row);
    }];
    
    
    for(int i=0;i<items.count;i++){
        FacultyStrengthView *itemView = [[FacultyStrengthView alloc] initWithTabFrame:CGRectMake((i%3)*w, (i/3)*80, w, 110) imageUrl:@"" numStr:[items[i].total stringValue] nameStr:items[i].name];
        [self.itemsView addSubview:itemView];
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
