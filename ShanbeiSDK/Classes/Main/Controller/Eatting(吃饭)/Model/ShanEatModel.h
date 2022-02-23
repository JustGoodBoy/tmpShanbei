//
//  ShanEatModel.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ShanMealSubsideBosModel;

/// 吃饭model
@interface ShanEatModel : NSObject

/// 大标题
@property (nonatomic, copy) NSString *title;
/// 当前时间对应补贴id
@property (nonatomic, copy) NSString *mealSubsideId;
/// 倒计时
@property (nonatomic, copy) NSString *countdown;
/// 补贴列表
@property (nonatomic, strong) NSArray<ShanMealSubsideBosModel *> *mealSubsideBos;
/// 补贴追加奖励倒计时
@property (nonatomic, strong) NSString *additionalRewardsCountdown;
@end

@interface ShanEatModel (HTTP)
/// 吃饭补贴列表
+ (void)shan_requestSubsideInfoWithSuccess:(void(^)(ShanEatModel *model))success
                                   failure:(void(^)(NSString *errMsg))failure;
/// 补贴下发
+ (void)shan_requestSubsideRewardWithId:(NSString *)mealSubsideId
                                success:(void(^)(NSDictionary *dict))success
                                failure:(void(^)(NSString *errMsg))failure;
/// 吃饭补贴追加奖励
+ (void)shan_reportMealSubsideAttachWithSuccess:(void(^)(NSString *reward))success
                                        failure:(void(^)(NSString *errMsg))failure;
@end

#pragma mark - 补贴Model
/// 补贴Model
@interface ShanMealSubsideBosModel : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;
/// 补贴id
@property (nonatomic, copy) NSString *mealSubsideId;
/// 补贴数值
@property (nonatomic, copy) NSString *awardIntegral;
/// 领取状态:  1 已领取  2 已过期  3 可领取  4 待领取
@property (nonatomic, copy) NSString *receiveStatus;
/// 时间区域
@property (nonatomic, copy) NSString *timePeriod;

@end


NS_ASSUME_NONNULL_END
