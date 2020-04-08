//
//  FEIndustryViewController.m
//  smartapp
//
//  Created by mac on 2019/9/8.
//  Copyright © 2019 jeyie0. All rights reserved.
//

#import "FEIndustryViewController.h"
#import "FEOuccupationTreeViewCell.h"
#import "FEOccupationDataManager.h"
#import "FEOccupationTreeModel.h"
#import <RATreeView.h>
#import "RaTreeModel.h"

#import "OccupationDetailsViewController.h"

/**
*/
@interface FEIndustryViewController () <RATreeViewDelegate, RATreeViewDataSource>
@property (nonatomic, weak) FEOccupationDataManager *dataManager;
@property (nonatomic, weak) NSArray *treeItems;

@property (nonatomic, weak) RATreeView *treeView;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, weak) FEOccupationTreeModel *expandedCellModel; //只允许展开一个；保存当前展开的cell model


@end

@implementation FEIndustryViewController

- (void)loadView {
    [super loadView];
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    treeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    treeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:treeView];
    [treeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    _treeView = treeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  //  [_treeView registerNib:[UINib nibWithNibName:@"FEOuccupationTreeViewCell" bundle:nil] forCellReuseIdentifier:@"FEOuccupationTreeViewCell"];

    
    _type = 2;
    _treeView.delegate = self;
    _treeView.dataSource = self;
    _treeView.collapsesChildRowsWhenRowCollapses = YES;
    _dataManager = [FEOccupationDataManager sharedManager];
    [self loadData];
}


- (void)loadData {
    [_dataManager loadIndustryGatalogDataWithSuccess:^{
        _treeItems = _dataManager.industryTreeItems;
        [_treeView reloadData];
    } ifFailure:^{
        
    }];
}

#pragma mark -TreeView
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    return STWidth(60);
}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    FEOccupationTreeModel *model = item;
    NSInteger level = [treeView levelForCellForItem:item];
    if (level != 2) {
        FEOuccupationTreeViewCell *cell = (FEOuccupationTreeViewCell *)[treeView cellForItem:item];
        [cell setExpantionStatus:YES];
        
        //收起上一次展开的cell
        if (_expandedCellModel && _expandedCellModel != model) {
            if (![_expandedCellModel.children containsObject:model]) {//再判断是不是展开子节点
                [treeView collapseRowForItem:_expandedCellModel];
                FEOuccupationTreeViewCell *cell = (FEOuccupationTreeViewCell *)[treeView cellForItem:_expandedCellModel];
                [cell setExpantionStatus:NO];
                if (_expandedCellModel.parent != model.parent) { //不是同一父节点， 关闭它的父节点
                    [treeView collapseRowForItem:_expandedCellModel.parent];
                    FEOuccupationTreeViewCell *cell = (FEOuccupationTreeViewCell *)[treeView cellForItem:_expandedCellModel.parent];
                    [cell setExpantionStatus:NO];
                }
            }
        }
        
        _expandedCellModel = model;

    }
    
    if (level == 1) {
        if (model.children == nil) { //第二层需要数据请求
            [_dataManager loadLevel2DataForTreeModel:model type:_type WithSuccess:^(NSMutableArray<FEOccupationTreeModel *> *level2Items) {
                [treeView insertItemsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, level2Items.count)] inParent:item withAnimation:RATreeViewRowAnimationNone];
            } ifFailure:nil];
            
        } else { //已经请求了数据
           //doNothing
        }
    }
}



- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    NSInteger level = [treeView levelForCellForItem:item];
    if (level != 2) {
        FEOuccupationTreeViewCell *cell = (FEOuccupationTreeViewCell *)[treeView cellForItem:item];
        [cell setExpantionStatus:NO];

    }
}

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    FEOuccupationTreeViewCell *cell = [FEOuccupationTreeViewCell treeViewCellWith:treeView];

    FEOccupationTreeModel *model = item;
    NSInteger level = [treeView levelForCellForItem:item];
    
    [cell setCellWith:model.name level:level children:model.children.count ];
    return cell;
}


- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item {
    FEOccupationTreeModel *model = item;
    if (model == nil) {
        return _treeItems.count;
    }
    return model.children.count;
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    FEOccupationTreeModel *model = item;
    if (model == nil) {
        return _treeItems[index];
    }
    return model.children[index];
}

- (UITableViewCellEditingStyle)treeView:(RATreeView *)treeView editingStyleForRowForItem:(id)item {
    return UITableViewCellEditingStyleNone;
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    NSInteger level = [treeView levelForCellForItem:item];
    if (level != 2) {
        return;
    }
    
    FEOccupationTreeModel *model = item;
    
    OccupationDetailsViewController *vc = [[OccupationDetailsViewController alloc] init];
    vc.occupationId = model.ID;
    
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
