//
//  SHANBaseViewController.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANBaseViewController : UIViewController

+ (UIViewController *)currentViewController;

- (void)back;

@end

@interface SHANBaseNavigationController : UINavigationController

@end
NS_ASSUME_NONNULL_END
