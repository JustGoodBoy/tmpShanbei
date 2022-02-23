//
//  SHANURL.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/18.
//

#ifndef SHANURL_h
#define SHANURL_h

#if DEBUG
//    #define kSHANServerUrl @"http://114.55.237.211:9091/"
    #define kSHANServerUrl @"https://jl.xinghexx.com/"
#else
    #define kSHANServerUrl @"https://jl.xinghexx.com/"
#endif

#pragma mark - 福利相关
#define kSHAN_apiUserTask          @"pub/user/task"  // 获取福利列表
#define kSHAN_apiTaskRecord        @"pub/save/user/task/record"   // 上报福利完成记录

#pragma mark - 账户相关
#define kSHAN_apiUserAccountInfo   @"pub/user/account/info"  // 获取用户账户信息
#define kSHAN_apiCoinRecord        @"pub/list/coin/record"    // 获取金币记录
#define kSHAN_apiCashRecord        @"pub/list/cash/record"    // 获取现金记录

#pragma mark - 绑定微信
#define kSHAN_apiBindWeChat        @"pub/weChat/bind"    // 绑定微信

#pragma mark - 提现相关
#define kSHAN_apiDepositList       @"pub/withdraw/deposit/list" // 获取提现页面数据信息
#define kSHAN_apiCashOut           @"pub/withdraw/deposit" // 提现接口

#pragma mark - 签到相关
#define kSHAN_apiSigningTask        @"pub/signing/task" // 签到
#define kSHAN_apiSigningTaskList    @"pub/signing/task/list" // 签到任务列表
#define kSHAN_apiSigningTask2        @"pub/signing/task/v2" // 签到
#define kSHAN_apiSigningTaskList2    @"pub/signing/task/list/v2" // 签到任务列表
#define kSHAN_apiSigningTaskBonus    @"pub/signing/task/bonus" // 签到追加奖励

#pragma mark - 邀请相关
#define kSHAN_apiInvitationCode     @"pub/invitation/select/code" // 查询用户邀请码和邀请列表
#define kSHAN_apiInvitationFriend   @"pub/invitation/friend" // 邀请好友

#pragma mark - 分享相关
#define kSHAN_apiShareContent       @"pub/share/content" // 分享内容

#pragma mark - 获取加密令牌
#define kSHAN_apiEncryptToken       @"/pub/encrypt/token"

#pragma mark - 领现金任务
#define kSHAN_apiReceiveCash        @"pub/receive/rewards/content" // 领现金任务内容
#define kSHAN_apiReceiveCashReport  @"pub/receive/rewards/report"  // 领取现金任务上报

#pragma mark - 吃饭补贴
#define kSHAN_apiMealSubsideList    @"pub/meal/subside/list" // 吃饭补贴列表
#define kSHAN_apiMealSubsideReward  @"pub/meal/subside/reward/issue" // 补贴下发
#define kSHAN_apiMealSubsideBonus   @"pub/meal/subside/task/bonus"// 吃饭补贴追加奖励

#pragma mark - 账户相关
#define kSHAN_apiUserCouple           @"pub/user/couple/task" // 判断用户是否已完成新人任务
#define kSHAN_apiUserWithdrawalTimes  @"pub/user/withdrawal/status"  // 查询用户提现次数
#define kSHAN_apiOpenRecordInfo       @"pub/open/record/info"  // 获取用户打开app信息

#endif /* SHANURL_h */
