//
//  SHANWXApiManager.h
//  Pods
//
//  Created by GoodBoy on 2021/9/23.
//

#import <Foundation/Foundation.h>
@class SendAuthResp;

NS_ASSUME_NONNULL_BEGIN

@protocol SHANWXApiManagerDelegate <NSObject>

@optional

- (void)shanManagerDidRecvAuthResponse:(SendAuthResp *)response;

@end


@interface SHANWXApiManager : NSObject

@property (nonatomic, assign) id<SHANWXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;

/// 授权
- (void)shanSendAuthRequestInViewController:(UIViewController *)viewController;

/// 切换账号授权
- (void)shanSendAuthSwitchAccountRequestInViewController:(UIViewController *)viewController;

/// 是否安装微信
- (BOOL)shanIsWXAppInstalled;

/// 判断当前微信的版本是否支持OpenApi
- (BOOL)shanIsWXAppSupportApi;

/// 未安装提示
- (void)shanUninstalledWXAppTips:(UIViewController *)viewController;

/// 低版本提示
- (void)shanLowVersionWXAppTips:(UIViewController *)viewController;

/// 文字分享
- (void)shanShareWithText:(NSString *)shareText scene:(NSInteger)scene;
@end

NS_ASSUME_NONNULL_END
