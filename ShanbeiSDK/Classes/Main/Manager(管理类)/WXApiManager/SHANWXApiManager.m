//
//  SHANWXApiManager.m
//  Pods
//
//  Created by GoodBoy on 2021/9/23.
//

#import "SHANWXApiManager.h"
#import "WXApi.h"
#import "UIDevice+SHAN.h"
#import "SHANHeader.h"
@interface SHANWXApiManager ()<WXApiDelegate>

@end
@implementation SHANWXApiManager

#pragma mark - LifeCycle
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static SHANWXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[SHANWXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp*)resp {
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(shanManagerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [self.delegate shanManagerDidRecvAuthResponse:authResp];
        }
    }
}

#pragma mark - Public
/// 授权
- (void)shanSendAuthRequestInViewController:(UIViewController *)viewController {
    
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = [UIDevice shan_getDeviceId];
    
    [WXApi sendAuthReq:req
        viewController:viewController
              delegate:[SHANWXApiManager sharedManager]
            completion:nil];
}

/// 切换账号授权
- (void)shanSendAuthSwitchAccountRequestInViewController:(UIViewController *)viewController {
    NSString *openid = [[NSUserDefaults standardUserDefaults] valueForKey:@"SHANWXUserInfoOpenID"];
    if (kSHANStringIsEmpty(openid)) {
        return;
    }
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.openID = openid;
    req.state = [UIDevice shan_getDeviceId];
    
    [WXApi sendAuthReq:req
        viewController:viewController
              delegate:[SHANWXApiManager sharedManager]
            completion:nil];
}

/// 检查微信是否已被用户安装
- (BOOL)shanIsWXAppInstalled {
    return [WXApi isWXAppInstalled];
}

/// 判断当前微信的版本是否支持OpenApi
- (BOOL)shanIsWXAppSupportApi {
    return [WXApi isWXAppSupportApi];
}

/// 未安装提示
- (void)shanUninstalledWXAppTips:(UIViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前未安装微信！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了确认按钮");
        }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:conform];
    [alert addAction:cancel];
    [viewController presentViewController:alert animated:YES completion:nil];
}

/// 低版本提示
- (void)shanLowVersionWXAppTips:(UIViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前微信版本过低，请更新至最新版本！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *conform = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
        }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:conform];
    [alert addAction:cancel];
    [viewController presentViewController:alert animated:YES completion:nil];
}

/// 文字分享
- (void)shanShareWithText:(NSString *)shareText scene:(NSInteger)scene {
    /**
     我在用这款nameAPP：
     下载安装后填我邀请码
     123456
     即可领取现金红包，每天可提现
     下载地址：https://123456
     */
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = shareText;
    if (scene == 0) {   // 好友
        req.scene = WXSceneSession;
    } else if (scene == 1) {    // 朋友圈
        req.scene = WXSceneTimeline;
    }
    [WXApi sendReq:req completion:nil];
}

@end
