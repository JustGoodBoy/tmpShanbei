//
//  SHANControlManager.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import <Foundation/Foundation.h>
@class SHANTaskModel;
@class ShanEatModel;
NS_ASSUME_NONNULL_BEGIN

@interface SHANControlManager : NSObject

/// 我的收益
+ (void)openMyProfitViewController;

/// 提现
+ (void)openCashOutViewController;

/// 提现发起
+ (void)openCashOutLaunchViewController;

/// 邀请
+ (void)openInviteViewController;

/// 面对面扫码
+ (void)openFaceToFaceViewController;

/// 睡觉打卡
+ (void)openSleepViewControllerWithSleepModel:(SHANTaskModel *)sleepModel hideSleepModel:(SHANTaskModel *)hideSleepModel;

/// 吃饭补贴
+ (void)openEatViewController:(SHANTaskModel *)eatModel;

@end

NS_ASSUME_NONNULL_END
