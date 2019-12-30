//
//  Log.m
//
//  Created by Phil on 2017/5/11.
//  Copyright © 2017年 sniApp. All rights reserved.
//

// file Log.m
#import "Log.h"
@implementation Log

+ (id)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    if(!(self = [super init])){
        return nil;
    }
    
    [self initRedirectLogToDocuments];
    [self initLivewViewStatusLogPath];
    
    return self;
}

void MyLog(NSString *prefix, const char *file, int lineNumber, const char *funcName, NSString *format,...) {
    [Log sharedInstance];
    va_list ap;
    va_start (ap, format);
    format = [format stringByAppendingString:@"\n"];
    NSString *msg = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@",format] arguments:ap];
    va_end (ap);
    fprintf(stderr,"%s%50s:%3d - %s",[prefix UTF8String], funcName, lineNumber, [msg UTF8String]);
    if([msg containsString:MyLivewViewStatusLogkey]){
        append(msg);
    }else if([msg containsString:MyUnitTestLogkey]){
        append(msg);
    }
}

void append(NSString *msg){
    // get path to Documents/somefile.txt
    NSString *path = [[Log sharedInstance] livewViewStatusLogPath];
    // create if needed
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        fprintf(stderr,"Creating file at %s/n",[path UTF8String]);
        [[NSData data] writeToFile:path atomically:YES];
    }
    // append
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
}

- (void)initLivewViewStatusLogPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MyLivewViewStatusLog.txt"];
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    self.livewViewStatusLogPath = path;
}

- (void)initRedirectLogToDocuments
{
    NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [allPaths objectAtIndex:0];
    NSString *pathForLog = [documentsDirectory stringByAppendingPathComponent:@"MyLog.txt"];
    
    [[NSFileManager defaultManager] removeItemAtPath:pathForLog error:nil];
    
    freopen([pathForLog cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

@end
