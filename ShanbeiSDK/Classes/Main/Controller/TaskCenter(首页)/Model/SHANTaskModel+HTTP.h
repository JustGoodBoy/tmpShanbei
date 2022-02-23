//
//  SHANTaskModel+HTTP.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/18.
//

#import "SHANTaskModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^successCompletion)(id data);
typedef void(^failureCompletion)(NSString *errorMessage);

/// 网络请求
@interface SHANTaskModel (HTTP)

/// 获取任务列表
+ (void)shanGetTaskOfSuccess:(successCompletion)success
                     failure:(failureCompletion)failure;

+ (CGFloat)cellHeight:(SHANTaskModel *)model;
@end

NS_ASSUME_NONNULL_END
