//
//  SHANSleepModel.h
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANSleepModel : NSObject
/// 可完成任务数量
@property (nonatomic, assign) NSInteger taskCount;
/// 任务总次数
@property (nonatomic, assign) NSInteger taskSum;
/// 任务是否开启
@property (nonatomic, assign) BOOL open;
/// 已完成数量
@property (nonatomic, assign) NSInteger finishCount;
/// 描述
@property (nonatomic, copy) NSString *Description;
/// 时间间隔，满了就刷新列表数据
@property (nonatomic, assign) NSInteger timeLag;

@end

@interface SHANSleepModel (HTTP)

/// 睡觉打卡任务信息
+ (void)shanGetSleepInfoWithTaskId:(NSString *)taskId
                           success:(void(^)(SHANSleepModel *model))success
                           failure:(void(^)(NSString *errorMessage))failure;

/// 睡觉打卡任务计时
+ (void)shanGetSleepStartWithTaskId:(NSString *)taskId
                            success:(void(^)(NSDictionary *dic))success
                            failure:(void(^)(NSString *errorMessage))failure;

/// 睡觉打卡任务上报
+ (void)shanReportSleepTaskWithTaskId:(NSString *)taskId
                              success:(void(^)(NSDictionary *dic))success
                              failure:(void(^)(NSString *errorMessage))failure;

/// 睡觉打卡-领取奖励-追加任务上报
+ (void)shanReportHideSleepTaskWithTaskId:(NSString *)taskId
                             taskRecordId:(NSString *)taskRecordId
                                  success:(void(^)(NSDictionary *dic))success
                                  failure:(void(^)(NSString *errorMessage))failure;
@end

NS_ASSUME_NONNULL_END
