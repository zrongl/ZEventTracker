//
//  NSObject+ZTrackerInfo.m
//  Pods-ZEventTracker_Example
//
//  Created by ronglei on 2019/10/29.
//

#import "NSObject+ZTrackerInfo.h"
#import <objc/runtime.h>

static void *trackerInfoPropertyKey = &trackerInfoPropertyKey;

@implementation NSObject (ZTrackerInfo)

- (NSDictionary *)trackerInfo
{
    return  objc_getAssociatedObject(self, trackerInfoPropertyKey);
}

- (void)setTrackerInfo:(NSDictionary *)trackerInfo
{
    if (!trackerInfo) return;
    
    objc_setAssociatedObject(self, trackerInfoPropertyKey, trackerInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)configTrackerInfo:(id)info
{
    if (nil == info) return;
    
    if ([info isKindOfClass:[NSDictionary class]]) {
        self.trackerInfo = info;
    }else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        unsigned count;
        objc_property_t *properties = class_copyPropertyList([info class], &count);
        
        for (int i = 0; i < count; i++) {
            NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
            if (key.length > 0 &&
                [info valueForKey:key]) {
                [dict setObject:[info valueForKey:key] forKey:key];
            }
        }
        
        free(properties);
        
        if (dict) {
            self.trackerInfo = dict;
        }
    }
}

@end
