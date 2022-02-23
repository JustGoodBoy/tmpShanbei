//
//  UIView+SHANGetController.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/18.
//

#import "UIView+SHANGetController.h"

@implementation UIView (SHANGetController)

/// 获取当前view所在的控制器
- (UIViewController *)viewController {
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

@end
