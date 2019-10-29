//
//  NSObject+ZTrackerInfo.h
//  Pods-ZEventTracker_Example
//
//  Created by ronglei on 2019/10/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZTrackerInfo)

@property (nonatomic, strong) NSDictionary *trackerInfo;

- (void)configTrackerInfo:(id)info;

@end

NS_ASSUME_NONNULL_END
