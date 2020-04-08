//
//  StudentSummaryTableViewCell.m
//  smartapp
//  学生概括
//  Created by lafang on 2019/3/18.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "StudentSummaryTableViewCell.h"
#import "UIView+Extension.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import <Masonry/Masonry.h>
#import "DVPieChart.h"
#import "DVFoodPieModel.h"
#import "StringUtils.h"

@interface StudentSummaryTableViewCell ()

@property(nonatomic,strong) UIView *pieChartView;
@property(nonatomic,strong) UIView *pieManWomenView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *titleLabel2;//本科生数量


@end

@implementation StudentSummaryTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.pieChartView = [[UIView alloc] init];
        [self.contentView addSubview:self.pieChartView];
        [self.pieChartView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(20);
            make.height.mas_equalTo(200);
        }];
        
        self.pieManWomenView = [[UIView alloc] init];
        [self.contentView addSubview:self.pieManWomenView];
        [self.pieManWomenView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.pieChartView.mas_bottom);
            make.height.mas_equalTo(200);
            make.bottom.equalTo(self.contentView);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.text = @"在校生数据";
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.pieChartView);
        }];

        self.titleLabel2 = [[UILabel alloc] init];
        self.titleLabel2.textColor = [UIColor colorWithHexString:@"333333"];
        self.titleLabel2.font = [UIFont systemFontOfSize:15];
        self.titleLabel2.text = @"男女比例";
        self.titleLabel2.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel2];
        [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.pieManWomenView);
        }];
        
    }
    
    return self;
}

-(void)updateModel:(StudentDataModel *)studentDataModel studentRatioModel:(StudentRatioModel *)studentRatioModel{
    
    
    
    [self addPieChartViewData:studentDataModel];
    
    [self addManWomenPieViewData:studentRatioModel];
    
}

-(void)addPieChartViewData:(StudentDataModel *)studentDataModel{
    
    [self.pieChartView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(studentDataModel){
        DVPieChart *chart = [[DVPieChart alloc] initWithFrame:CGRectMake(40, 0, mScreenWidth-80, 200)];
        [self.pieChartView addSubview:chart];
        
        CGFloat total = [studentDataModel.undergraduateStudents integerValue] + [studentDataModel.postgraduatesStudents integerValue] + [studentDataModel.internationalStudents integerValue];
        
        NSMutableArray *modelArr = [[NSMutableArray alloc] init];
        for(int i=0;i<3;i++){
            
            DVFoodPieModel *model = [[DVFoodPieModel alloc] init];
            
            if(i==0){
                model.rate = [studentDataModel.undergraduateStudents integerValue] * 1.00f / total;
                model.name = @"本科生";
                model.value = [studentDataModel.undergraduateStudents integerValue];
            }else if(i == 1){
                model.rate = [studentDataModel.postgraduatesStudents integerValue] * 1.00f / total;;
                model.name = @"研究生";
                model.value = [studentDataModel.postgraduatesStudents integerValue];
            }else{
                model.rate = [studentDataModel.internationalStudents integerValue] * 1.00f / total;;
                model.name = @"国际学生";
                model.value = [studentDataModel.internationalStudents integerValue];
            }
            
            [modelArr addObject:model];
        }
        
        chart.dataArray = modelArr;
        
        chart.title = @"";
        
        [chart draw];
    }else{
        UILabel *noneLabel = [StringUtils createLabel:@"-暂无数据-" color:@"666666" font:16];
        [self.pieChartView addSubview:noneLabel];
        [noneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.pieChartView);
        }];
    }
    
    
}

-(void)addManWomenPieViewData:(StudentRatioModel *)studentRatioModel{
    
    [self.pieManWomenView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(studentRatioModel){
        DVPieChart *chart = [[DVPieChart alloc] initWithFrame:CGRectMake(40, 0, mScreenWidth-80, 200)];
        [self.pieManWomenView addSubview:chart];
        
        
        NSMutableArray *modelArr = [[NSMutableArray alloc] init];
        for(int i=0;i<2;i++){
            
            DVFoodPieModel *model = [[DVFoodPieModel alloc] init];
            
            if(i==0){
                model.rate = [studentRatioModel.menRatio doubleValue];
                model.name = @"男生";
                model.value = [studentRatioModel.menRatio doubleValue] * [studentRatioModel.studentsTotal integerValue];
            }else{
                model.rate = [studentRatioModel.womenRatio doubleValue];
                model.name = @"女生";
                model.value = [studentRatioModel.womenRatio doubleValue] * [studentRatioModel.studentsTotal integerValue];
            }
            
            [modelArr addObject:model];
        }
        
        chart.dataArray = modelArr;
        
        chart.title = @"";
        
        [chart draw];
    }else{
        UILabel *noneLabel = [StringUtils createLabel:@"-暂无数据-" color:@"666666" font:16];
        [self.pieManWomenView addSubview:noneLabel];
        [noneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.pieManWomenView);
        }];
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
