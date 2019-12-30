//
//  StaticErrorMessageUtil.h
//
//  Created by Phil on 2017/5/11.
//  Copyright © 2017年 sniApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticErrorMessageUtil : NSObject

+ (id)sharedInstance;
- (void)NSLog:(NSString*)log;
- (NSString*)getErrorMessageOK;
- (NSString*)getRTSPErrorMessage:(int)errorcode;
- (NSString*)getErrorMessage:(int)errorcode;
- (NSString*)getErrorMessageWithErrorResultString:(NSString*)errorResultString;
- (NSString*)AddHeaderToMessage:(NSString*)message;
@end

