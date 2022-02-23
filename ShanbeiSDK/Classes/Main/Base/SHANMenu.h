//
//  SHANMenu.h
//  Pods
//
//  Created by GoodBoy on 2021/11/20.
//

#ifndef SHANMenu_h
#define SHANMenu_h


#endif /* SHANMenu_h */

/// 任务类型
typedef NS_ENUM(NSInteger, SHANTaskListType) {
    SHANTaskListTypeOfCashOut        = 1,    // 提现
    SHANTaskListTypeOfRewardVideo    = 2,    // 看视频（广告）赚积分
    SHANTaskListTypeOfDownload       = 3,    // 下载(ios没有)
    SHANTaskListTypeOfAd             = 4,    // 场景广告(ios没有)
    SHANTaskListTypeOfInviteUser     = 5,    // 邀请好友
    SHANTaskListTypeOfBindUser       = 6,    // 绑定用户
    SHANTaskListTypeOfHideSign       = 7,    // 签到任务-追加视频任务
    SHANTaskListTypeOfBox            = 8,    // 宝箱任务
    SHANTaskListTypeOfCash           = 9,    // 现金红包(倒计时)
    SHANTaskListTypeOfHideBox        = 10,   // 宝箱任务-追加视频任务
    SHANTaskListTypeOfHideRewardVideo= 11,   // 看视频（广告）赚积分任务-追加视频任务
    SHANTaskListTypeOfSleep          = 12,   // 睡觉打卡任务
    SHANTaskListTypeOfHideSleep      = 13,   // 睡觉打卡任务-追加视频任务
    SHANTaskListTypeOfEat            = 14,   // 吃饭补助任务
    SHANTaskListTypeOfHideCashOut    = 16,   // 提现隐藏任务
};
