//
//  SHANTimeStamp.h
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 记录时间相关
@interface SHANTimeStamp : NSObject

/// 当前的时间戳 - 第一次进入的时间戳   >  3h  任务过期
+ (BOOL)shan_isOutTime:(NSInteger)duration;

/// 获取第一次进入激励业务的时间戳，保存在本地
+ (NSString *)shan_getFirstIntoSDKTime;

/// 获取当前时间戳(秒)
+ (NSString *)shan_getCurrentTimeStamp;

/// 当前时间戳(毫秒)
+ (NSString *)shan_getTimeStampOfMS;

/// 账号是否第一次进入SDK
+ (BOOL)shan_isFirstIntoSDKWithAccount;

/// 获取睡眠打卡开始时间
+ (NSString *)shan_getSleepStartTimeStamp;

/// 是否存在 睡眠打卡开始时间
+ (BOOL)shan_isHaveSleepStartTimeStamp;

/// 清除 睡眠打卡开始时间
+ (void)shan_clearSleepStartTimeStamp;

/// 保存睡觉刷新数据 时间间隔
+ (void)shan_saveSleepTimeLag:(NSInteger)timeLag;

+ (NSInteger)shan_getSleepTimeLag;

@end

NS_ASSUME_NONNULL_END
