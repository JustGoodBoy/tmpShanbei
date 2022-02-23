//
//  UIViewController+RootController.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import "UIViewController+RootController.h"

@implementation UIViewController (RootController)

+ (UIViewController *)shan_PresentingController {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        NSMutableArray *viewVcWindows = [NSMutableArray new];
        NSMutableArray *noViewVcWindows = [NSMutableArray new];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                if ([tmpWin.rootViewController isMemberOfClass:[UIViewController class]]) {
                    [viewVcWindows addObject:tmpWin];
                } else {
                    [noViewVcWindows addObject:tmpWin];
                }
            }
        }
        //有时会出现多个UIWindowLevelNormal的windows，其中存在rootViewController为uiviewcontroller的控制器，但是他不是主界面，所以这里进行筛选
        if (noViewVcWindows.count > 0) {
            window = noViewVcWindows[0];
        } else if (viewVcWindows.count > 0) {
            window = viewVcWindows[0];
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if (result.navigationController) {
        result = result.navigationController.topViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

+ (UIViewController *)shan_getFrontViewControllerWithRootVc {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = window.rootViewController;

Front:
    while (vc.presentedViewController != nil) vc = vc.presentedViewController;
    if ([vc isKindOfClass:UITabBarController.class] && [(UITabBarController*)vc selectedViewController]) {
        vc = [(UITabBarController*)vc selectedViewController];
        goto Front;
    }
    if ([vc isKindOfClass:UINavigationController.class] && ((UINavigationController*)vc).topViewController) {
        vc = ((UINavigationController*)vc).topViewController;
        goto Front;
    }
    return vc;
}

+ (UIWindow *)shan_GetNormalWindow {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        NSMutableArray *viewVcWindows = [NSMutableArray new];
        NSMutableArray *noViewVcWindows = [NSMutableArray new];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                if ([tmpWin.rootViewController isMemberOfClass:[UIViewController class]]) {
                    [viewVcWindows addObject:tmpWin];
                } else {
                    [noViewVcWindows addObject:tmpWin];
                }
            }
        }
        //有时会出现多个UIWindowLevelNormal的windows，其中存在rootViewController为uiviewcontroller的控制器，但是他不是主界面，所以这里进行筛选
        if (noViewVcWindows.count > 0) {
            window = noViewVcWindows[0];
        } else if (viewVcWindows.count > 0){
            window = viewVcWindows[0];
        }
    }
    return window;
}

@end
