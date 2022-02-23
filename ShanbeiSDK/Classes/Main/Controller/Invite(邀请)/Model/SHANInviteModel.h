//
//  SHANInviteModel.h
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHANInviteItem : NSObject
@property (nonatomic, copy) NSString *content; // 内容
@property (nonatomic, copy) NSString *awardCash;    // 现金奖励
@property (nonatomic, copy) NSString *count;   // 邀请好友个数
@property (nonatomic, copy) NSString *appId;  // appId
@end

@interface SHANInviteModel : NSObject

@property (nonatomic, strong) NSArray<SHANInviteItem *> *inviteTaskPos;
@property (nonatomic, copy) NSString *invitationCode;   // 用户邀请码
@property (nonatomic, copy) NSString *friendCount;  // 邀请好友个数
@property (nonatomic, copy) NSString *url;  // 跳转地址

@end




NS_ASSUME_NONNULL_END
