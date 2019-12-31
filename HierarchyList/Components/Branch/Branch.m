//
//  Branch.m
//  HierarchyList
//
//  Created by Phil on 2018/5/9.
//  Copyright © 2018年 Phil. All rights reserved.
//

#import "Branch.h"
#import "FunctionModelItem.h"
#import "FunctionModelBranchItem.h"
#import "FunctionModelLeafItem.h"
#import "BranchTableViewCell.h"
#import "LeafTableViewCell.h"
#import "BranchHeaderView.h"

@interface Branch()<UITableViewDelegate, DeviceDetailHeaderViewDelegate>
@end

@implementation Branch

@synthesize superNode;
@synthesize device;

//- (instancetype)init {
//    if(self = [super init]){
//        children = [NSMutableArray array];
//        _model = [[Model alloc] init];
//        [_model updateWithData:self.device];
//        _model.delegate = self;
//        self.isOpened = NO;
//    }
//
//    return self;
//}

- (instancetype)initWithModel:(Model *)model {
    if(self = [super init]){
//        [_model updateWithData:self.device];
//        _model.delegate = self;
//        self.device = _model.device;
        self.tableView = _model.tableView;
        self.tableView.dataSource = _model;
        self.tableView.delegate = self;
        self.isOpened = NO;
    }
    
    return self;
}

- (instancetype)initWithDevice:(Device *)device {
    self = [self init];
    if (self) {
        self.device = device;
    }
    return self;
}

- (void)attachWithTableView:(BranchTableIView*)tableView withIndex:(NSInteger)index {
    Branch *branch = [children objectAtIndex:index];

    if(branch.tableView && branch.tableView != tableView){
        
        branch.isNeedReload = YES;
    }
    
    if(tableView.bindedBranch && tableView.bindedBranch != branch){
        tableView.bindedBranch.isNeedReload = YES;
    }
    
    tableView.bindedBranch = branch;
    branch.tableView = tableView;
    branch.tableView.dataSource = branch->_model;
    branch.tableView.delegate = branch;
}

- (void)reloadwithIndex:(NSInteger)index {
    Branch *branch = [children objectAtIndex:index];
    
    
    [UIView setAnimationsEnabled:NO];
    
    if(branch.isNeedReload){
        branch.isNeedReload = NO;
        [branch.tableView performBatchUpdates:^{
            [branch->_model loadAll:branch.tableView];
        } completion:^(BOOL finished) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [branch.tableView performBatchUpdates:^{
                    //
                    
                } completion:^(BOOL finished) {
                    
                    BOOL needLoopUpdate = YES;
                    for (id<Corp> child in branch.getChildren) {
                        if([child isKindOfClass:[Branch class]] && !((Branch*)child).isOpened){
                            needLoopUpdate = NO;
                        }
                    }
                    
                    if(needLoopUpdate){
                        [self loopUpdate];
                    }
                    
                }];
                
            });
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [branch.tableView performBatchUpdates:^{
                //
                
            } completion:^(BOOL finished) {
                
                BOOL needLoopUpdate = YES;
                for (id<Corp> child in branch.getChildren) {
                    if([child isKindOfClass:[Branch class]] && !((Branch*)child).isOpened){
                        needLoopUpdate = NO;
                    }
                }
                
                if(needLoopUpdate){
                    [self loopUpdate];
                }
                
            }];
        
        });
    }
        
    [UIView setAnimationsEnabled:YES];
}

- (void)reload {
    [self.tableView reloadDataWithCompletion:^{
        BOOL needLoopUpdate = YES;
        for (id<Corp> child in self.getChildren) {
            if([child isKindOfClass:[Branch class]] && !((Branch*)child).isOpened){
                needLoopUpdate = NO;
            }
        }

        if(needLoopUpdate){
            [self loopUpdate];
        }
    }];
}

- (void)hide:(NSInteger)section {
    Branch *branch = [children objectAtIndex:section];
    [branch click];
    
    [UIView setAnimationsEnabled:NO];
    
    [branch.tableView performBatchUpdates:^{
        [branch->_model hideAll:branch.tableView];
    } completion:^(BOOL finished) {
        [branch.tableView setNeedsUpdateConstraints];
        [branch.tableView needsUpdateConstraints];
        [branch.tableView setNeedsLayout];
        [branch.tableView layoutIfNeeded];
        [branch.tableView.superview setNeedsLayout];
        [branch.tableView.superview layoutIfNeeded];
    }];

    [UIView setAnimationsEnabled:YES];

    [self loopUpdate:branch];
}

- (void)loopUpdate {
    [UIView setAnimationsEnabled:NO];
    [self.tableView performBatchUpdates:nil completion:^(BOOL finished) {
        
    }];
    
    if(self.superNode){
        [self.superNode loopUpdate];
    }
    [UIView setAnimationsEnabled:YES];
}

- (void)add:(id<Corp>)corp {
    if(corp.superNode){
        [corp.superNode remove:corp];
    }
    [children addObject:corp];
    corp.superNode = self;
    
    if([corp isKindOfClass:[Branch class]]){
        FunctionModelBranchItem *branchItem = [[FunctionModelBranchItem alloc] initWithRowCount:1];
//        [branchItem updateWithData:corp.device];
        [_model addItem:branchItem];
    }else{
        FunctionModelLeafItem *leafItem = [[FunctionModelLeafItem alloc] initWithRowCount:1];
//        [leafItem updateWithData:corp.device];
        [_model addItem:leafItem];
    }
}

- (void)remove:(id<Corp>)corp {
    if([children containsObject:corp]){
        [children removeObject:corp];
        corp.superNode = nil;
    }
}

- (NSArray *)getChildren {
    return children;
}

- (void)click {
    self.isOpened = !self.isOpened;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(![_model getSectionTitleinSection:section]){
        return 0;
    }
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BranchHeaderView* sectionHeaderView = (BranchHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BranchHeaderView"];
    sectionHeaderView.delegate = self;
    sectionHeaderView.arrowImageView.hidden = YES;
    sectionHeaderView.titleLabel.text = [_model getSectionTitleinSection:section];
    sectionHeaderView.subTitleLabel.text = @"";
    sectionHeaderView.leftIcon.image = [_model getSectionLeftIconinSection:section];
    sectionHeaderView.tag = section;
    sectionHeaderView.arrowImageView.highlighted = ![_model hiddenRowsinSection:section];
    
    return sectionHeaderView;
}

#pragma mark - NetworkUsageHeaderViewDelegate
- (void)didClickAccessButtonInSection:(NSInteger)section {
    dispatch_async(dispatch_get_main_queue(), ^{
        Branch *branch = [children objectAtIndex:section];
        [branch click];

        [self uu:section];
    });
}

- (void)uu:(NSInteger)section {
    [UIView animateWithDuration:0 animations:^{
        [self.tableView performBatchUpdates:^{
            [_model hideRows:![_model hiddenRowsinSection:section] inSection:section];
            if([_model hiddenRowsinSection:section]){
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
                
            }else{
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.tableView layoutIfNeeded];
        }];
    }];
    
    if(self.superNode){
        [self.superNode loopUpdate:self];
    }
}

-(void)loopUpdate:(id<Corp>)calledChild{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger section = [children indexOfObject:calledChild];
        
        [self.tableView performBatchUpdates:^{
        
        } completion:^(BOOL finished) {
            
        }];
    });
    
    if(self.superNode){
        [self.superNode loopUpdate:self];
    }
}


@end
