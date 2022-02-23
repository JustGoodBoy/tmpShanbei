//
//  SHANNetWorkServer.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANNetWorkServer : NSObject
/// 初始化网络配置
+ (void)initNetWorkConfig;

/// 设置公共参数
+ (NSDictionary *)shan_HTTPHeaderFields;
@end

NS_ASSUME_NONNULL_END
