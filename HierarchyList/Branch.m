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

-(instancetype)init{
    if(self = [super init]){
//        self.tableView = [[UITableView alloc] init];
        children = [NSMutableArray array];
        model = [[Model alloc] init];
        [model updateWithData:self.device];
//        [model setde]
//        tableView.delegate = model;
        model.delegate = self;
//        model.tableView = self.tableView;
//        self.tableView.dataSource = model;
        self.isOpened = NO;
        
//        [self.tableView registerNib:[UINib nibWithNibName:BranchTableViewCell.identifier bundle:nil] forCellReuseIdentifier:BranchTableViewCell.identifier];
//        [self.tableView registerNib:[UINib nibWithNibName:LeafTableViewCell.identifier bundle:nil] forCellReuseIdentifier:LeafTableViewCell.identifier];
//        [self.tableView registerNib:[UINib nibWithNibName:@"BranchHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"BranchHeaderView"];
//        tableView.estimatedRowHeight = 44;
//        tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    return self;
}

-(instancetype)initWithTableView:(UITableView*)_tableView{
    if(self = [self init]){
        self.tableView = _tableView;
        self.tableView.dataSource = model;
        self.tableView.delegate = self;
    }
    
    return self;
}

- (instancetype)initWithDevice:(Device*)device
{
    self = [self init];
    if (self) {
        self.device = device;
    }
    return self;
}

-(void)attachWithTableView:(BranchTableIView*)tableView withIndex:(NSInteger)index{
//    model.tableView = self.tableView;
//    self.tableView.dataSource = model;
    
    Branch *branch = [children objectAtIndex:index];
//    if(branch.tableView){
//        [branch.tableView updateTableHeight];
//        return;
//    }
//    NSLock *lock = [[NSLock alloc] init];
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    if(branch.tableView && branch.tableView != tableView){
        
        branch.isNeedReload = YES;
    }
    
    if(tableView.bindedBranch && tableView.bindedBranch != branch){
        tableView.bindedBranch.isNeedReload = YES;
    }
    
    tableView.bindedBranch = branch;
    branch.tableView = tableView;
    branch.tableView.dataSource = branch->model;
    branch.tableView.delegate = branch;
//    [branch.tableView beginUpdates];
    

    
        
//    [branch.tableView endUpdates];
//    [lock lock];
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//    dispatch_release(sema);
}

-(void)reloadwithIndex:(NSInteger)index{
    Branch *branch = [children objectAtIndex:index];
    
    
    [UIView setAnimationsEnabled:NO];
    
        if(branch.isNeedReload){
            branch.isNeedReload = NO;
            [branch.tableView performBatchUpdates:^{
                [branch->model loadAll:branch.tableView];
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
    
//    [self loopUpdate:branch];
        
        
    
    return;
    dispatch_async(dispatch_get_main_queue(), ^{
    [branch.tableView reloadDataWithCompletion:^{
//        [branch.tableView setNeedsLayout];
//        [branch.tableView invalidateIntrinsicContentSize];
//        [self.tableView setNeedsLayout];
//        [self.tableView invalidateIntrinsicContentSize];
//        [self.tableView setNeedsUpdateConstraints];
        BOOL needLoopUpdate = YES;
        for (id<Corp> child in branch.getChildren) {
            if([child isKindOfClass:[Branch class]] && !((Branch*)child).isOpened){
                needLoopUpdate = NO;
            }
        }
        
        if(needLoopUpdate){
            [self loopUpdate];
        }
        
        
        //        [branch.tableView layoutIfNeeded];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [self.tableView reloadDataWithCompletion:^{
        ////                [self.tableView setNeedsLayout];
        //    //            [self.tableView layoutIfNeeded];
        ////                [self.tableView setNeedsDisplay];
        //            }];
        //        });
        //        dispatch_semaphore_signal(sema);
        //        [lock unlock];
    }];
    });
}

-(void)reload{
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

-(void)hide:(NSInteger)section{
    Branch *branch = [children objectAtIndex:section];
    [branch click];
    
    [UIView setAnimationsEnabled:NO];
    
    
    [branch.tableView performBatchUpdates:^{
        [branch->model hideAll:branch.tableView];


    } completion:^(BOOL finished) {
//        [self loopUpdate:branch];
        [branch.tableView setNeedsUpdateConstraints];
        [branch.tableView needsUpdateConstraints];
        [branch.tableView setNeedsLayout];
        [branch.tableView layoutIfNeeded];
        [branch.tableView.superview setNeedsLayout];
        [branch.tableView.superview layoutIfNeeded];
    }];

    [UIView setAnimationsEnabled:YES];
    
//    [self reloadwithIndex:section];
    
    
//    if(self.superNode){
        [self loopUpdate:branch];
//    }
//    [self uu:section];
}

-(void)loopUpdate{
//    [self.tableView beginUpdates];
//    [self.tableView endUpdates];
//    dispatch_async(dispatch_get_main_queue(), ^{
    [UIView setAnimationsEnabled:NO];

    
        [self.tableView performBatchUpdates:nil completion:^(BOOL finished) {
            
        }];
    
    if(self.superNode){
        [self.superNode loopUpdate];
    }
    [UIView setAnimationsEnabled:YES];
    
    
//    });
}

-(void)add:(id<Corp>)corp{
    if(corp.superNode){
        [corp.superNode remove:corp];
    }
    [children addObject:corp];
    corp.superNode = self;
    
    if([corp isKindOfClass:[Branch class]]){
        FunctionModelBranchItem *branchItem = [[FunctionModelBranchItem alloc] initWithRowCount:1];
        [branchItem updateWithData:corp.device];
        [model addItem:branchItem];
    }else{
        FunctionModelLeafItem *leafItem = [[FunctionModelLeafItem alloc] initWithRowCount:1];
        [leafItem updateWithData:corp.device];
        [model addItem:leafItem];
    }
    
//    [self.tableView reloadData];
}

-(void)remove:(id<Corp>)corp{
    if([children containsObject:corp]){
        [children removeObject:corp];
        corp.superNode = nil;
    }
}

-(NSArray *)getChildren{
    return children;
}

-(void)click{
    self.isOpened = !self.isOpened;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(![model getSectionTitleinSection:section]){
        return 0;
    }
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return nil;
//    }
    BranchHeaderView* sectionHeaderView = (BranchHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BranchHeaderView"];
    sectionHeaderView.delegate = self;
    sectionHeaderView.arrowImageView.hidden = YES;
    sectionHeaderView.titleLabel.text = [model getSectionTitleinSection:section];
    sectionHeaderView.subTitleLabel.text = @"";
    sectionHeaderView.leftIcon.image = [model getSectionLeftIconinSection:section];
    sectionHeaderView.tag = section;
    sectionHeaderView.arrowImageView.highlighted = ![model hiddenRowsinSection:section];
    
    return sectionHeaderView;
}

#pragma mark - NetworkUsageHeaderViewDelegate
- (void)didClickAccessButtonInSection:(NSInteger)section {
    dispatch_async(dispatch_get_main_queue(), ^{
        Branch *branch = [children objectAtIndex:section];
        [branch click];
        
//        [self reload];
        [self uu:section];
    });
}

-(void)uu:(NSInteger)section{
//    [UIView setAnimationsEnabled:NO];
    
    [UIView animateWithDuration:0 animations:^{
        [self.tableView performBatchUpdates:^{
            [model hideRows:![model hiddenRowsinSection:section] inSection:section];
            if([model hiddenRowsinSection:section]){
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
                
            }else{
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView layoutIfNeeded];
        } completion:^(BOOL finished) {
//            [UIView setAnimationsEnabled:YES];
//            [self.tableView updateTableHeight];
            [self.tableView layoutIfNeeded];
        }];
    }];

    
//    BOOL needLoopUpdate = YES;
//    for (id<Corp> child in self.getChildren) {
//        if([child isKindOfClass:[Branch class]] && !((Branch*)child).isOpened){
//            needLoopUpdate = NO;
//        }
//    }
//
//    if(needLoopUpdate){
//        [self.superNode loopUpdate:self];
//    }
//    [UIView setAnimationsEnabled:YES];
    
    if(self.superNode){
        [self.superNode loopUpdate:self];
    }
    
    
}

-(void)loopUpdate:(id<Corp>)calledChild{
    dispatch_async(dispatch_get_main_queue(), ^{

    
//    [UIView setAnimationsEnabled:NO];
    
    NSInteger section = [children indexOfObject:calledChild];
    [self.tableView performBatchUpdates:^{
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView setNeedsUpdateConstraints];
//        [self.tableView needsUpdateConstraints];
//        [self.tableView setNeedsLayout];
//        [self.tableView layoutIfNeeded];
//        [self.tableView.superview setNeedsLayout];
//        [self.tableView.superview layoutIfNeeded];
    }completion:^(BOOL finished) {
        
    }];
    
//    [UIView setAnimationsEnabled:YES];
        });
    
    if(self.superNode){
        [self.superNode loopUpdate:self];
    }
    
}


@end
