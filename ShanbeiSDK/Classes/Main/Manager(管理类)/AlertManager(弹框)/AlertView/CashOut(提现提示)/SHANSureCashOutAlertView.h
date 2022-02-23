//
//  SHANSureCashOutAlertView.h
//  Pods
//
//  Created by GoodBoy on 2021/9/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 提现
@interface SHANSureCashOutAlertView : UIView

@property (nonatomic, copy) NSString *cashMoney;

@property (nonatomic, copy) NSString *mode;

@property (nonatomic, copy) void (^didCloseAction)(void);

@property (nonatomic, copy) void (^didSureAction)(void);

@end

NS_ASSUME_NONNULL_END
