//
//  FunctionModelLANItem.m
//
//  Created by Phil on 2018/3/27.
//

#import "FunctionModelBranchItem.h"

@implementation FunctionModelBranchItem{
    NSInteger _rowCount;
    Device *_device;
}
@synthesize hideCells;

-(instancetype)initWithRowCount:(NSInteger)rowCount {
    if(self = [self init]){
        _rowCount = 1;
    }
    return self;
}

- (NSInteger)rowCount {
    if(self.hideCells)
        return 0;
    return _rowCount;
}

- (NSString*)rowTitleForIndex:(NSInteger)rowIndex{
    return nil;
}

- (NSString *)sectionTitle {
    return _device.name;
}

- (UIImage *)sectionLeftIcon {
    if([self hideCells]){
        return [UIImage imageNamed:@"HierarchyImage2_top"];
    }else{
        return [UIImage imageNamed:@"HierarchyImage_top"];
    }
}

- (FunctionType)type {
    return BRANCH;
}

- (void)updateWithData:(Device*)device{
    _device = device;
}

@end
