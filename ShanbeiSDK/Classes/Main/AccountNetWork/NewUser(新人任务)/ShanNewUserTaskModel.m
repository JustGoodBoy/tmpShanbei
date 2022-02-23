//
//  ShanNewUserTaskModel.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2022/1/21.
//

#import "ShanNewUserTaskModel.h"
#import "SHANCommonHTTPHeader.h"
@implementation ShanNewUserTaskModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"Description":@"description"
    };
}

@end

@implementation ShanNewUserTaskModel (HTTP)

/// 领现金任务内容
+ (void)shan_newuserRewardsSuccess:(void(^)(ShanNewUserTaskModel *model))success
                           failure:(void(^)(NSString *errMsg))failure {
    [SHANNetWorkRequest getWithPath:kSHAN_apiReceiveCash params:nil success:^(NSDictionary * _Nonnull argDict) {
        NSDictionary *dataDict = [argDict objectForKey:@"data"];
        ShanNewUserTaskModel *model = [ShanNewUserTaskModel yy_modelWithDictionary:dataDict];
        success(model);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

@end
