//
//  ShanSignedModel.m
//  ShanbeiSDK-ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/21.
//

#import "ShanSignedModel.h"
#import "SHANCommonHTTPHeader.h"

@implementation ShanSignedModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"signInTaskBos":[ShanSignInTaskBosModel class],
    };
}
@end

#pragma mark -  ShanSignedModel - HTTP
@implementation ShanSignedModel (HTTP)

/// 获取签到列表
+ (void)shan_requestSignInListWithSuccess:(void(^)(ShanSignedModel *model))success
                                  failure:(failureBlock)failure {
    NSDictionary *params = nil;
    [SHANNetWorkRequest getWithPath:kSHAN_apiSigningTaskList2 params:params success:^(NSDictionary * _Nonnull argDict) {
        
        NSDictionary *dataDict = [argDict objectForKey:@"data"];
        ShanSignedModel *model = [ShanSignedModel yy_modelWithJSON:dataDict];
        NSLog(@"%@",model);
        success(model);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

/// 签到
+ (void)shan_requestSignInWithId:(NSString *)signInTaskId
                         success:(void(^)(ShanSignInTaskBosModel *model))success
                         failure:(failureBlock)failure {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:signInTaskId forKey:@"signInTaskId"];
    [SHANNetWorkRequest getWithPath:kSHAN_apiSigningTask2 params:params success:^(NSDictionary * _Nonnull argDict) {
        NSDictionary *dataDict = [argDict objectForKey:@"data"];
        if (kSHANDictIsEmpty(dataDict)) {
            success([ShanSignInTaskBosModel new]);
        } else {
            ShanSignInTaskBosModel *model = [ShanSignInTaskBosModel yy_modelWithDictionary:dataDict];
            success(model);
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

/// 签到追加上报
+ (void)shan_reportSignInAttachSuccess:(void(^)(NSDictionary *dict))success
                               failure:(failureBlock)failure {
    NSDictionary *params = nil;
    [SHANNetWorkRequest getWithPath:kSHAN_apiSigningTaskBonus params:params success:^(NSDictionary * _Nonnull argDict) {
        success(argDict);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

@end

#pragma mark - signInTaskBos 签到列表Model
@implementation ShanSignInTaskBosModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"Description":@"description"
    };
}
@end
