//
//  SHANControlManager.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import "SHANControlManager.h"
#import "SHANMyProfitViewController.h"
#import "SHANCashOutViewController.h"
#import "SHANCashOutLaunchViewController.h"
#import "SHANInviteViewController.h"
#import "SHANFaceToFaceViewController.h"
#import "SHANSleepViewController.h"
#import "ShanEatViewController.h"
#import "SHANTaskModel.h"
@implementation SHANControlManager

/// 我的收益
+ (void)openMyProfitViewController {
    SHANMyProfitViewController *vc = [[SHANMyProfitViewController alloc] init];
    UINavigationController *nvgCtrl = [SHANMyProfitViewController currentViewController].navigationController;
    [nvgCtrl pushViewController:vc animated:YES];
}

/// 提现
+ (void)openCashOutViewController {
    SHANCashOutViewController *vc = [[SHANCashOutViewController alloc] init];
    UINavigationController *nvgCtrl = [SHANCashOutViewController currentViewController].navigationController;
    [nvgCtrl pushViewController:vc animated:YES];
}

/// 提现发起
+ (void)openCashOutLaunchViewController {
    SHANCashOutLaunchViewController *vc = [[SHANCashOutLaunchViewController alloc] init];
    UINavigationController *nvgCtrl = [SHANCashOutLaunchViewController currentViewController].navigationController;
    [nvgCtrl pushViewController:vc animated:YES];
}

/// 邀请
+ (void)openInviteViewController {
    SHANInviteViewController *vc = [[SHANInviteViewController alloc] init];
    UINavigationController *nvgCtrl = [SHANInviteViewController currentViewController].navigationController;
    [nvgCtrl pushViewController:vc animated:YES];
}

/// 面对面扫码
+ (void)openFaceToFaceViewController {
    SHANFaceToFaceViewController *vc = [[SHANFaceToFaceViewController alloc] init];
    UINavigationController *nvgCtrl = [SHANFaceToFaceViewController currentViewController].navigationController;
    [nvgCtrl pushViewController:vc animated:YES];
}

/// 睡觉打卡
+ (void)openSleepViewControllerWithSleepModel:(SHANTaskModel *)sleepModel hideSleepModel:(SHANTaskModel *)hideSleepModel {
    SHANSleepViewController *vc = [[SHANSleepViewController alloc] init];
    vc.sleepModel = sleepModel;
    vc.hideSleepModel = hideSleepModel;
    UINavigationController *nvgCtrl = [SHANSleepViewController currentViewController].navigationController;
    [nvgCtrl pushViewController:vc animated:YES];
}

/// 吃饭补贴
+ (void)openEatViewController:(SHANTaskModel *)taskModel {
    ShanEatViewController *vc = [[ShanEatViewController alloc] init];
    vc.taskModel = taskModel;
    UINavigationController *nvgCtrl = [ShanEatViewController currentViewController].navigationController;
    [nvgCtrl pushViewController:vc animated:YES];
}

@end
