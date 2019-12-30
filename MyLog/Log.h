//
//  Log.h
//
//  Created by Phil on 2017/5/11.
//  Copyright © 2017年 sniApp. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MyLivewViewStatusLogkey @"[LivewViewStatusLog]"
#define MyUnitTestLogkey @"[UnitTestLog]"

#if defined(__cplusplus)
#define MY_LOG_BEGIN extern "C" {
#define MY_LOG_END }
#else
#define MY_LOG_BEGIN
#define MY_LOG_END
#endif

MY_LOG_BEGIN

// file Log.h
#define NSLog(args...)  MyLog(@"DEBUG ", __FILE__,__LINE__,__PRETTY_FUNCTION__,args);

//#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
@interface Log : NSObject
void MyLog(NSString *prefix, const char *file, int lineNumber, const char *funcName, NSString *format,...);

@property NSString *livewViewStatusLogPath;
@end

MY_LOG_END

