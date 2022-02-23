//
//  SHANSleepViewController.h
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/11/24.
//

#import "SHANBaseViewController.h"
@class SHANTaskModel;
NS_ASSUME_NONNULL_BEGIN

/// 睡觉打卡
@interface SHANSleepViewController : SHANBaseViewController
@property (nonatomic, strong) SHANTaskModel *sleepModel;
@property (nonatomic, strong) SHANTaskModel *hideSleepModel;
@end

NS_ASSUME_NONNULL_END
