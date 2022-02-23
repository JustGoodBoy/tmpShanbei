//
//  SHANTaskCenterBox.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 宝箱任务状态
typedef NS_ENUM(NSInteger, ShanBoxTaskState) {
    ShanBoxTaskState_Normal  = 0,    // 可领取下一轮宝箱
    ShanBoxTaskState_Done    = 1,    // 看过追加视频
    ShanBoxTaskState_NotDone = 2     // 未看过追加视频
};

/// 宝箱
@interface SHANTaskCenterBox : UIImageView

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, copy) dispatch_block_t clickGetBoxTask;

@end

NS_ASSUME_NONNULL_END
