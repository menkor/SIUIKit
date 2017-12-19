//
//  YCPollingEntity.h
//  YCEasyTool
//
//  Created by YeTao on 16/5/19.
//
//

#import <Foundation/Foundation.h>

typedef void (^YCPollingEntityRunningBlock)(NSTimeInterval current);

@interface YCPollingEntity : NSObject

@property (nonatomic, readonly) BOOL running;

+ (instancetype)pollingWithTimeInterval:(NSTimeInterval)timeInterval;

+ (instancetype)pollingWithTimeInterval:(NSTimeInterval)timeInterval max:(NSTimeInterval)max;

- (void)startRunningWithBlock:(YCPollingEntityRunningBlock)block;

- (void)stopRunning;

- (void)pause;

- (void)resume;

@end
