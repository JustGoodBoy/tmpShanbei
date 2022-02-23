//
//  SHANCashOutFrequencyAlertView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/17.
//  提现次数

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 提现次数
@interface SHANCashOutFrequencyAlertView : UIView

@property (nonatomic, copy) void (^didCloseAction)(void);

@property (nonatomic, copy) void (^didToCashOutAction)(void);

- (void)setCurrent:(NSString *)current AndFrequency:(NSString *)frequency;

@end

NS_ASSUME_NONNULL_END
