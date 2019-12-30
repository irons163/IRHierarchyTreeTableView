//
//  StaticErrorMessageUtil.m
//
//  Created by Phil on 2017/5/11.
//  Copyright © 2017年 sniApp. All rights reserved.
//

#import "StaticErrorMessageUtil.h"
#import "Log.h"

static const int ERROR_RTSP_RECEIVER_TIMEOUT = -99;

@implementation StaticErrorMessageUtil {
    int counter;
}

+ (id)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if(!(self = [super init])){
        return nil;
    }
    
    return self;
}

- (void)NSLog:(NSString *)log {
    NSLog(@"%@", log);
}

- (NSString *)getErrorMessageOK {
    return [self AddHeaderToMessage:@"OK."];
}

- (NSString *)getRTSPErrorMessage:(int)errorcode {
    switch(errorcode)
    {
        case ERROR_RTSP_RECEIVER_TIMEOUT:
            return [self AddHeaderToMessage:@"Rtsp time out."];
        default:
            return [self AddHeaderToMessage:@"Rtsp fails for unknown error."];
    }
}

- (NSString *)getErrorMessage:(int)errorcode{
    // TODO
    return nil;
}

- (NSString *)getErrorMessageWithErrorResultString:(NSString *)errorResultString {
    return [self AddHeaderToMessage:errorResultString];
}

- (NSString *)AddHeaderToMessage:(NSString *)message {
    counter++;
    return [NSString stringWithFormat:@"%@ %@%d %@", MyUnitTestLogkey, @"Index:",counter, message];
}

@end

