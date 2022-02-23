//
//  SHANTimeStamp.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/11/20.
//

#import "SHANTimeStamp.h"
#import "SHANHeader.h"
#import "SHANAccountManager.h"

static NSString * const kShanFirstIntoShanBeiSDK = @"shanFirstIntoShanBeiSDK";
static NSString * const kShanSleepTimeLag = @"kShanSleepTimeLag";
@implementation SHANTimeStamp

/// 当前的时间戳 - 第一次进入的时间戳   >=  3h  任务过期
+ (BOOL)shan_isOutTime:(NSInteger)duration {
    NSInteger currentTimeStamp = [[self shan_getCurrentTimeStamp] integerValue];
    NSInteger firstTimeStamp = [[self shan_getFirstIntoSDKTime] integerValue];
    
    if (currentTimeStamp - firstTimeStamp >= duration) {
        return true;
    } else {
        return false;
    }
}

/// 获取当前时间戳(秒)
+ (NSString *)shan_getCurrentTimeStamp {
    double currentTime =  [[NSDate date] timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%.0f",currentTime];
    return timeStamp;
}

/// 当前时间戳(毫秒)
+ (NSString *)shan_getTimeStampOfMS {
    double currentTime = [[NSDate date] timeIntervalSince1970] * 1000;
    long long iTime = (long long)currentTime;
    NSString *timeStamp = [NSString stringWithFormat:@"%lld",iTime];
    return timeStamp;
}

/// 获取第一次进入激励业务的时间戳，保存在本地
+ (NSString *)shan_getFirstIntoSDKTime {
    NSString *timeStampKey = kShanFirstIntoShanBeiSDK;
    NSString *accountId = [SHANAccountManager sharedManager].shanAccountId;
    if (!kSHANStringIsEmpty(accountId)) {
        timeStampKey = [NSString stringWithFormat:@"shan_%@",accountId];
    }
    NSString *timeStamp = [[NSUserDefaults standardUserDefaults] valueForKey:timeStampKey];
    if (kSHANStringIsEmpty(timeStamp)) {
        [self saveFirstIntoSDKTimeStamp];
        timeStamp = [[NSUserDefaults standardUserDefaults] valueForKey:timeStampKey];
    }
    return timeStamp;
}

/// 记录第一次进入激励业务的时间戳，保存在本地
+ (void)saveFirstIntoSDKTimeStamp {
    NSString *timeStampKey = kShanFirstIntoShanBeiSDK;
    NSString *accountId = [SHANAccountManager sharedManager].shanAccountId;
    if (!kSHANStringIsEmpty(accountId)) {
        timeStampKey = [NSString stringWithFormat:@"shan_%@",accountId];;
    }
    NSString *timeStamp = [self shan_getCurrentTimeStamp];
    [[NSUserDefaults standardUserDefaults] setValue:timeStamp forKey:timeStampKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 账号是否第一次进入SDK
+ (BOOL)shan_isFirstIntoSDKWithAccount {
    NSString *timeStampKey = kShanFirstIntoShanBeiSDK;
    NSString *accountId = [SHANAccountManager sharedManager].shanAccountId;
    if (!kSHANStringIsEmpty(accountId)) {
        timeStampKey = [NSString stringWithFormat:@"shan_%@",accountId];
    }
    NSString *timeStamp = [[NSUserDefaults standardUserDefaults] valueForKey:timeStampKey];
    if (kSHANStringIsEmpty(timeStamp)) {
        return true;
    }
    return false;
}

/// 获取睡眠打卡开始时间
+ (NSString *)shan_getSleepStartTimeStamp {
    NSString *accountId = [SHANAccountManager sharedManager].shanAccountId;
    NSString *timeStampKey = [NSString stringWithFormat:@"shan_sleepStart_%@",accountId];
    NSString *timeStamp = [[NSUserDefaults standardUserDefaults] valueForKey:timeStampKey];
    if (kSHANStringIsEmpty(timeStamp)) {
        [self saveSleepStartTimeStamp];
        timeStamp = [[NSUserDefaults standardUserDefaults] valueForKey:timeStampKey];
    }
    return timeStamp;
}

/// 保存睡眠打卡开始时间
+ (void)saveSleepStartTimeStamp {
    NSString *accountId = [SHANAccountManager sharedManager].shanAccountId;
    NSString *timeStampKey = [NSString stringWithFormat:@"shan_sleepStart_%@",accountId];
    NSString *timeStamp = [self shan_getCurrentTimeStamp];
    [[NSUserDefaults standardUserDefaults] setValue:timeStamp forKey:timeStampKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 是否存在 睡眠打卡开始时间
+ (BOOL)shan_isHaveSleepStartTimeStamp {
    NSString *accountId = [SHANAccountManager sharedManager].shanAccountId;
    NSString *timeStampKey = [NSString stringWithFormat:@"shan_sleepStart_%@",accountId];
    NSString *timeStamp = [[NSUserDefaults standardUserDefaults] valueForKey:timeStampKey];
    if (kSHANStringIsEmpty(timeStamp)) {
        return false;
    } else {
        return true;
    }
}

/// 清除 睡眠打卡开始时间
+ (void)shan_clearSleepStartTimeStamp {
    NSString *accountId = [SHANAccountManager sharedManager].shanAccountId;
    NSString *timeStampKey = [NSString stringWithFormat:@"shan_sleepStart_%@",accountId];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:timeStampKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 保存睡觉刷新数据 时间间隔
+ (void)shan_saveSleepTimeLag:(NSInteger)timeLag {
    [[NSUserDefaults standardUserDefaults] setInteger:timeLag forKey:kShanSleepTimeLag];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)shan_getSleepTimeLag {
    NSInteger timeLag = [[NSUserDefaults standardUserDefaults] integerForKey:kShanSleepTimeLag];
    return timeLag;
}

@end
