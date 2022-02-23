//
//  SHANAlertViewManager.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import <Foundation/Foundation.h>
#import "SHANTaskFinishedAlertView.h"
@class SHANCashDrawalModel;
NS_ASSUME_NONNULL_BEGIN

@interface SHANAlertViewManager : NSObject

+ (instancetype)sharedManager;

/// 任务完成
- (void)showAlertOfTaskFinishedWithReward:(NSString *)reward taskType:(SHANTaskType)type;

/// 任务完成，追加任务
/// @param coin 当前任务的奖励
/// @param attachCoin 追加任务的奖励
/// @param type 追加任务的类型
- (void)showAlertOfAttachTaskWithcoin:(NSString *)coin
                           attachCoin:(NSString *)attachCoin
                           attachTask:(NSInteger)type;

/// 规则
- (void)showAlertOfRule;

/// 提现
- (void)showAlertOfCashOutWithCash:(SHANCashDrawalModel *)cashModel mode:(NSString *)mode;

/// 提现次数
- (void)showAlertOfCashOutCurrent:(NSString *)current frequency:(NSString *)frequency;

- (void)disMissAlertOfCashOut;

/// 提示微信授权
- (void)showAlertAuthWXOfTpis;

/// 宝箱完成，追加任务
- (void)showAlertOfBoxTaskWithcoin:(NSString *)coin attachCoin:(NSString *)attachCoin;

/// 睡觉奖励
- (void)showAlertOfSleepTask:(NSString *)reward attachTaskID:(NSString *)attachTaskID;

/// 睡觉看视频奖励
- (void)showAlertOfHideSleepTask:(NSString *)reward;

@end

NS_ASSUME_NONNULL_END
