//
//  SHANAdManager.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/18.
//

#import "SHANAdManager.h"
#import <ADSuyiSDK/ADSuyiSDK.h>
#import <ADSuyiSDK/ADSuyiSDKRewardvodAd.h>
#import "SHANTaskModel+HTTP.h"
#import "SHANAccountManager.h"
#import "SHANNoticeName.h"
#import "SHANAlertViewManager.h"
#import "NSDictionary+SHAN.h"
#import "SHANHUD.h"
#import "SHANHeader.h"
#import "UIViewController+RootController.h"
static SHANAdManager *_commentMark = nil;

@interface SHANAdManager ()<ADSuyiSDKRewardvodAdDelegate>

@property (nonatomic, strong) ADSuyiSDKRewardvodAd *rewardvodAd;
@property (nonatomic, copy) NSString *attachTaskID;
@property (nonatomic, assign) SHANTaskListType taskType;
@end

@implementation SHANAdManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _commentMark = [[super allocWithZone:NULL] init];
    });
    
    return _commentMark;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [SHANAdManager sharedManager];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [SHANAdManager sharedManager];
}

// 广告
- (void)shanSetAdSDKConfigure {
    NSString *appid = [SHANAdManager sharedManager].shanADSuyiAPPID;
    [ADSuyiSDK initWithAppId:appid completionBlock:^(NSError * _Nonnull error) {
        if (error) {
            NSLog(@"ADMob: 初始化失败, %@", error.localizedDescription);
        } else {
            NSLog(@"ADMob: 初始化成功");
        }
    }];
}

- (void)shanLoadRewardvodAdWithPosId:(NSString *)posId type:(SHANTaskListType)type attachTaskID:(NSString *)attachTaskID {
    [self shanLoadRewardvodAdWithPosId:posId type:type];
    
    _attachTaskID = @"";
    if (!kSHANStringIsEmpty(attachTaskID)) {
        _attachTaskID = attachTaskID;
    }
}

- (void)shanLoadRewardvodAdWithPosId:(NSString *)posId type:(SHANTaskListType)type {
    _taskType = type;
    _rewardvodAd  = [[ADSuyiSDKRewardvodAd alloc] init];
    _rewardvodAd.delegate = self;
    _rewardvodAd.tolerateTimeout = 5;
    _rewardvodAd.controller = [UIViewController shan_getFrontViewControllerWithRootVc];
    _rewardvodAd.posId = posId;
    [self.rewardvodAd loadRewardvodAd];
}

#pragma mark - Private(私有⽅法)
/// 完成任务，积分奖励
- (void)finishRewardvodAdTask {
    // 吃饭
    if (_taskType == SHANTaskListTypeOfEat) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ShanMealSubsideAttachADTaskFinishNotification object:nil];
        return;
    }
    // 首次提现
    if (_taskType == SHANTaskListTypeOfHideCashOut) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ShanFirstCashOutAttachADTaskFinishNotification object:nil];
        return;
        
    }
    
    if (!kSHANStringIsEmpty(_attachTaskID)) {
        // 因为睡觉打卡,领取金币上报
        [[NSNotificationCenter defaultCenter] postNotificationName:SHANSleepTaskFinishRewardvodAdTaskNotification object:nil];
    } else {
        //
        [[NSNotificationCenter defaultCenter] postNotificationName:SHANTaskCenterFinishRewardvodAdTaskNotification object:nil];
    }
}

#pragma mark - ADSuyiSDKRewardvodAdDelegate
/**
 激励视频广告准备好被播放
 
 @param rewardvodAd 广告实例
 */
- (void)adsy_rewardvodAdReadyToPlay:(ADSuyiSDKRewardvodAd *)rewardvodAd{
    // 3、推荐在准备好被播放回调中展示激励视频广告
    if ([self.rewardvodAd rewardvodAdIsReady]) {
        [self.rewardvodAd showRewardvodAd];
        NSLog(@"激励视频广告准备好被播放");
    }
}

/**
 视频播放页关闭回调
 
 @param rewardvodAd 广告实例
 */
- (void)adsy_rewardvodAdDidClose:(ADSuyiSDKRewardvodAd *)rewardvodAd{
    // 4、广告内存回收
    _rewardvodAd = nil;
    [self finishRewardvodAdTask];
}

/**
 视频广告请求失败回调
 
 @param rewardvodAd 广告实例
 @param errorModel 具体错误信息
 */
- (void)adsy_rewardvodAdFailToLoad:(ADSuyiSDKRewardvodAd *)rewardvodAd errorModel:(ADSuyiAdapterErrorDefine *)errorModel{
    // 4、广告内存回收
    _rewardvodAd = nil;
    NSLog(@"视频广告请求失败回调:%@",errorModel);
    [SHANHUD showInfoWithTitle:@"视频广告任务失败"];
}
@end
