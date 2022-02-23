//
//  SHANNetWorkRequest.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 外部暴露方法

/// 网络请求成功
typedef void(^successCompletionHandler)(NSDictionary *argDict);

/// 网络请求失败
typedef void(^failureCompletionHandler)(NSString *errorMessage);

@interface SHANNetWorkRequest : NSObject

/// 默认HOST-GET 请求
/// @param path 路径
/// @param params 参数
/// @param success 成功
/// @param failure 失败
+ (void)getWithPath:(NSString *)path params:(id)params success:(successCompletionHandler)success failure:(failureCompletionHandler)failure;

/// 默认HOST-POST请求
+ (void)postWithPath:(NSString *)path params:(id)params success:(successCompletionHandler)success failure:(failureCompletionHandler)failure;

/// 自定义HOST-GET 请求
+ (void)getCustomHostWithPath:(NSString *)path params:(id)params customHost:(NSString *)host success:(successCompletionHandler)success failure:(failureCompletionHandler)failure;

/// 自定义HOST-POST 请求
+ (void)postCustomHostWithPath:(NSString *)path params:(id)params customHost:(NSString *)host success:(successCompletionHandler)success failure:(failureCompletionHandler)failure;

/// 自定义HOST-GET 请求,code发生改变
+ (void)getCustomHostWithPath:(NSString *)path params:(id)params customHost:(NSString *)host code:(NSInteger)code success:(successCompletionHandler)success failure:(failureCompletionHandler)failure;

/// 自定义HOST-POST 请求,code发生改变
+ (void)postCustomHostWithPath:(NSString *)path params:(id)params customHost:(NSString *)host code:(NSInteger)code success:(successCompletionHandler)success failure:(failureCompletionHandler)failure;

@end

NS_ASSUME_NONNULL_END
