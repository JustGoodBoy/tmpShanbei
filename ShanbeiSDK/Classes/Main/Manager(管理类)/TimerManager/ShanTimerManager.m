//
//  ShanTimerManager.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/11/19.
//

#import "ShanTimerManager.h"
#import "SHANTimeStamp.h"
#import "SHANAccountManager.h"
static ShanTimerManager *_commentMark = nil;

@interface ShanTimerManager ()
@property (nonatomic, strong) dispatch_source_t boxTimer;   //注意:此处应该使用强引用 strong
@property (nonatomic, strong) dispatch_source_t cashTimer;  //注意:此处应该使用强引用 strong
@property (nonatomic, strong) dispatch_source_t sleepTimer; //注意:此处应该使用强引用 strong
@end

@implementation ShanTimerManager
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _commentMark = [[super allocWithZone:NULL] init];
    });
    
    return _commentMark;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [ShanTimerManager sharedManager];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [ShanTimerManager sharedManager];
}

#pragma mark - 宝箱任务
/// 宝箱任务定时器
/// @param duration 总时长
- (void)shan_startBoxTimerWith:(NSInteger)duration{
    __block NSInteger boxDuration = duration;
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 第四个参数:精准度(表示允许的误差,0表示绝对精准)
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);

    dispatch_source_set_event_handler(timer, ^{
        boxDuration--;
        if (boxDuration <= 0) {
            [self cancelBoxTimer];
        }
//        if (![SHANAccountManager sharedManager].isLogin) {
//            boxDuration = 0;
//        }
        !self.boxCountDownBlock ? : self.boxCountDownBlock(boxDuration);
    });

    self.boxTimer = timer;
    
    dispatch_resume(self.boxTimer);
}

/// 取消宝箱定时器
- (void)cancelBoxTimer{
    if (self.boxTimer) {
        dispatch_source_cancel(self.boxTimer);
    }
}

#pragma mark - 现金红包任务
/// 现金红包定时器
/// @param duration 总时长
- (void)shan_startCashRedPacketTimerWith:(NSInteger)duration {
    [self shan_cancelCashTimer];
    // count = duration - (currentTime - firstTime)
    NSInteger firstTime = [[SHANTimeStamp shan_getFirstIntoSDKTime] integerValue];
    NSInteger currentTime = [[SHANTimeStamp shan_getCurrentTimeStamp] integerValue];
    
    __block NSInteger countDown = duration - (currentTime - firstTime);
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 第四个参数:精准度(表示允许的误差,0表示绝对精准)
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        countDown--;
        !self.cashCountDownBlock ? : self.cashCountDownBlock(countDown);
        if (countDown < 0) {
            self.isCashRedPacketTimer = false;
            [self shan_cancelCashTimer];
        }
    });

    self.cashTimer = timer;
    
    dispatch_resume(self.cashTimer);
}

/// 取消现金红包定时器
- (void)shan_cancelCashTimer {
    if (self.cashTimer) {
        dispatch_source_cancel(self.cashTimer);
    }
}

#pragma mark - 睡觉打卡任务
/// 睡觉打卡定时器
- (void)shan_startSleepTimer {
    [self shan_cancelSleepTimer];
    // duration = (currentTime - firstTime)
    NSInteger firstTime = [[SHANTimeStamp shan_getSleepStartTimeStamp] integerValue];
    NSInteger currentTime = [[SHANTimeStamp shan_getCurrentTimeStamp] integerValue];
    
    __block NSInteger duration = (currentTime - firstTime);
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 第四个参数:精准度(表示允许的误差,0表示绝对精准)
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        !self.sleepTimerBlock ? : self.sleepTimerBlock(duration);
        duration++;
    });

    self.cashTimer = timer;
    
    dispatch_resume(self.cashTimer);
}

/// 取消睡觉打卡定时器
- (void)shan_cancelSleepTimer {
    if (self.sleepTimer) {
        dispatch_source_cancel(self.sleepTimer);
    }
}

@end
