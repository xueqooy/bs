//
//  UnivesityGraChartTableViewCell.m
//  smartapp
//
//  Created by lafang on 2019/3/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "UnivesityGraChartTableViewCell.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>
#import "FEChartViewManager.h"

@interface UnivesityGraChartTableViewCell ()

@property(nonatomic,strong) UIView *chartView;

@end

@implementation UnivesityGraChartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.chartView = [[UIView alloc] init];
        [self.contentView addSubview:self.chartView];
        [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(10);
            make.height.mas_equalTo(COMMON_CHART_HEIGHT);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
    }
    
    return self;
}

-(void)updateModel:(NSArray<UniversityGraduationSettledModel *> *)universityGraduationSettledModels{
    
    [self.chartView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [FEChartViewManager addChartViewByGraduation:self.chartView reportData:universityGraduationSettledModels];

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
