//
//  ShanEatModel.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/22.
//

#import "ShanEatModel.h"
#import "SHANCommonHTTPHeader.h"
@implementation ShanEatModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"mealSubsideBos":[ShanMealSubsideBosModel class],
    };
}
@end

@implementation ShanEatModel (HTTP)
/// 吃饭补贴列表
+ (void)shan_requestSubsideInfoWithSuccess:(void(^)(ShanEatModel *model))success
                                   failure:(void(^)(NSString *errMsg))failure {
    NSDictionary *params = nil;
    [SHANNetWorkRequest getWithPath:kSHAN_apiMealSubsideList params:params success:^(NSDictionary * _Nonnull argDict) {
        
        NSDictionary *dataDict = [argDict objectForKey:@"data"];
        ShanEatModel *model = [ShanEatModel yy_modelWithJSON:dataDict];
        NSLog(@"%@",model);
        success(model);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

/// 补贴下发
+ (void)shan_requestSubsideRewardWithId:(NSString *)mealSubsideId
                                success:(void(^)(NSDictionary *dict))success
                                failure:(void(^)(NSString *errMsg))failure {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:mealSubsideId forKey:@"mealSubsideId"];
    [SHANNetWorkRequest getWithPath:kSHAN_apiMealSubsideReward params:params success:^(NSDictionary * _Nonnull argDict) {
        
        NSDictionary *dataDict = [argDict objectForKey:@"data"];
        
        success(dataDict);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

/// 吃饭补贴追加奖励
+ (void)shan_reportMealSubsideAttachWithSuccess:(void(^)(NSString *reward))success
                                        failure:(void(^)(NSString *errMsg))failure {
    NSDictionary *params = nil;
    [SHANNetWorkRequest getWithPath:kSHAN_apiMealSubsideBonus params:params success:^(NSDictionary * _Nonnull argDict) {
        
        NSString *reward = [NSString stringWithFormat:@"%@",[argDict objectForKey:@"data"]];
        success(reward);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

@end

@implementation ShanMealSubsideBosModel

@end
