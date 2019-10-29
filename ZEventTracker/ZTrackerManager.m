//
//  ZTrackerManager.m
//  Pods-ZEventTracker_Example
//
//  Created by ronglei on 2019/10/29.
//

#import "ZTrackerManager.h"

#import "UIView+ZTracker.h"
#import "UIControl+ZTracker.h"
#import "UITableView+ZTracker.h"
#import "UICollectionView+ZTracker.h"
#import "UIViewController+ZTracker.h"

@interface ZTrackerManager()

@property(nonatomic, strong, readwrite) NSString *plist;

@end

@implementation ZTrackerManager

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)configure:(NSString *)plist
{
    if (!plist || plist.length == 0) {
        return;
    }
    
    _plist = plist;
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        [UIView startTrack];
        [UIControl startTrack];
        [UITableView startTrack];
        [UICollectionView startTrack];
        [UIViewController startTrack];
    });
}

@end
