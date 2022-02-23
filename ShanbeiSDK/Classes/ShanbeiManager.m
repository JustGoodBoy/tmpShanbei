//
//  ShanbeiManager.m
//  Pods
//
//  Created by GoodBoy on 2021/9/27.
//

#import "ShanbeiManager.h"
#import "SHANTaskCenterViewController.h"
#import "SHANCommentManager.h"
#import "SHANAdManager.h"
#import "SHANAccountManager.h"
#import "SHANHeader.h"
#import "SHANNoticeName.h"
#import "SHANSDKInfoManager.h"
#import "SHANNetWorkServer.h"
#import "ShanNewUserTaskModel.h"
#import "SHANNewUserTaskView.h"
#import "ShanOpenNewUserRedPacketView.h"
#import "ShanSignedModel.h"
#import "ShanRepairSignInView.h"
#import "ShanOpenAppRecordModel.h"
#import "SHANHUD.h"
static ShanbeiManager *_manager = nil;

@interface ShanbeiManager ()
@property (nonatomic, copy) NSString *userType;
@end

@implementation ShanbeiManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[super allocWithZone:NULL] init];
    });
    [SHANNetWorkServer initNetWorkConfig];
    return _manager;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [ShanbeiManager shareManager];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [ShanbeiManager shareManager];
}

/// 返回控制器
- (UIViewController *)backMainViewControllerWithShowType:(SHANShowViewControllerType)showType {
    SHANTaskCenterViewController *taskCenterVC = [[SHANTaskCenterViewController alloc] init];
    taskCenterVC.hidesBottomBarWhenPushed = NO;
    if (showType == SHANShowViewControllerTypePush || showType == SHANShowViewControllerTypePresent) {
        taskCenterVC.isShowNavBack = YES;
    } else {
        taskCenterVC.isShowNavBack = NO;
    }
    [SHANCommentManager sharedCommentMark].showType = showType;
    if (showType == SHANShowViewControllerTypePush) {
        return taskCenterVC;
    }
    if (showType == SHANShowViewControllerTypeTabbar) {
        return taskCenterVC;
    }
    UINavigationController *taskCenterNav = [[UINavigationController alloc] initWithRootViewController:taskCenterVC];
    return taskCenterNav;
}

/// 用户id
/// @param accountID 用户id
- (void)shanConfigAccountID:(NSString *)accountID {
    [SHANAccountManager sharedManager].shanAccountId = accountID;
    if (kSHANStringIsEmpty(accountID)) {
        [SHANAccountManager sharedManager].isLogin = NO;
    } else {
        [SHANAccountManager sharedManager].isLogin = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SHANReloadAccountIDNotification object:nil];
}

/// 配置
/// @param appid appid
/// @param adAppid ADSuyiAppid
- (void)configShanAppid:(NSString *)appid ADSuyiAppid:(NSString *)adAppid {
    [SHANCommentManager sharedCommentMark].appId = appid;
    [SHANAdManager sharedManager].shanADSuyiAPPID = adAppid;
}

/// 登录
- (void)shanGoLogin:(clickLoginBlock)loginBlock {
    self.loginBlock = loginBlock;
}

/// 版本号
- (NSString *)version {
    return [SHANSDKInfoManager shanVersion];
}

#pragma mark - 新人任务奖励
/// 新用户红包
- (void)shan_newUserRedPacketBlock:(void (^)(void))goCashOutBlock {
    if ([self isCanNewUserRedPacket]) {
        [self showNewUserTaskAlertWithAwardCash:@"5" block:goCashOutBlock];
    }
}

/// 显示新人任务奖励提示
- (void)showNewUserTaskAlertWithAwardCash:(NSString *)awardCash block:(void (^)(void))goCashOutBlock{
    CGRect frame = CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight);
    SHANNewUserTaskView *view = [[SHANNewUserTaskView alloc] initWithFrame:frame];
    [view shan_showAlert:awardCash];
    view.clickCashOutBlock = ^{
        goCashOutBlock();
        if ([[ShanbeiManager shareManager].userType isEqualToString:@"old"]) {
            [SHANNewUserTaskView shan_saveClickNewUserRedPacketState:YES];
            return;
        }
        ShanOpenNewUserRedPacketView *openRedPacketView = [[ShanOpenNewUserRedPacketView alloc] initWithFrame:frame];
        [openRedPacketView shan_showAlert:@"0.3"];
    };
}

#pragma mark - 补签
/// 回归补签
- (void)requestRepairSignIn:(void (^)(void))repairSignInBlock {
    if ([self isCanNewUserRedPacket]) {
        [self showNewUserTaskAlertWithAwardCash:@"5" block:repairSignInBlock];
        return;
    }
    [ShanSignedModel shan_requestSignInListWithSuccess:^(ShanSignedModel * _Nonnull model) {
        if ([model.unSignDays integerValue] == 0) return;
        ShanRepairSignInView *view = [[ShanRepairSignInView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight)];
        [view shan_showAlert:model];
        view.clickRepairBlock = ^{
            repairSignInBlock();
        };
    } failure:^(NSString * _Nonnull errMsg) {
        NSLog(@"%@",errMsg);
    }];
}

#pragma mark - 打开App记录
/// 获取用户打开app信息
/// @param openAppRecordBlock 打开app记录，isNewUser：是否是新用户；intervalDays：距离上一次打开天数 0为当天有打开  1为昨天有打开   类推
- (void)requestOpenAppRecord:(void (^)(BOOL isNewUser, NSInteger intervalDays))openAppRecordBlock {
    [ShanOpenAppRecordModel shan_openAppRecordOfSuccess:^(ShanOpenAppRecordModel * _Nonnull model) {
        BOOL isNewUser = [model.userType isEqualToString:@"new"];
        [ShanbeiManager shareManager].userType = model.userType;
        NSInteger intervalDays = [model.intervalDays integerValue];
        openAppRecordBlock(isNewUser, intervalDays);
    } failure:^(NSString * _Nonnull errMsg) {
        NSLog(@"%@",errMsg);
    }];
}

#pragma mark - 是否登录
- (BOOL)isLogin {
    return [SHANAccountManager sharedManager].isLogin;
}

#pragma mark - 是否可以新人用户红包任务
- (BOOL)isCanNewUserRedPacket {
    BOOL isArise = [SHANNewUserTaskView shan_isAriseNewUserRedPacket];
    if (!isArise) {
        [SHANNewUserTaskView shan_saveNewUserRedPacket];
    }
    return !isArise;
}

#pragma mark - 新老用户
- (BOOL)isNewUser {
    BOOL isOld = [[ShanbeiManager shareManager].userType isEqualToString:@"old"];
    return !isOld;
}
@end
