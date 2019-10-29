//
//  ZTrackerReporter.m
//  Pods-ZEventTracker_Example
//
//  Created by ronglei on 2019/10/29.
//

#import "ZTrackerReporter.h"

@implementation ZTrackerReporter

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


- (void)report:(NSString *)identifier info:(NSDictionary *)info
{
    if (!identifier)  return;
    
    
}
@end
