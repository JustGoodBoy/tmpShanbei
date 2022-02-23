//
//  SHANRuleAlertView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 规则提示
@interface SHANRuleAlertView : UIView

@property (nonatomic, copy) void (^didCloseAction)(void);

@property (nonatomic, copy) void (^didKnownAction)(void);

@end

NS_ASSUME_NONNULL_END
