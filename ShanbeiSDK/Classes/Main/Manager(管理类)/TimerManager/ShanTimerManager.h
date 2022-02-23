//
//  ShanTimerManager.h
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/11/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 定时器
@interface ShanTimerManager : NSObject

@property (nonatomic, assign) BOOL isCashRedPacketTimer;
@property (nonatomic, copy) void (^boxCountDownBlock)(NSInteger countdown);
@property (nonatomic, copy) void (^cashCountDownBlock)(NSInteger countdown);
@property (nonatomic, copy) void (^sleepTimerBlock)(NSInteger duration);

+ (instancetype)sharedManager;

/// 宝箱任务定时器
/// @param duration 总时长
- (void)shan_startBoxTimerWith:(NSInteger)duration;

/// 现金红包定时器
/// @param duration 总时长
- (void)shan_startCashRedPacketTimerWith:(NSInteger)duration;

/// 取消现金红包定时器
- (void)shan_cancelCashTimer;

/// 睡觉打卡定时器
- (void)shan_startSleepTimer;

/// 取消睡觉打卡定时器
- (void)shan_cancelSleepTimer;

@end

NS_ASSUME_NONNULL_END
