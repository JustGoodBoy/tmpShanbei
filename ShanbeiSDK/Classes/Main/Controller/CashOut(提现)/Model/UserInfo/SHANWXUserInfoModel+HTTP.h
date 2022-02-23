//
//  SHANWXUserInfoModel+HTTP.h
//  Pods
//
//  Created by GoodBoy on 2021/9/23.
//

#import "SHANWXUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^successCompletion)(id data);
typedef void(^failureCompletion)(NSString *errorMessage);

@interface SHANWXUserInfoModel (HTTP)

/// 绑定微信
+ (void)shanBindWeChatWithParams:(id)params
                         success:(successCompletion)success
                         failure:(failureCompletion)failure;

@end

NS_ASSUME_NONNULL_END
