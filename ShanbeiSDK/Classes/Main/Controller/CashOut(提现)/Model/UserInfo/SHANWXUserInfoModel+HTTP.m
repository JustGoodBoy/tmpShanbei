//
//  SHANWXUserInfoModel+HTTP.m
//  Pods
//
//  Created by GoodBoy on 2021/9/23.
//

#import "SHANWXUserInfoModel+HTTP.h"
#import "SHANNetWorkRequest.h"
#import "SHANURL.h"
#import "SHANHeader.h"
#import "YYModel.h"

@implementation SHANWXUserInfoModel (HTTP)

/// 绑定微信/pub/weChat/bind
+ (void)shanBindWeChatWithParams:(id)params
                         success:(successCompletion)success
                         failure:(failureCompletion)failure {
    [SHANNetWorkRequest getWithPath:kSHAN_apiBindWeChat params:params success:^(NSDictionary * _Nonnull argDict) {
        NSDictionary *dataDict = [argDict objectForKey:@"data"];
        
        if (kSHANDictIsEmpty(dataDict)) {
            success([[SHANWXUserInfoModel alloc] init]);
        } else {
            SHANWXUserInfoModel *model = [SHANWXUserInfoModel yy_modelWithDictionary:dataDict];
            success(model);
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

@end
