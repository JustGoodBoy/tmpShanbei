//
//  ShanShareManager.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/24.
//

#import "ShanShareManager.h"
#import "SHANShareInviteView.h"
#import "SHANInviteModel+HTTP.h"
#import "SHANAccountManager.h"
#import "ShanbeiManager.h"
#import "SHANWXApiManager.h"
#import "SHANControlManager.h"
#import "UIViewController+RootController.h"

static ShanShareManager *_shareMark = nil;

@implementation ShanShareManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareMark = [[super allocWithZone:NULL] init];
    });
    
    return _shareMark;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [ShanShareManager sharedManager];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [ShanShareManager sharedManager];
}

- (void)shan_loadShareCode {
    [SHANInviteModel shanGetInviteListSuccess:^(id  _Nonnull data) {
        SHANInviteModel *inviteModel = (SHANInviteModel *)data;
        [ShanShareManager sharedManager].downloadURL = inviteModel.url;
        [ShanShareManager sharedManager].inviteCode = inviteModel.invitationCode;
    } Failure:^(NSString * _Nonnull errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
}

- (void)shan_showShareView {
    if (![SHANAccountManager sharedManager].isLogin) {
        if ([ShanbeiManager shareManager].loginBlock) {
            [ShanbeiManager shareManager].loginBlock();
        }
        return;
    }
    [[ShanShareManager sharedManager] shan_loadShareCode];
    SHANShareInviteView *shareView = [[SHANShareInviteView alloc] initWithShareInviteView];
    [shareView showAlert];
    shareView.sharePlatformBlock = ^(NSInteger index) {
        if (index == 0 || index == 1) {
            if (![[SHANWXApiManager sharedManager] shanIsWXAppInstalled]) {
                [[SHANWXApiManager sharedManager] shanUninstalledWXAppTips:[UIViewController shan_getFrontViewControllerWithRootVc]];
                return;
            }
            NSString *url = [ShanShareManager sharedManager].downloadURL;
            NSString *code = [ShanShareManager sharedManager].inviteCode;
            NSString *appName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
            NSString *shareText = [NSString stringWithFormat:@"我在用这款%@APP：\n下载安装后填我邀请码\n%@\n即可领取现金红包，每天可提现\n下载地址：%@",appName,code,url];
            [[SHANWXApiManager sharedManager] shanShareWithText:shareText scene:index];
        }
        if (index == 2) {
            [SHANControlManager openFaceToFaceViewController];
        }
    };
}

@end
