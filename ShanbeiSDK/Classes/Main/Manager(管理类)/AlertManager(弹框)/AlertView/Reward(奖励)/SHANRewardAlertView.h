//
//  SHANRewardAlertView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SHANRewardBackGroundType) {
    SHANRewardBackGroundTypeOfNormal = 0,
    SHANRewardBackGroundTypeOfDark   = 1
};

/// 奖励提示
@interface SHANRewardAlertView : UIView

@property (nonatomic, copy) void (^didAttachTaskWithIDAction)(NSString *taskRecordId);

- (instancetype)initWithFrame:(CGRect)frame type:(SHANRewardBackGroundType)type;

/// 设置正常的奖励提示框
- (void)shan_setNormalRewardTitle:(NSString *)title reward:(NSString *)reward;

/// 设置有追加任务的奖励提示框
- (void)shan_setAttachRewardTitle:(NSString *)title
                           reward:(NSString *)reward
                       rewardTips:(NSString *)rewardTips
                     attachTaskID:(NSString *)attachTaskID;

@end

NS_ASSUME_NONNULL_END
