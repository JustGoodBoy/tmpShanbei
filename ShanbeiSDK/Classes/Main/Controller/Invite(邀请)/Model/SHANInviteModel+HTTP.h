//
//  SHANInviteModel+HTTP.h
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/10/26.
//

#import "SHANInviteModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^successCompletion)(id data);
typedef void(^failureCompletion)(NSString *errorMessage);

@interface SHANInviteModel (HTTP)

/// 获取邀请列表
+ (void)shanGetInviteListSuccess:(successCompletion)success
                         Failure:(failureCompletion)failure;


/// 邀请好友
+ (void)shanGetInvitationFriendWithCode:(NSString *)code
                                 TaskId:(NSString *)taskId
                                Success:(successCompletion)success
                                Failure:(failureCompletion)failure;
@end

NS_ASSUME_NONNULL_END
