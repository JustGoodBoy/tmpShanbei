//
//  SHANSleepCollectionViewCell.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 任务类型
typedef NS_ENUM(NSInteger, SHANSleepTaskRewardState) {
    SHANSleepTaskRewardStateOfReceived      = 0,    // 已领取
    SHANSleepTaskRewardStateOfReceive       = 1,    // 可领取
    SHANSleepTaskRewardStateOfNotReceived   = 2,    // 待完成
};

@interface SHANSleepCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) SHANSleepTaskRewardState rewardState;
@end

NS_ASSUME_NONNULL_END
