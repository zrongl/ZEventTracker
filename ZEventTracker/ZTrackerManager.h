//
//  ZTrackerManager.h
//  Pods-ZEventTracker_Example
//
//  Created by ronglei on 2019/10/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTrackerManager : NSObject

@property(nonatomic, strong, readonly) NSString *plist;

+ (instancetype)sharedInstance;

- (void)configure:(NSString *)plist;

@end

NS_ASSUME_NONNULL_END
