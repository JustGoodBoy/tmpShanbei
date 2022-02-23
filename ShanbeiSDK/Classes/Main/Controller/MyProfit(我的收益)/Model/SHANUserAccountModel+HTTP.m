//
//  SHANUserAccountModel+HTTP.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/18.
//

#import "SHANUserAccountModel+HTTP.h"
#import "SHANNetWorkRequest.h"
#import "SHANURL.h"
#import "SHANHeader.h"
#import "YYModel.h"
@implementation SHANUserAccountModel (HTTP)

/// 获取用户账户信息
+ (void)shanGetUserAccountInfoOfSuccess:(successCompletion)success
                                failure:(failureCompletion)failure {
    [SHANNetWorkRequest getWithPath:kSHAN_apiUserAccountInfo params:nil success:^(NSDictionary * _Nonnull argDict) {
        NSDictionary *dataDict = [argDict objectForKey:@"data"];
        
        if (kSHANDictIsEmpty(dataDict)) {
            success([[SHANUserAccountModel alloc] init]);
        } else {
            SHANUserAccountModel *model = [SHANUserAccountModel yy_modelWithDictionary:dataDict];
            success(model);
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

@end
