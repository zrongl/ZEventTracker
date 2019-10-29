//
//  UICollectionView+ZTracker.m
//  Pods-ZEventTracker_Example
//
//  Created by ronglei on 2019/10/29.
//

#import "UICollectionView+ZTracker.h"
#import "NSObject+ZTracker.h"
#import "NSObject+ZTrackerInfo.h"
#import "ZTrackerManager.h"

#import "ZTrackerReporter.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation UICollectionView (ZTracker)

+ (void)startTrack
{
    SEL originalSelector = @selector(setDelegate:);
    SEL swizzledSelector = @selector(hook_setDelegate:);
    
    [[self class] swizzleMethod:originalSelector swizzledSelector:swizzledSelector];
}

- (void)hook_setDelegate:(id<UICollectionViewDelegate>)delegate
{
    
    if (![self isMemberOfClass:[UICollectionView class]]) return;
    
    [self hook_setDelegate:delegate];
    
    if (delegate) {
        Class class = [delegate class];
        SEL originalSelector = @selector(collectionView:didSelectItemAtIndexPath:);
        SEL swizzledSelector = NSSelectorFromString(@"hook_didSelectItemAtIndexPath");
        
        BOOL didAddMethod = class_addMethod(class, swizzledSelector, (IMP)hook_didSelectItemAtIndexPath, "v@:@@");
        if (didAddMethod) {
            Method originMethod = class_getInstanceMethod(class, swizzledSelector);
            Method swizzlMethod = class_getInstanceMethod(class, originalSelector);
            method_exchangeImplementations(originMethod, swizzlMethod);
        }
    }
}

void hook_didSelectItemAtIndexPath(id self, SEL _cmd, id collectionView, NSIndexPath *indexpath)
{
    SEL selector = NSSelectorFromString(@"hook_didSelectItemAtIndexPath");
    ((void(*)(id, SEL,id, NSIndexPath *))objc_msgSend)(self, selector, collectionView, indexpath);
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexpath];
    
    NSString *targetName = NSStringFromClass([self class]);
    NSString *actionString = NSStringFromSelector(_cmd);
    
    NSString *eventId = [self events][targetName][@"ControlEvents"][actionString];
    [[ZTrackerReporter sharedInstance] report:eventId info:[cell trackerInfo]];
}

- (NSDictionary *)events
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[ZTrackerManager sharedInstance].plist ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

@end
