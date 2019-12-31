//
//  Leaf.m
//  HierarchyList
//
//  Created by Phil on 2018/5/9.
//  Copyright © 2018年 Phil. All rights reserved.
//

#import "Leaf.h"

@implementation Leaf

@synthesize superNode;
@synthesize device;

- (instancetype)initWithDevice:(Device *)device {
    self = [self init];
    if (self) {
        self.device = device;
    }
    return self;
}

- (void)add:(id)corp {
    NSLog(@"Leaf cannot add something.");
}

- (void)remove:(id<Corp>)corp {
    NSLog(@"Leaf cannot remove something.");
}

- (NSArray *)getChildren {
    return nil;
}

- (void)click {
    NSLog(@"Leaf be clicked.");
}

- (void)loopUpdate {
    
}

- (void)loopUpdate:(id<Corp>)calledChild {
    
}

@end
