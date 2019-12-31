//
//  Branch.h
//  HierarchyList
//
//  Created by Phil on 2018/5/9.
//  Copyright © 2018年 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Corp.h"
#import "Model.h"
#import "BranchTableIView.h"

@protocol HierarchyViewModelDelegate <NSObject>

- (void)attachWithTableView:(UITableView *)tableView withIndex:(NSInteger)index;
- (void)reloadwithIndex:(NSInteger)index;
- (void)reload;
- (void)hide:(NSInteger)section;

@end

@interface Branch : NSObject<Corp, HierarchyViewModelDelegate>{
    NSMutableArray *children;
}

@property BOOL isOpened;
@property BOOL isNeedReload;
@property (weak) BranchTableIView *tableView;
@property (readonly) Model *model;

//- (instancetype)initWithTableView:(UITableView*)tableView;
- (instancetype)initWithModel:(Model *)model;

@end
