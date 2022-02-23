//
//  ShanWithdrawalModel.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/2/8.
//

#import "ShanWithdrawalModel.h"
#import "SHANCommonHTTPHeader.h"
#import "NSDictionary+SHAN.h"

@implementation ShanWithdrawalModel

@end

@implementation ShanWithdrawalModel (HTTP)

/// 用户提现次数
+ (void)shan_withdrawalTimesOfSuccess:(void(^)(NSInteger times))success
                              failure:(void(^)(NSString *errMsg))failure {
    [SHANNetWorkRequest getWithPath:kSHAN_apiUserWithdrawalTimes params:@{} success:^(NSDictionary * _Nonnull argDict) {
        NSString *times = [argDict shanObjectOrNilForKey:@"data"];
        
        success([times integerValue]);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

@end
