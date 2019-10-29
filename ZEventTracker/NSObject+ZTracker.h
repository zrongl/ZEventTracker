//
//  NSObject+ZTracker.h
//  Pods-ZEventTracker_Example
//
//  Created by ronglei on 2019/10/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZTracker)

+ (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
