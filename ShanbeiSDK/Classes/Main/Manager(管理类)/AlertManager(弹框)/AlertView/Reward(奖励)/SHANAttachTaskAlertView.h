//
//  SHANAttachTaskAlertView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 完成签到任务，追加视频
@interface SHANAttachTaskAlertView : UIView

@property (nonatomic, copy) void (^didAttachTaskAction)(NSInteger taskType);

/// 设置奖励数据
/// @param coin 本次任务奖励
/// @param attachCoin 附加任务奖励
/// @param attachType 附加任务类型
- (void)setInfoWithCoin:(NSString *)coin attachCoin:(NSString *)attachCoin attachType:(NSInteger)attachType;

@end

NS_ASSUME_NONNULL_END
