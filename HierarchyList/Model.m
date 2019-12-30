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

@implementation Model{
    NSArray* _photoArray;
    NSMutableArray* _photoURLArray, *_photoNameArray;
}

-(instancetype)init{
    if(self = [super init]){
        items = [[NSMutableArray<FunctionModelItem> alloc] init];
//        infoTitleItems = [NSArray arrayWithObjects:
//                          _(@"Type"), _(@"Model"), _(@"MAC Address"), _(@"Serial No."), _(@"Registration"), _(@"Registration by"), _(@"Location/Network"), nil];
    }

    return self;
}
//
//-(instancetype)initWithData:(Device*)device{
//    if(self = [self init]){
//        [self updateWithData:device];
//    }
//
//    return self;
//}
//
- (void)updateWithData:(Device*)device{
    _device = device;
//    [items removeAllObjects];
//
//    if(device){
//        [self initItemsAddToArray:items];
//    }
}
//
//- (void)initItemsAddToArray:(NSMutableArray<FunctionModelItem>*)items {
//    [items addObject:[[FunctionModelDeviceDetailItem alloc] initWithRowCount:[infoTitleItems count]]];
//    [items addObject:[[FunctionModelLocationItem alloc] init]];
//    [items addObject:[[FunctionModelPhotoItem alloc] init]];
//    [items addObject:[[FunctionModelNoteItem alloc] init]];
//}
//

- (void)addItem:(id<FunctionModelItem>)item{
    [items addObject:item];
}

//- (void)updateWithPhotoArray:(NSArray*)photoArray{
//    _photoArray = [photoArray copy];
//    _photoURLArray = [NSMutableArray array];
//    _photoNameArray = [NSMutableArray array];
//    for(Photo* photo in _photoArray){
//        [_photoURLArray addObject:photo.url];
//        [_photoNameArray addObject:photo.name];
//    }
//}
//
//- (NSString*)getDeivceTypeString:(DeviceType)type{
//    NSString* deivceTypeString = nil;
//    switch (type) {
//        case DeviceAPType:
//            deivceTypeString = @"AP";
//            break;
//        case DeviceSwitchType:
//            deivceTypeString = @"SWITCH";
//            break;
//        case DeviceCameraType:
//            deivceTypeString = @"IPCAM";
//            break;
//    }
//    return deivceTypeString;
//}

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
//                cell.titleLabel.text = [infoTitleItems objectAtIndex:[indexPath row]];
//                cell.editableInfo.keyboardType = UIKeyboardTypeDefault;
//                cell.editableInfo.secureTextEntry = NO;
//                cell.editableInfo.leftView = nil;
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                cell.tableView = branch;
//                cell.tableView.dataSource = self;
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
                //                cell.titleLabel.text = [infoTitleItems objectAtIndex:[indexPath row]];
                //                cell.editableInfo.keyboardType = UIKeyboardTypeDefault;
                //                cell.editableInfo.secureTextEntry = NO;
                //                cell.editableInfo.leftView = nil;
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

-(void)hideAll:(UITableView*)tableView{
    
    for(int section = 0; section < [items count]; section++){
        [self hideRows:![self hiddenRowsinSection:section] inSection:section];
        
        if([self hiddenRowsinSection:section]){
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

-(void)loadAll:(UITableView*)tableView{
    for(int section = 0; section < [tableView numberOfSections]; section++){
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    for(int section = 0; section < [items count]; section++){
//        if([self hiddenRowsinSection:section]){
        [tableView insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
//        }else{
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
//        }
    }
}

#pragma mark - BranchTableViewCellDelegate
- (void)didClickInSection:(NSInteger)section {
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self hideRows:![self hiddenRowsinSection:section] inSection:section];
        [self.delegate hide:section];
//        [self.delegate reload];
    });
}

@end
