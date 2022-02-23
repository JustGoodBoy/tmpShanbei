//
//  SHANCashOutModel+HTTP.h
//  Pods
//
//  Created by GoodBoy on 2021/9/23.
//

#import "SHANCashOutModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^successCompletion)(id data);
typedef void(^failureCompletion)(NSString *errorMessage);

@interface SHANCashOutModel (HTTP)

/// 获取提现页面数据信息
+ (void)shanCashOutPageInfoOfSuccess:(successCompletion)success
                             failure:(failureCompletion)failure;

/// 提现
+ (void)shanCashOutWithParams:(id)params
                      success:(successCompletion)success
                      failure:(failureCompletion)failure;

@end

NS_ASSUME_NONNULL_END
