//
//  ShanSignedModel.h
//  ShanbeiSDK-ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/21.
//

#import <Foundation/Foundation.h>

@class ShanSignInTaskBosModel;

NS_ASSUME_NONNULL_BEGIN

/// 签到列表model
@interface ShanSignedModel : NSObject
/// 当日是否已签到  true  false
@property (nonatomic, assign) BOOL isSignToday;
/// 今日签到对应id
@property (nonatomic, copy) NSString *todaySignId;
/// 未签到天数
@property (nonatomic, copy) NSString *unSignDays;
/// 签到提示文案
@property (nonatomic, copy) NSString *signCopy;
/// 签到列表
@property (nonatomic, strong) NSArray<ShanSignInTaskBosModel *> *signInTaskBos;

@end

#pragma mark - ShanSignedModel - HTTP
typedef void(^failureBlock)(NSString *errMsg);

@interface ShanSignedModel (HTTP)

/// 获取签到列表
+ (void)shan_requestSignInListWithSuccess:(void(^)(ShanSignedModel *model))success
                                  failure:(failureBlock)failure;

/// 签到
+ (void)shan_requestSignInWithId:(NSString *)signInTaskId
                         success:(void(^)(ShanSignInTaskBosModel *model))success
                         failure:(failureBlock)failure;

/// 签到追加上报
+ (void)shan_reportSignInAttachSuccess:(void(^)(NSDictionary *dict))success
                               failure:(failureBlock)failure;
@end


#pragma mark - signInTaskBos 签到列表Model
@interface ShanSignInTaskBosModel : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;
/// 金额
@property (nonatomic, copy) NSString *awardCoin;
/// 描述
@property (nonatomic, copy) NSString *Description;
/// 签到id
@property (nonatomic, copy) NSString *signTaskId;
/// 0 未签到  1 已签到 2 未到签到时间
@property (nonatomic, copy) NSString *signStatus;
/// 倒计时（秒）
@property (nonatomic, copy) NSString *countdown;
/// 看广告追加奖励
@property (nonatomic, copy) NSString *secondCoin;
/// 广告位配置id
@property (nonatomic, copy) NSString *advertisingPositionId;
@end

NS_ASSUME_NONNULL_END
