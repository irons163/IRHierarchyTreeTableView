//
//  BranchTableIView.m
//  HierarchyList
//
//  Created by Phil on 2018/5/11.
//  Copyright © 2018年 Phil. All rights reserved.
//

#import "BranchTableIView.h"
#import "BranchTableViewCell.h"
#import "LeafTableViewCell.h"

@interface BranchTableIView()

@property (nonatomic, copy) void (^reloadDataCompletionBlock)(void);
@end

@implementation BranchTableIView{
    NSLayoutConstraint *tableHeightConstraint;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    if(self = [super init]){
        [self registerNib:[UINib nibWithNibName:BranchTableViewCell.identifier bundle:nil] forCellReuseIdentifier:BranchTableViewCell.identifier];
        [self registerNib:[UINib nibWithNibName:LeafTableViewCell.identifier bundle:nil] forCellReuseIdentifier:LeafTableViewCell.identifier];
        [self registerNib:[UINib nibWithNibName:@"BranchHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"BranchHeaderView"];
        self.estimatedRowHeight = UITableViewAutomaticDimension;
        self.rowHeight = UITableViewAutomaticDimension;
        self.estimatedSectionHeaderHeight = UITableViewAutomaticDimension;
        self.sectionHeaderHeight = UITableViewAutomaticDimension;
        self.sectionFooterHeight = 0.0001f;
        tableHeightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44];
        tableHeightConstraint.priority = UILayoutPriorityDefaultHigh;
        tableHeightConstraint.active = YES;
//        [self setLayoutMargins:UIEdgeInsetsMake(0,40, 0, 0)];
//        [self setPreservesSuperviewLayoutMargins:YES];
//        self.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"HierarchyImage"] resizableImageWithCapInsets:UIEdgeInsetsMake(70, 49, 70, 0) resizingMode:UIImageResizingModeStretch]];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self registerNib:[UINib nibWithNibName:BranchTableViewCell.identifier bundle:nil] forCellReuseIdentifier:BranchTableViewCell.identifier];
        [self registerNib:[UINib nibWithNibName:LeafTableViewCell.identifier bundle:nil] forCellReuseIdentifier:LeafTableViewCell.identifier];
        [self registerNib:[UINib nibWithNibName:@"BranchHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"BranchHeaderView"];
        self.estimatedRowHeight = UITableViewAutomaticDimension;
        self.rowHeight = UITableViewAutomaticDimension;
        self.bounces = NO;
        self.estimatedSectionHeaderHeight = UITableViewAutomaticDimension;
        self.sectionHeaderHeight = UITableViewAutomaticDimension;
        self.sectionFooterHeight = 0.0001f;
        tableHeightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44];
        tableHeightConstraint.priority = UILayoutPriorityDefaultHigh;
        tableHeightConstraint.active = YES;
//        [self setLayoutMargins:UIEdgeInsetsMake(0,40, 0, 0)];
//        [self setPreservesSuperviewLayoutMargins:YES];
//        self.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"HierarchyImage"] resizableImageWithCapInsets:UIEdgeInsetsMake(70, 49, 70, 0) resizingMode:UIImageResizingModeStretch]];
    }
    
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.reloadDataCompletionBlock) {
//        tableHeightConstraint.constant = self.contentSize.height;
        self.reloadDataCompletionBlock();
        self.reloadDataCompletionBlock = nil;
    }
}

//- (void)reloadDataWithCompletion:(void (^)(void))completionBlock
//{
//    self.reloadDataCompletionBlock = completionBlock;
//    [super reloadData];
//}

-(void)reloadDataWithCompletion:(void (^)(void))completionBlock{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        NSLog(@"reload completed");
        tableHeightConstraint.constant = self.contentSize.height;
        if(completionBlock)
            completionBlock();
    }];
    NSLog(@"reloading");
    [super reloadData];
    [CATransaction commit];
}

-(void)updateTableHeight{
    tableHeightConstraint.constant = self.contentSize.height;
}

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
//    [self.superview layoutIfNeeded];
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         tableHeightConstraint.constant = self.contentSize.height;
//                         [self.superview layoutIfNeeded];
//                     }];
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//
//    self.frameLayer.frame = self.frameView.bounds;
//
//    [CATransaction commit];
    [self.superview layoutIfNeeded];
//    [UIView animateWithDuration:0.2 animations:^{
        tableHeightConstraint.constant = self.contentSize.height;
        [self.superview layoutIfNeeded];
//    }];
    [self invalidateIntrinsicContentSize];
}

//- (CGSize)intrinsicContentSize {
//    [self layoutIfNeeded]; // force my contentSize to be updated immediately
////    return CGSizeMake(UIViewNoIntrinsicMetric, self.contentSize.height);
//    return [super intrinsicContentSize];
//}

@end
