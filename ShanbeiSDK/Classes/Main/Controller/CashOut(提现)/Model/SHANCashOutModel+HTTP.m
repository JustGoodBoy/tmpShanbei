//
//  SHANCashOutModel+HTTP.m
//  Pods
//
//  Created by GoodBoy on 2021/9/23.
//

#import "SHANCashOutModel+HTTP.h"
#import "SHANNetWorkRequest.h"
#import "SHANURL.h"
#import "SHANHeader.h"
#import "YYModel.h"

@implementation SHANCashOutModel (HTTP)

/// 获取提现页面数据信息
+ (void)shanCashOutPageInfoOfSuccess:(successCompletion)success
                             failure:(failureCompletion)failure {
    [SHANNetWorkRequest getWithPath:kSHAN_apiDepositList params:nil success:^(NSDictionary * _Nonnull argDict) {
        NSDictionary *dataDict = [argDict objectForKey:@"data"];
        
        if (kSHANDictIsEmpty(dataDict)) {
            success([[SHANCashOutModel alloc] init]);
        } else {
            SHANCashOutModel *model = [SHANCashOutModel yy_modelWithDictionary:dataDict];
            success(model);
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

/// 提现
+ (void)shanCashOutWithParams:(id)params
                      success:(successCompletion)success
                      failure:(failureCompletion)failure {
    
    [SHANNetWorkRequest getWithPath:kSHAN_apiCashOut params:params success:^(NSDictionary * _Nonnull argDict) {
        NSDictionary *dataDict = [argDict objectForKey:@"data"];
        
        success(dataDict);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}
@end
