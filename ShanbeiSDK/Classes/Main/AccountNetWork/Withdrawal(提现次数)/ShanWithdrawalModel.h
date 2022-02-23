//
//  ShanWithdrawalModel.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/2/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 用户提现次数
@interface ShanWithdrawalModel : NSObject

@end

@interface ShanWithdrawalModel (HTTP)

/// 用户提现次数
+ (void)shan_withdrawalTimesOfSuccess:(void(^)(NSInteger times))success
                              failure:(void(^)(NSString *errMsg))failure;

@end

NS_ASSUME_NONNULL_END
