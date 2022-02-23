//
//  UIView+SHANGetController.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SHANGetController)

/// 获取当前view所在的控制器
- (UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
