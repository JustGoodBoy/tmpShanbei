//
//  SHANUserAccountModel+HTTP.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/18.
//

#import "SHANUserAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^successCompletion)(id data);
typedef void(^failureCompletion)(NSString *errorMessage);

@interface SHANUserAccountModel (HTTP)

/// 获取用户账户信息
+ (void)shanGetUserAccountInfoOfSuccess:(successCompletion)success
                                failure:(failureCompletion)failure;

@end

NS_ASSUME_NONNULL_END
