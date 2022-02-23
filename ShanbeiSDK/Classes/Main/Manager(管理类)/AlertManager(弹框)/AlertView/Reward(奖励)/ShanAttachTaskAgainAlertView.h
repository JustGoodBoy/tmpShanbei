//
//  ShanAttachTaskAgainAlertView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/2/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 再次弹出追加任务弹框
@interface ShanAttachTaskAgainAlertView : UIView
/// 标题
@property (nonatomic, copy) NSString *titleTxt;
/// 奖励
@property (nonatomic, copy) NSString *awardTxt;
/// 按钮文字
@property (nonatomic, copy) NSString *sureBtnTxt;

@property (nonatomic, copy) void (^didSureAction)(void);

- (void)shan_showAlert;

@end

NS_ASSUME_NONNULL_END
