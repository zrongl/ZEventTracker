//
//  UIView+ZTracker.m
//  Pods-ZEventTracker_Example
//
//  Created by ronglei on 2019/10/29.
//

#import "UIView+ZTracker.h"
#import "NSObject+ZTracker.h"
#import "NSObject+ZTrackerInfo.h"
#import "ZTrackerReporter.h"
#import "ZTrackerManager.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIView (ZTracker)

+ (void)startTrack
{
    SEL originalSelector = @selector(addGestureRecognizer:);
    SEL swizzledSelector = @selector(hook_addGestureRecognizer:);
    [[self class] swizzleMethod:originalSelector swizzledSelector:swizzledSelector];
}

- (void)hook_addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    [self hook_addGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]]) {
        Ivar targetsIvar = class_getInstanceVariable([UIGestureRecognizer class], "_targets");
        id targetActionPairs = object_getIvar(gestureRecognizer, targetsIvar);
        
        Class targetActionPairClass = NSClassFromString(@"UIGestureRecognizerTarget");
        Ivar targetIvar = class_getInstanceVariable(targetActionPairClass, "_target");
        Ivar actionIvar = class_getInstanceVariable(targetActionPairClass, "_action");
        
        for (id targetActionPair in targetActionPairs) {
            id target = object_getIvar(targetActionPair, targetIvar);
            SEL action = (__bridge void *)object_getIvar(targetActionPair, actionIvar);
            if (target &&
                action) {
                Class class = [target class];
                SEL originalSelector = action;
                SEL swizzledSelector = NSSelectorFromString(@"hook_didTapView");
                BOOL didAddMethod = class_addMethod(class, swizzledSelector, (IMP)hook_didTapView, "v@:@@");
                if (didAddMethod) {
                    Method originMethod = class_getInstanceMethod(class, swizzledSelector);
                    Method swizzlMethod = class_getInstanceMethod(class, originalSelector);
                    method_exchangeImplementations(originMethod, swizzlMethod);
                    break;
                }
            }
        }
    }
}

void hook_didTapView(id self, SEL _cmd, id gestureRecognizer)
{
    NSMethodSignature *signture = [[self class] instanceMethodSignatureForSelector:_cmd];
    NSUInteger numberOfArguments = signture.numberOfArguments;
    SEL selector = NSSelectorFromString(@"hook_didTapView");
    if (3 == numberOfArguments) {
        ((void(*)(id, SEL, id))objc_msgSend)(self, selector, gestureRecognizer);
    }else if (2 == numberOfArguments) {
        ((void(*)(id, SEL))objc_msgSend)(self, selector);
    }
    
    NSString *className = NSStringFromClass([self class]);
    NSString *acitonString = NSStringFromSelector(_cmd);
    NSString *eventId = [self events][className][acitonString];
    
    [[ZTrackerReporter sharedInstance] report:eventId info:[self trackerInfo]];
}

- (NSDictionary *)events
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[ZTrackerManager sharedInstance].plist ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

@end
