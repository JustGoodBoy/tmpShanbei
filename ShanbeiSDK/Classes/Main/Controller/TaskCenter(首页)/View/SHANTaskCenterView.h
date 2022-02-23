//
//  SHANTaskCenterView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import <UIKit/UIKit.h>
#import "SHANTaskCenterBox.h"
#import "SHANMenu.h"
#import "SHANSignInView.h"
NS_ASSUME_NONNULL_BEGIN

/// 看广告任务状态
typedef NS_ENUM(NSInteger, ShanVideoTaskState) {
    ShanVideoTaskState_Normal  = 0,    // 可做下一个视频任务
    ShanVideoTaskState_Done    = 1,    // 看过追加视频
    ShanVideoTaskState_NotDone = 2     // 未看过追加视频
};

@interface SHANTaskCenterView : UIView

@property (nonatomic, strong) NSMutableArray *taskArray;
@property (nonatomic, strong) SHANSignInView *signInView;
@property (nonatomic, strong) SHANTaskCenterBox *boxImgView;
/// 本次看广告追加任务是否做过
@property (nonatomic, assign) ShanVideoTaskState videoTaskState;

@property (nonatomic, copy) void (^inviteFriendBlock)(NSString *code, NSString *taskId);
@property (nonatomic, copy) void (^didTaskTypeBlock)(SHANTaskListType type);// 区分视频广告任务id
@property (nonatomic ,copy) void (^reportTaskBlock)(SHANTaskListType type);

- (void)shanReloadRewardInfo;

/// 点击宝箱
- (void)clickTaskBoxAction;

- (void)shan_rewardCountDown:(NSInteger)second;
@end

NS_ASSUME_NONNULL_END
