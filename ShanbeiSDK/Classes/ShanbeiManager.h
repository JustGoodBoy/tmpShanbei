//
//  ShanbeiManager.h
//  Pods
//
//  Created by GoodBoy on 2021/9/27.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

// 页面导入方式
typedef NS_ENUM(NSInteger, SHANShowViewControllerType) {
    SHANShowViewControllerTypeNavTabbar = 0,    // 作为NavTabbar子控制器
    SHANShowViewControllerTypeTabbar, // 作为ControllerTabbar子控制器
    SHANShowViewControllerTypePush,
    SHANShowViewControllerTypePresent,
};

typedef void (^clickLoginBlock)(void);

@interface ShanbeiManager : NSObject

@property (nonatomic, copy) clickLoginBlock loginBlock;

+ (instancetype)shareManager;

/// 返回主控制器
/// @param showType 页面导入方式
- (UIViewController *)backMainViewControllerWithShowType:(SHANShowViewControllerType)showType;

/// 用户id
/// @param accountID 用户id
- (void)shanConfigAccountID:(NSString *)accountID;

/// 配置
/// @param appid appid
/// @param adAppid ADSuyiAppid
- (void)configShanAppid:(NSString *)appid ADSuyiAppid:(NSString *)adAppid;

/// 登录
- (void)shanGoLogin:(clickLoginBlock)loginBlock;

/// 版本号
- (NSString *)version;

/// 新人任务奖励
- (void)shan_newUserRedPacketBlock:(void (^)(void))goCashOutBlock;

/// 回归补签
/// @param repairSignInBlock 点击补签回调
- (void)requestRepairSignIn:(void (^)(void))repairSignInBlock;

/// 获取用户打开app信息
/// @param openAppRecordBlock 打开app记录，isNewUser：是否是新用户；intervalDays：距离上一次打开天数 0为当天有打开  1为昨天有打开   类推
- (void)requestOpenAppRecord:(void (^)(BOOL isNewUser, NSInteger intervalDays))openAppRecordBlock;

#pragma mark - 是否登录
- (BOOL)isLogin;

/// 新老用户
- (BOOL)isNewUser;
@end

NS_ASSUME_NONNULL_END
