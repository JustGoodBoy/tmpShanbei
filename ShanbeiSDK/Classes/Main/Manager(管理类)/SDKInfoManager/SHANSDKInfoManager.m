//
//  SHANSDKInfoManager.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2022/1/20.
//

#import "SHANSDKInfoManager.h"

static NSString * const ShanSDKVersion = @"1.1.0";

@implementation SHANSDKInfoManager

/// SDK版本号
+ (NSString *)shanVersion {
    return ShanSDKVersion;
}

@end
