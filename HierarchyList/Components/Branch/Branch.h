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

@interface Branch : NSObject<Corp, HierarchyViewModelDelegate>{
    NSMutableArray *children;
    Model *model;
}

@property BOOL isOpened;
@property BOOL isNeedReload;
@property (weak) BranchTableIView *tableView;

- (instancetype)initWithTableView:(UITableView*)tableView;

@end
