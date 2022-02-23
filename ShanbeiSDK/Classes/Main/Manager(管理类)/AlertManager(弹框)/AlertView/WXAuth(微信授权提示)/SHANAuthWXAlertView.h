//
//  SHANAuthWXAlertView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 微信授权
@interface SHANAuthWXAlertView : UIView

@property (nonatomic, copy) void (^didAuthWXAction)(void);

@end

NS_ASSUME_NONNULL_END
