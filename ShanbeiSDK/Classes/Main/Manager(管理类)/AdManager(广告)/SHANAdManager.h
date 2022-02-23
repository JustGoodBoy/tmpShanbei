//
//  SHANAdManager.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/18.
//

#import <Foundation/Foundation.h>
#import "SHANMenu.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHANAdManager : NSObject

/// 广告APPID
@property (nonatomic, copy) NSString *shanADSuyiAPPID;

+ (instancetype)sharedManager;

- (void)shanSetAdSDKConfigure;
/// 看视频
- (void)shanLoadRewardvodAdWithPosId:(NSString *)posId type:(SHANTaskListType)type;
/// 追加任务看视频
- (void)shanLoadRewardvodAdWithPosId:(NSString *)posId type:(SHANTaskListType)type attachTaskID:(NSString *)attachTaskID;
@end

NS_ASSUME_NONNULL_END
