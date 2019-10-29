//
//  UIViewController+ZTracker.m
//  Pods-ZEventTracker_Example
//
//  Created by ronglei on 2019/10/29.
//

#import "UIViewController+ZTracker.h"
#import "NSObject+ZTracker.h"
#import "NSObject+ZTrackerInfo.h"
#import "ZTrackerManager.h"

#import "ZTrackerReporter.h"

@implementation UIViewController (ZTracker)

+ (void)startTrack
{
    SEL originalAppear = @selector(viewWillAppear:);
    SEL swizzledAppear = @selector(hook_viewWillAppear:);
    [[self class] swizzleMethod:originalAppear swizzledSelector:swizzledAppear];
    
    SEL originalDisappear = @selector(viewWillDisappear:);
    SEL swizzledDisappear = @selector(hook_viewWillDisappear:);
    [[self class] swizzleMethod:originalDisappear swizzledSelector:swizzledDisappear];
}

- (void)hook_viewWillAppear:(BOOL)animated
{
    [self hook_viewWillAppear:animated];
    
    
    NSString *selfClassName = NSStringFromClass([self class]);
    NSString *eventID = [self events][selfClassName][@"PageEvents"][@"Enter"];
    
    [[ZTrackerReporter sharedInstance] report:eventID info:[self trackerInfo]];
    
}

- (void)hook_viewWillDisappear:(BOOL)animated
{
    [self hook_viewWillDisappear:animated];
    
    NSString *className = NSStringFromClass([self class]);
    NSString *eventID = [self events][className][@"PageEvents"][@"Leave"];
    
    [[ZTrackerReporter sharedInstance] report:eventID info:[self trackerInfo]];
}

- (NSDictionary *)events
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[ZTrackerManager sharedInstance].plist ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

@end
