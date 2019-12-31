//
//  Model.m
//  HierarchyList
//
//  Created by Phil on 2018/5/9.
//  Copyright © 2018年 Phil. All rights reserved.
//

#import "Model.h"
#import "FunctionModelBranchItem.h"
#import "Device.h"
#import "BranchTableViewCell.h"
#import "LeafTableViewCell.h"

@interface Model(Protected)

- (void)initItemsAddToArray:(NSMutableArray<FunctionModelItem>*)items;

@end

@implementation Model

- (instancetype)init {
    if(self = [super init]){
        items = [[NSMutableArray<FunctionModelItem> alloc] init];
    }

    return self;
}

- (void)updateWithData:(Device*)device {
    _device = device;
}

- (void)addItem:(id<FunctionModelItem>)item {
    [items addObject:item];
}

- (NSString*)getSectionTitleinSection:(NSInteger)section {
    return [items[section] sectionTitle];
}

- (UIImage*)getSectionLeftIconinSection:(NSInteger)section {
    return [items[section] sectionLeftIcon];
}

- (FunctionType)getFunctionTypeinSection:(NSInteger)section {
    return [(id<FunctionModelItem>)items[section] type];
}

- (void)hideRows:(BOOL)hide inSection:(NSInteger)section {
    [items[section] setHideCells:hide];
}

- (BOOL)hiddenRowsinSection:(NSInteger)section {
    return [items[section] hideCells];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return items.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items[section] rowCount];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    id<FunctionModelItem> item = [items objectAtIndex:indexPath.section];
    switch (item.type) {
        case BRANCH:
        {
            BranchTableViewCell* cell =
            (BranchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:BranchTableViewCell.identifier forIndexPath:indexPath];
            if(cell){
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.tag = indexPath.section;
                cell.delegate = self;
                [self.delegate attachWithTableView:cell.tableView withIndex:indexPath.section];
                [self.delegate reloadwithIndex:indexPath.section];
                [cell layoutIfNeeded];
                return cell;
            }
        }
        case LEAF:
        {
            LeafTableViewCell* cell =
            (LeafTableViewCell*)[tableView dequeueReusableCellWithIdentifier:LeafTableViewCell.identifier forIndexPath:indexPath];
            if(cell){
                cell.nameLabel.text = [item rowTitleForIndex:indexPath.row];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
        }
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

- (void)hideAll:(UITableView *)tableView {
    
    for(int section = 0; section < [items count]; section++){
        [self hideRows:![self hiddenRowsinSection:section] inSection:section];
        
        if([self hiddenRowsinSection:section]){
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)loadAll:(UITableView *)tableView {
    for(int section = 0; section < [tableView numberOfSections]; section++){
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    for(int section = 0; section < [items count]; section++){
        [tableView insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - BranchTableViewCellDelegate
- (void)didClickInSection:(NSInteger)section {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate hide:section];
    });
}

@end
