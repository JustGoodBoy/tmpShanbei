//
//  ShanNewUserTaskModel.h
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2022/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 新人任务（领现金任务内容）
@interface ShanNewUserTaskModel : NSObject

/// 现金奖励
@property (nonatomic, strong) NSString *awardCash;
/// 现金奖励(分)
@property (nonatomic, strong) NSString *awardCashRmb;
/// 描述
@property (nonatomic, strong) NSString *Description;
/// 提醒状态 0关闭 1开启
@property (nonatomic, assign) BOOL remindStatus;

@end

@interface ShanNewUserTaskModel (HTTP)

/// 领现金任务内容
+ (void)shan_newuserRewardsSuccess:(void(^)(ShanNewUserTaskModel *model))success
                           failure:(void(^)(NSString *errMsg))failure;

@end

NS_ASSUME_NONNULL_END
