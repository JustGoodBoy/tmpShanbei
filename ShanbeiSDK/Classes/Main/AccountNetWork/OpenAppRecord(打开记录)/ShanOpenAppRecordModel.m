//
//  ShanOpenAppRecordModel.m
//  Pods
//
//  Created by GoodBoy on 2022/2/9.
//

#import "ShanOpenAppRecordModel.h"
#import "SHANCommonHTTPHeader.h"
@implementation ShanOpenAppRecordModel

@end

@implementation ShanOpenAppRecordModel (HTTP)

/// 获取用户打开app信息
+ (void)shan_openAppRecordOfSuccess:(void(^)(ShanOpenAppRecordModel *model))success
                            failure:(void(^)(NSString *errMsg))failure {
    [SHANNetWorkRequest getWithPath:kSHAN_apiOpenRecordInfo params:@{} success:^(NSDictionary * _Nonnull argDict) {
        NSDictionary *dataDict = [argDict objectForKey:@"data"];
        ShanOpenAppRecordModel *model = [ShanOpenAppRecordModel yy_modelWithDictionary:dataDict];
        success(model);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

@end
