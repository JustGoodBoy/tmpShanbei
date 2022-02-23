//
//  SHANAlertViewManager.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import "SHANAlertViewManager.h"
#import "UIColor+SHANHexString.h"
#import "SHANHeader.h"
#import "SHANRuleAlertView.h"
#import "SHANSureCashOutAlertView.h"
#import "SHANCashOutFrequencyAlertView.h"
#import "SHANNoticeName.h"
#import "SHANCashDrawalModel.h"
#import "NSString+SHAN.h"
#import "SHANAttachTaskAlertView.h"
#import "SHANTaskBoxAlertView.h"
#import "SHANMenu.h"
#import "SHANCashTaskAlertView.h"
#import "SHANControlManager.h"
#import "SHANAuthWXAlertView.h"
#import "SHANRewardAlertView.h"
static SHANAlertViewManager *_manager = nil;

@interface SHANAlertViewManager ()

@property (nonatomic, strong) SHANTaskFinishedAlertView *taskFinishView;
@property (nonatomic, strong) SHANAttachTaskAlertView *attachTaskView;
@property (nonatomic, strong) SHANRuleAlertView *ruleView;
@property (nonatomic, strong) SHANSureCashOutAlertView *cashOutView;
@property (nonatomic, strong) SHANCashOutFrequencyAlertView *cashOutFrequencyView;
@property (nonatomic, strong) SHANTaskBoxAlertView *taskBoxView;
@property (nonatomic, strong) SHANCashDrawalModel *cashOutModel;
@property (nonatomic, strong) SHANAuthWXAlertView *authWXView;  // 微信授权
@property (nonatomic, strong) SHANRewardAlertView *sleepRewardView;    // 睡觉打卡奖励
@end

@implementation SHANAlertViewManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[super allocWithZone:NULL] init];
    });
    
    return _manager;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [SHANAlertViewManager sharedManager];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [SHANAlertViewManager sharedManager];
}

#pragma mark - Public(公开⽅法)
/// 任务完成，获取奖励
- (void)showAlertOfTaskFinishedWithReward:(NSString *)reward taskType:(SHANTaskType)type {
    NSString *unit = @" 积分";
    if (type == SHANTaskTypeOfCashRMB) {
        unit = @"元 现金";
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.taskFinishView];
    _taskFinishView.content = [NSString stringWithFormat:@"+%@%@", reward, unit];
    _taskFinishView.taskType = type;
}

/// 任务完成，追加任务
/// @param coin 当前任务的奖励
/// @param attachCoin 追加任务的奖励
/// @param type 追加任务的类型
- (void)showAlertOfAttachTaskWithcoin:(NSString *)coin
                           attachCoin:(NSString *)attachCoin
                           attachTask:(NSInteger)type {
    [[UIApplication sharedApplication].keyWindow addSubview:self.attachTaskView];
    [_attachTaskView setInfoWithCoin:coin attachCoin:attachCoin attachType:type];
}

/// 规则
- (void)showAlertOfRule {
    [[UIApplication sharedApplication].keyWindow addSubview:self.ruleView];
}

/// 提现
- (void)showAlertOfCashOutWithCash:(SHANCashDrawalModel *)cashModel mode:(NSString *)mode {
    _cashOutModel = cashModel;
    [[UIApplication sharedApplication].keyWindow addSubview:self.cashOutView];
    NSString *cashString = [NSString stringWithFormat:@"%.2f",[cashModel.money floatValue]/100];
    cashString = [cashString removeSurplusZero:cashString];
    self.cashOutView.cashMoney = [NSString stringWithFormat:@"%@元",cashString];
    self.cashOutView.mode = mode;
}

/// 提现次数
- (void)showAlertOfCashOutCurrent:(NSString *)current frequency:(NSString *)frequency {
    [[UIApplication sharedApplication].keyWindow addSubview:self.cashOutFrequencyView];
    [self.cashOutFrequencyView setCurrent:current AndFrequency:frequency];
}

- (void)disMissAlertOfCashOut {
    [self.cashOutView removeFromSuperview];
    self.cashOutView = nil;
}

/// 宝箱完成，追加任务
- (void)showAlertOfBoxTaskWithcoin:(NSString *)coin attachCoin:(NSString *)attachCoin {
    [[UIApplication sharedApplication].keyWindow addSubview:self.taskBoxView];
    [self.taskBoxView setInfoWithCoin:coin attachCoin:attachCoin];
}

/// 提示微信授权
- (void)showAlertAuthWXOfTpis {
    [[UIApplication sharedApplication].keyWindow addSubview:self.authWXView];
}

/// 睡觉奖励
- (void)showAlertOfSleepTask:(NSString *)reward attachTaskID:(NSString *)attachTaskID {
    [[UIApplication sharedApplication].keyWindow addSubview:self.sleepRewardView];
    NSString *title = @"恭喜获得积分";
    NSString *rewardString = [NSString stringWithFormat:@"+%@积分",reward];
    NSString *attach = @"看视频奖励翻3倍";
    [self.sleepRewardView shan_setAttachRewardTitle:title reward:rewardString rewardTips:attach attachTaskID:attachTaskID];
}

/// 睡觉看视频奖励
- (void)showAlertOfHideSleepTask:(NSString *)reward {
    [[UIApplication sharedApplication].keyWindow addSubview:self.sleepRewardView];
    NSString *title = @"翻倍成功!奖励增至";
    NSString *rewardString = [NSString stringWithFormat:@"+%@积分",reward];
    [self.sleepRewardView shan_setNormalRewardTitle:title reward:rewardString];
}

#pragma mark - Private(私有⽅法)
/// 任务完成
- (void)disMissAlertOfTaskFinished {
    [self.taskFinishView removeFromSuperview];
    self.taskFinishView = nil;
}

/// 签到完成，追加任务
- (void)disMissAlertOfAttachTask {
    [self.attachTaskView removeFromSuperview];
    self.attachTaskView = nil;
}

/// 规则
- (void)disMissAlertOfRule {
    [self.ruleView removeFromSuperview];
    self.ruleView = nil;
}

- (void)disMissAlertOfCashOutFrequency {
    [self.cashOutFrequencyView removeFromSuperview];
    self.cashOutFrequencyView = nil;
}

/// 确认提现
- (void)sureCashOut {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHANCashOutPageDrawDepositNotification object:_cashOutModel.ID];
}

#pragma mark - lazyLoad
/// 任务完成
- (SHANTaskFinishedAlertView *)taskFinishView {
    if (!_taskFinishView) {
        _taskFinishView = [[SHANTaskFinishedAlertView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight)];
        _taskFinishView.backgroundColor = [UIColor shan_colorWithHexString:@"000000" alphaComponent:0.8];
        __weak typeof(self) weakself = self;
        _taskFinishView.didCloseAction = ^{
            [weakself disMissAlertOfTaskFinished];
        };
        _taskFinishView.didAcceptAction = ^{
            [weakself disMissAlertOfTaskFinished];
        };
    }
    return _taskFinishView;
}

/// 任务完成，追加任务
- (SHANAttachTaskAlertView *)attachTaskView {
    if (!_attachTaskView) {
        _attachTaskView = [[SHANAttachTaskAlertView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight)];
        _attachTaskView.backgroundColor = [UIColor shan_colorWithHexString:@"000000" alphaComponent:0.8];
        _attachTaskView.didAttachTaskAction = ^(NSInteger taskType) {
            if (taskType == SHANTaskListTypeOfEat) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ShanMealSubsideAttachTaskNotification object:nil];
                return;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:SHANTaskCenterAttachTaskNotification object:nil userInfo:@{@"taskType":[NSString stringWithFormat:@"%ld",taskType]}];
        };
    }
    return _attachTaskView;
}

/// 规则
- (SHANRuleAlertView *)ruleView {
    if (!_ruleView) {
        _ruleView = [[SHANRuleAlertView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight)];
        _ruleView.backgroundColor = [UIColor shan_colorWithHexString:@"000000" alphaComponent:0.8];
        __weak typeof(self) weakself = self;
        _ruleView.didCloseAction = ^{
            [weakself disMissAlertOfRule];
        };
        _ruleView.didKnownAction = ^{
            [weakself disMissAlertOfRule];
        };
    }
    return _ruleView;
}

/// 提现
- (SHANSureCashOutAlertView *)cashOutView {
    if (!_cashOutView) {
        _cashOutView = [[SHANSureCashOutAlertView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight)];
        _cashOutView.backgroundColor = [UIColor shan_colorWithHexString:@"000000" alphaComponent:0.8];
        __weak typeof(self) weakself = self;
        _cashOutView.didCloseAction = ^{
            __strong typeof(self) sself = weakself;
            [sself disMissAlertOfCashOut];
        };
        _cashOutView.didSureAction = ^{
            __strong typeof(self) sself = weakself;
            [sself sureCashOut];
        };
    }
    return _cashOutView;
}

/// 提现次数
- (SHANCashOutFrequencyAlertView *)cashOutFrequencyView {
    if (!_cashOutFrequencyView) {
        _cashOutFrequencyView = [[SHANCashOutFrequencyAlertView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight)];
        _cashOutFrequencyView.backgroundColor = [UIColor shan_colorWithHexString:@"000000" alphaComponent:0.8];
        __weak typeof(self) weakself = self;
        _cashOutFrequencyView.didCloseAction = ^{
            [weakself disMissAlertOfCashOutFrequency];
        };
        _cashOutFrequencyView.didToCashOutAction = ^{
            [weakself disMissAlertOfCashOutFrequency];
        };
    }
    return _cashOutFrequencyView;
}

/// 宝箱AlertView
- (SHANTaskBoxAlertView *)taskBoxView {
    if (!_taskBoxView) {
        _taskBoxView = [[SHANTaskBoxAlertView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight)];
        _taskBoxView.backgroundColor = [UIColor shan_colorWithHexString:@"000000" alphaComponent:0.8];
        
        _taskBoxView.didAttachTaskAction = ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SHANTaskCenterAttachTaskNotification object:nil userInfo:@{@"taskType":[NSString stringWithFormat:@"%ld",SHANTaskListTypeOfHideBox]}];
        };
    }
    return _taskBoxView;
}

/// 微信授权
- (SHANAuthWXAlertView *)authWXView {
    if (!_authWXView) {
        _authWXView = [[SHANAuthWXAlertView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight)];
        _authWXView.backgroundColor = [UIColor shan_colorWithHexString:@"000000" alphaComponent:0.8];
    }
    return _authWXView;
}

- (SHANRewardAlertView *)sleepRewardView {
    if (!_sleepRewardView) {
        _sleepRewardView = [[SHANRewardAlertView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight)];
        _sleepRewardView.backgroundColor = [UIColor shan_colorWithHexString:@"000000" alphaComponent:0.8];
        _sleepRewardView.didAttachTaskWithIDAction = ^(NSString *taskRecordId) {
            // 此处taskID 是每个可领取任务的记录id
            [[NSNotificationCenter defaultCenter] postNotificationName:SHANTaskCenterAttachTaskWithTaskIDNotification object:nil userInfo:@{@"taskRecordId":taskRecordId}];
        };
    }
    return _sleepRewardView;
}

@end
