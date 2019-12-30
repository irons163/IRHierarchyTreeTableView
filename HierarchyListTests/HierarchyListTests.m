//
//  HierarchyListTests.m
//  HierarchyListTests
//
//  Created by Phil on 2018/5/9.
//  Copyright © 2018年 Phil. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CommonTools/CommonTools/CommonTools.h"
#import "StaticErrorMessageUtil.h"
#import "Log.h"

@interface HierarchyListTests : XCTestCase

@end

@implementation HierarchyListTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

-(void)testValidSubnetMask{
    for(int i = 0; i <= 255; i++){
        for(int j = 0; j <= 255; j++){
            NSString *subnetMask = [NSString stringWithFormat:@"%d.%d.0.0", i, j];
            @autoreleasepool{
            BOOL isValid = [CommonTools checkSubnetMaskValid:subnetMask];
            [[StaticErrorMessageUtil sharedInstance] NSLog:[[StaticErrorMessageUtil sharedInstance] AddHeaderToMessage:[NSString stringWithFormat:@"%@ %@", subnetMask, isValid ? @"is valid." : @"is invalid." ]]];
            }
        }
    }
}

@end
