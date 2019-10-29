//
//  ZTrackerReporter.h
//  Pods-ZEventTracker_Example
//
//  Created by ronglei on 2019/10/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZTrackerReporter : NSObject

+ (instancetype)sharedInstance;

- (void)report:(NSString *)identifier info:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
