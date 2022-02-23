//
//  SHANSignInModel+HTTP.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/10/25.
//

#import "SHANSignInModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^successCompletion)(id data);
typedef void(^failureCompletion)(NSString *errorMessage);

@interface SHANSignInModel (HTTP)

/// 获取签到列表
+ (void)shanGetSignInListWithSuccess:(successCompletion)success
                             Failure:(failureCompletion)failure;

/// 签到
+ (void)shanGetSignInSuccess:(successCompletion)success
                     Failure:(failureCompletion)failure;

@end

NS_ASSUME_NONNULL_END
