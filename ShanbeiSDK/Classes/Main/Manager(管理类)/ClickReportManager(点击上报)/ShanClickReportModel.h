//
//  ShanClickReportModel.h
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2022/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 点击类型
typedef NS_ENUM(NSInteger, ShanClickType) {
    ShanClickTypeOfDefault = 0,     // 未知
    ShanClickTypeOfUserSign,        // 签到任务
    ShanClickTypeOfSeeAd,           // 看广告任务
    ShanClickTypeOfMealSubsidy,     // 吃饭补贴
    ShanClickTypeOfInviteUsers,     // 邀请用户
    ShanClickTypeOfFillInviteCode,  // 填写邀请码
    ShanClickTypeOfToWithdraw,      // 去提现
    ShanClickTypeOfTreasureChest,   // 开宝箱
    ShanClickTypeOfSleepSubsidy,    // 睡觉赚钱
};

/// 用户点击行为上报
@interface ShanClickReportModel : NSObject

@end

@interface ShanClickReportModel (HTTP)

/// 点击上报
+ (void)shanClickReport:(ShanClickType)type;

@end

NS_ASSUME_NONNULL_END
