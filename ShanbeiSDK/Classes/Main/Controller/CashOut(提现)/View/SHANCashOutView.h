//
//  SHANCashOutView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/17.
//

#import <UIKit/UIKit.h>
@class SHANCashOutModel;
NS_ASSUME_NONNULL_BEGIN

@interface SHANCashOutView : UIView

@property (nonatomic, strong) SHANCashOutModel *cashOutModel;
/// 判断首次提现
@property (nonatomic, copy) void (^judgeFirstCashOutBlock)(void);

- (void)shanReloadAccountInfo;

/// 提现
- (void)shan_cashOut;

@end

NS_ASSUME_NONNULL_END
