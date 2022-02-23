//
//  ShanEatViewController.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/22.
//

#import "SHANBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class SHANTaskModel;

/// 宝箱任务状态
typedef NS_ENUM(NSInteger, ShanEatTaskState) {
    ShanEatTaskState_Normal  = 0,    // 可领取补贴
    ShanEatTaskState_Done    = 1,    // 看过追加视频
    ShanEatTaskState_NotDone = 2     // 未看过追加视频
};

/// 吃饭
@interface ShanEatViewController : SHANBaseViewController
@property (nonatomic, strong) SHANTaskModel *taskModel;
@end

NS_ASSUME_NONNULL_END
