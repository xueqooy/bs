//
//  FEProfessionViewController.m
//  smartapp
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEProfessionViewController.h"
#import "FEOuccupationTreeViewCell.h"
#import "FEOccupationDataManager.h"
#import "FEOccupationTreeModel.h"
#import <RATreeView.h>
#import "RaTreeModel.h"

#import "OccupationDetailsViewController.h"

/**
 复用行业分类VC, 代码可重用，结构清晰
 1.继承行业分类VC
 2.声明需要用到的父类私有方法和属性
 */

@interface FEIndustryViewController ()
@property (nonatomic, weak) FEOccupationDataManager *dataManager;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, weak) NSArray *treeItems;
@property (nonatomic, weak) RATreeView *treeView;
@property (nonatomic, weak) FEOccupationTreeModel *expandedCellModel;

//私有方法
- (void)loadData;

@end

@interface FEProfessionViewController ()

@property (nonatomic, copy) NSString *areaID;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, weak) FEOccupationTreeModel *preparedExpandCellModel; //查询时，保存将要打开item

@end

@implementation FEProfessionViewController


- (void)loadData {
    self.type = 1;
    @weakObj(self);
    [self.dataManager loadProfessGatalogDataWithSuccess:^{
        @strongObj(self);
        self.treeItems = self.dataManager.professionTreeItems;
        [self.treeView reloadData];
        
        //查询的情况下，获取要展开的项
        self.preparedExpandCellModel = [self.dataManager getTreeModelWithAreaID:_areaID areaName:_areaName];

        if (self.preparedExpandCellModel) { //需要展开查询的项，故先请求数据
            [self.dataManager loadLevel2DataForTreeModel:self.preparedExpandCellModel type:1 WithSuccess:^(NSMutableArray<FEOccupationTreeModel *> *level2Items) {
                dispatch_async(dispatch_get_main_queue(), ^{
                     [self.treeView insertItemsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, level2Items.count)] inParent:self.preparedExpandCellModel withAnimation:RATreeViewRowAnimationNone];
                        NSLog(@"-%@, %@", self.preparedExpandCellModel.name, self.preparedExpandCellModel.ID);
                    //需要先展开父节点才能展开子节点
                    [self.treeView expandRowForItem:self.preparedExpandCellModel.parent];
                    [self.treeView expandRowForItem:self.preparedExpandCellModel];
                    [self.treeView scrollToRowForItem:self.preparedExpandCellModel atScrollPosition:RATreeViewScrollPositionTop animated:NO];
                    //设置展开的Model，保持原逻辑不变
                    self.expandedCellModel = self.preparedExpandCellModel;
                });
            } ifFailure:nil];
        }
        
    } ifFailure:^{
    }];
}

//需要延迟到treeView加载完成
- (void)expandRowWithAreaID:(NSString *)areaID areaName:(NSString *)areaName {
    _areaID = areaID;
    _areaName = areaName;
}

@end
