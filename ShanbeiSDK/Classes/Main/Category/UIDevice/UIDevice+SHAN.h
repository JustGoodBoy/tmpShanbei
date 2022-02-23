//
//  UIDevice+SHAN.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (SHAN)

+ (double)shan_systemVersion;

+ (NSString *)shan_systemDetailVersion;

/// 获取设备 Id
+ (NSString *)shan_getDeviceId;

+ (NSString *)shan_getDeviceModel;

/// 获取app name
+ (NSString *)shan_getAppName;

/// 获取app icon
+ (NSString *)shan_getAppIcon;

@end

NS_ASSUME_NONNULL_END
