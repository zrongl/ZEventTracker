//
//  UIControl+ZTracker.m
//  Pods-ZEventTracker_Example
//
//  Created by ronglei on 2019/10/29.
//

#import "UIControl+ZTracker.h"
#import "NSObject+ZTracker.h"
#import "NSObject+ZTrackerInfo.h"
#import "ZTrackerManager.h"

#import "ZTrackerReporter.h"

@implementation UIControl (ZTracker)

+ (void)startTrack
{
    SEL originalSelector = @selector(sendAction:to:forEvent:);
    SEL swizzledSelector = @selector(hook_sendAction:to:forEvent:);
    [[self class] swizzleMethod:originalSelector swizzledSelector:swizzledSelector];
}

- (void)hook_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [self hook_sendAction:action to:target forEvent:event];
    
    NSString *eventID = nil;
    if ([[[event allTouches] anyObject] phase] == UITouchPhaseEnded) {
        NSString *actionString = NSStringFromSelector(action);
        NSString *targetName = NSStringFromClass([target class]);
        eventID = [self events][targetName][@"ControlEvents"][actionString];
        NSDictionary *info = [target trackerInfo];
        
        [[ZTrackerReporter sharedInstance] report:eventID info:info];
    }
}

- (NSDictionary *)events
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[ZTrackerManager sharedInstance].plist ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

@end
