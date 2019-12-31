//
//  Model.h
//  HierarchyList
//
//  Created by Phil on 2018/5/9.
//  Copyright © 2018年 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunctionModelItem.h"
#import "Device.h"



@interface Model : NSObject <UITableViewDataSource>{
@protected
    NSMutableArray<FunctionModelItem>* items;
    NSArray* infoTitleItems;
    Device* _device;
}

//@property (weak) id<HierarchyViewModelDelegate> delegate;
@property (weak, readonly) UITableView* tableView;

- (instancetype)initWithTableView:(UITableView*)tableView;

- (void)updateWithData:(Device*)device;
- (NSString *)getSectionTitleinSection:(NSInteger)section;
- (UIImage *)getSectionLeftIconinSection:(NSInteger)section;
- (FunctionType)getFunctionTypeinSection:(NSInteger)section;
- (void)hideRows:(BOOL)hide inSection:(NSInteger)section;
- (BOOL)hiddenRowsinSection:(NSInteger)section;
- (void)addItem:(id<FunctionModelItem>)item;
- (void)hideAll:(UITableView *)tableView;
- (void)loadAll:(UITableView *)tableView;

@end
