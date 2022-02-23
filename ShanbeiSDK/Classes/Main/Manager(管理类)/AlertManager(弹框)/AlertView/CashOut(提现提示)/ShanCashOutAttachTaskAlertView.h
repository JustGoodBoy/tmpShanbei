//
//  ShanCashOutAttachTaskAlertView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/2/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 提现追加任务提示
@interface ShanCashOutAttachTaskAlertView : UIView
@property (nonatomic, copy) void (^didNextStepAction)(void);
- (void)shan_showAlert;

@end

NS_ASSUME_NONNULL_END
