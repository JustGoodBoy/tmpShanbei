//
//  SHANTaskBoxAlertView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 点击宝箱
@interface SHANTaskBoxAlertView : UIView

@property (nonatomic, copy) void (^didAttachTaskAction)(void);

- (void)setInfoWithCoin:(NSString *)coin attachCoin:(NSString *)attachCoin;

@end

NS_ASSUME_NONNULL_END
