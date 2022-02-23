//
//  SHANNetWorkRequestSetterManager.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANNetWorkRequestSetterManager : NSObject

+ (SHANNetWorkRequestSetterManager *)mark;

/// 默认域名
@property (nonatomic, copy) NSString *shanNetHost;

/// 默认成功code值(默认0)
@property (nonatomic, assign) NSInteger shanNetCode;

/// 基础参数字典
@property (nonatomic, strong) NSDictionary *shanNetBodyDict;

@end

NS_ASSUME_NONNULL_END
