//
//  ShanShareManager.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShanShareManager : NSObject
/// 下载链接
@property (nonatomic, copy) NSString *downloadURL;
/// 邀请码
@property (nonatomic, copy) NSString *inviteCode;

+ (instancetype)sharedManager;
/// 获取分享信息
- (void)shan_loadShareCode;
/// 显示分享面板
- (void)shan_showShareView;

@end

NS_ASSUME_NONNULL_END
