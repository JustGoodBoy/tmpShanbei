# ShanbeiSDK

## iOS扇贝SDK

## 安装
*ShanbeiSDK 自带引入YYModel、YYWebImage、ADSuyiSDK、WechatOpenSDK、FDFullscreenPopGesture、IQKeyboardManager

    pod 'ShanbeiSDK',:git => 'http://121.41.108.203/MC-iOS/ShanbeiSDK.git'

## 使用
1、引用  在`AppDelegate.h`中引用：

    #import "WXApi.h"
    #import <ShanbeiSDK/ShanbeiSDK.h>
    
2、使用
在 `didFinishLaunchingWithOptions` 中调用一下方法：

    [[ShanbeiManager shareManager] shanConfigAccountID:accountID];
    [[ShanbeiManager shareManager] configShanAppid:appid ADSuyiAppid:ADSuyiAPPID];

accountID                 ：登陆后的userid
appid                        ：后台配置的appid
ADSuyiAPPID           ：ADSuyi广告appid

若未登录，需在合适的地方调用以下方法：

    [[ShanbeiManager shareManager] shanGoLogin:^{
        // 自定义方法
    }];
    
在获取到userid后调用下面方法：

    [[ShanbeiManager shareManager] shanConfigAccountID:accountID];


获取主页面：

    UIViewController *mainVC = [[ShanbeiManager shareManager] backMainViewControllerWithShowType:SHANShowViewControllerTypeTabbar];

SHANShowViewControllerTypeNavTabbar,    // 作为NavTabbar子控制器
SHANShowViewControllerTypeTabbar,          // 作为ControllerTabbar子控制器
SHANShowViewControllerTypePush,
SHANShowViewControllerTypePresent,

添加代理`<WXApiDelegate>`，并在 ` AppDelegate.m ` 中接收微信回调：

    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {  
        return [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)[SHANWXApiManager sharedManager]];  
    }

    


## Author

地瓜, digua@admobile.top

## License

ShanbeiSDK is available under the MIT license. See the LICENSE file for more info.
