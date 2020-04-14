//
//  ZJFourChildView.m
//  smartapp
//
//  Created by lafang on 2019/2/21.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "ZJFourChildView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Category.h"
#import "FEBaseViewController.h"
#import "ZJChooseViewOneLeftCell.h"

@interface ZJFourChildView()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation ZJFourChildView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.seleIndex = 0;
        [self setUpAllView];
    }
    return self;
}

-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    [self.mainTable reloadData];
}

-(void)setUpAllView{
    
    self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 0) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.rowHeight = 45;
    [self addSubview:self.mainTable];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZJChooseViewOneLeftCell *cell = [ZJChooseViewOneLeftCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLab.text = self.titleArray[indexPath.row];
    if (indexPath.row == self.seleIndex) {
        cell.threeIsSelected = YES;
    }else{
        cell.threeIsSelected = NO;
        cell.arrowImgV.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.seleIndex = indexPath.row;
    [self.mainTable reloadData];
    if ([self.delegate respondsToSelector:@selector(fourViewTableviewDidSelectedWithIndex:)]) {
        [self.delegate fourViewTableviewDidSelectedWithIndex:indexPath.row];
    }
}

@end
