//
//  SHANStatusBarTool.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import "SHANStatusBarTool.h"

CGFloat shanGetStatusBarHeight(void) {
    static CGFloat height = 20;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![UIApplication sharedApplication].isStatusBarHidden) {
            height = [UIApplication sharedApplication].statusBarFrame.size.height;
        } else if (@available(iOS 11.0, *)) {
            UIEdgeInsets safeArea = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
            height = MAX(height, safeArea.top);
            height = MAX(height, safeArea.left);
            height = MAX(height, safeArea.bottom);
            height = MAX(height, safeArea.right);
        }
    });
    
    return height;
}
