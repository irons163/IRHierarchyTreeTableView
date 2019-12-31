//
//  ViewController.m
//  HierarchyList
//
//  Created by Phil on 2018/5/9.
//  Copyright © 2018年 Phil. All rights reserved.
//

#import "ViewController.h"
#import "Branch.h"
#import "Leaf.h"
#import "Device.h"
#import "BranchTableIView.h"
#import "FunctionModelBranchItem.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, HierarchyViewModelDelegate>{
    Model *model;
    Branch *branch;
}
@property UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[BranchTableIView alloc] init];
//    model = [[Model alloc] init];
//    model.delegate = self;
//    self.tableView.dataSource = model;
    self.tableView.delegate = self;
    
    Device *devicebranch1 = [[Device alloc] init];
    devicebranch1.name = @"branch1";
    Device *devicebranch2 = [[Device alloc] init];
    devicebranch2.name = @"branch2";
    Device *devicebranch3 = [[Device alloc] init];
    devicebranch3.name = @"branch3";
    Device *devicebranch4 = [[Device alloc] init];
    devicebranch4.name = @"branch4";
    Device *devicebranch5 = [[Device alloc] init];
    devicebranch5.name = @"branch5";
    Device *deviceleaf = [[Device alloc] init];
    deviceleaf.name = @"leaf";
    Device *deviceleaf2 = [[Device alloc] init];
    deviceleaf2.name = @"leaf2";
    Device *deviceleaf3 = [[Device alloc] init];
    deviceleaf3.name = @"leaf3";
    Device *deviceleaf4 = [[Device alloc] init];
    deviceleaf4.name = @"leaf4";
    Device *deviceleaf5 = [[Device alloc] init];
    deviceleaf5.name = @"leaf5";
    Device *deviceleaf6 = [[Device alloc] init];
    deviceleaf6.name = @"leaf6";
    Device *deviceleaf7 = [[Device alloc] init];
    deviceleaf7.name = @"leaf7";
    Device *deviceleaf8 = [[Device alloc] init];
    deviceleaf8.name = @"leaf8";
    Device *deviceleaf9 = [[Device alloc] init];
    deviceleaf9.name = @"leaf9";
    Device *deviceleaf10 = [[Device alloc] init];
    deviceleaf10.name = @"leaf10";
    Device *deviceleaf11 = [[Device alloc] init];
    deviceleaf11.name = @"leaf11";
    Device *deviceleaf12 = [[Device alloc] init];
    deviceleaf12.name = @"leaf12";
    
    branch = [[Branch alloc] initWithTableView:self.tableView];
    Branch *branch1 = [[Branch alloc] initWithDevice:devicebranch1];
    Branch *branch2 = [[Branch alloc] initWithDevice:devicebranch2];
    Branch *branch3 = [[Branch alloc] initWithDevice:devicebranch3];
    Branch *branch4 = [[Branch alloc] initWithDevice:devicebranch4];
    Branch *branch5 = [[Branch alloc] initWithDevice:devicebranch5];
    Leaf *leaf = [[Leaf alloc] initWithDevice:deviceleaf];
    Leaf *leaf2 = [[Leaf alloc] initWithDevice:deviceleaf2];
    Leaf *leaf3 = [[Leaf alloc] initWithDevice:deviceleaf3];
    Leaf *leaf4 = [[Leaf alloc] initWithDevice:deviceleaf4];
    Leaf *leaf5 = [[Leaf alloc] initWithDevice:deviceleaf5];
    Leaf *leaf6 = [[Leaf alloc] initWithDevice:deviceleaf6];
    Leaf *leaf7 = [[Leaf alloc] initWithDevice:deviceleaf7];
    Leaf *leaf8 = [[Leaf alloc] initWithDevice:deviceleaf8];
    Leaf *leaf9 = [[Leaf alloc] initWithDevice:deviceleaf9];
    Leaf *leaf10 = [[Leaf alloc] initWithDevice:deviceleaf10];
    Leaf *leaf11 = [[Leaf alloc] initWithDevice:deviceleaf11];
    Leaf *leaf12 = [[Leaf alloc] initWithDevice:deviceleaf12];
    
    FunctionModelBranchItem *branchItem = [[FunctionModelBranchItem alloc] initWithRowCount:1];
    [model addItem:branchItem];
    [branch add:leaf];
    [branch add:branch1];
    [branch add:leaf2];
    [branch1 add:branch2];
    [branch1 add:leaf3];
    [branch1 add:leaf4];
    [branch2 add:leaf5];
    [branch2 add:leaf6];
    [branch2 add:branch3];
    [branch3 add:leaf7];
    [branch3 add:leaf8];
    [branch2 add:branch4];
    [branch4 add:leaf9];
    [branch2 add:branch5];
    [branch5 add:leaf10];
    [branch5 add:leaf11];
    [branch5 add:leaf12];
    
    [self.view addSubview:self.tableView];
    
    [[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0] setActive:YES];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    bottom.priority = UILayoutPriorityDefaultHigh;
    top.active = YES;
    bottom.active = YES;
    left.active = YES;
    right.active = YES;
    
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [((BranchTableIView*)self.tableView) reloadDataWithCompletion:^{
//        [((BranchTableIView*)self.tableView) updateTableHeight];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
