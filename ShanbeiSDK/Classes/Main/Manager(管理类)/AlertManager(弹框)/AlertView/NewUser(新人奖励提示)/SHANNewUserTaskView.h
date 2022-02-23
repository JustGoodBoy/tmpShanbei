//
//  SHANNewUserTaskView.h
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2022/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 新人奖励
@interface SHANNewUserTaskView : UIView

@property (nonatomic, copy) dispatch_block_t clickCashOutBlock;

- (void)shan_showAlert:(NSString *)awardCash;

/// 记录新人用户红包
+ (void)shan_saveNewUserRedPacket;

/// 是否出现过新人用户红包
+ (BOOL)shan_isAriseNewUserRedPacket;

/// 记录新人用户点击红包
+ (void)shan_saveClickNewUserRedPacketState:(BOOL)state;

/// 是否点击过过新人用户红包
+ (BOOL)shan_isClickNewUserRedPacketState;
@end

NS_ASSUME_NONNULL_END
