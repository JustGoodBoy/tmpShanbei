//
//  UIViewController+RootController.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (RootController)

/// 返回当前显示的控制器
+ (UIViewController *)shan_PresentingController;

/// 获取顶部vc
+ (UIViewController *)shan_getFrontViewControllerWithRootVc;

+ (UIWindow *)shan_GetNormalWindow;

@end

NS_ASSUME_NONNULL_END
