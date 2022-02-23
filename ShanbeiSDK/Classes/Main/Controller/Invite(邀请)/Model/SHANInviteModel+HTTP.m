//
//  SHANInviteModel+HTTP.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/10/26.
//

#import "SHANInviteModel+HTTP.h"
#import "SHANAccountManager.h"
#import "NSDictionary+SHAN.h"
#import "SHANNetWorkRequest.h"
#import "SHANURL.h"
#import "SHANHeader.h"
#import "YYModel.h"
@implementation SHANInviteModel (HTTP)

/// 获取邀请列表
+ (void)shanGetInviteListSuccess:(successCompletion)success
                         Failure:(failureCompletion)failure {
    [SHANNetWorkRequest getWithPath:kSHAN_apiInvitationCode params:nil success:^(NSDictionary * _Nonnull argDict) {
        NSDictionary *dict = [argDict objectForKey:@"data"];
        if (kSHANDictIsEmpty(dict)) {
            success([[SHANInviteModel alloc] init]);
        } else {
            SHANInviteModel *model = [SHANInviteModel yy_modelWithDictionary:dict];
            success(model);
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

/// 邀请好友
+ (void)shanGetInvitationFriendWithCode:(NSString *)code
                                 TaskId:(NSString *)taskId
                                Success:(successCompletion)success
                                Failure:(failureCompletion)failure {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params shanSetObjectSafely:code aKey:@"inviteeInvitationCode"];
    [params shanSetObjectSafely:taskId aKey:@"taskId"];
    
    [SHANNetWorkRequest getWithPath:kSHAN_apiInvitationFriend params:params success:^(NSDictionary * _Nonnull argDict) {
        NSDictionary *dict = [argDict objectForKey:@"data"];
        SHANInviteItem *model = [SHANInviteItem yy_modelWithDictionary:dict];
        success(model);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}
@end
