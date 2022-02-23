//
//  SHANSignInModel+HTTP.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/10/25.
//

#import "SHANSignInModel+HTTP.h"
#import "SHANAccountManager.h"
#import "NSDictionary+SHAN.h"
#import "SHANNetWorkRequest.h"
#import "SHANURL.h"
#import "SHANHeader.h"
#import "YYModel.h"
@implementation SHANSignInModel (HTTP)

/// 获取签到列表
+ (void)shanGetSignInListWithSuccess:(successCompletion)success
                             Failure:(failureCompletion)failure {

    [SHANNetWorkRequest getWithPath:kSHAN_apiSigningTaskList params:nil success:^(NSDictionary * _Nonnull argDict) {
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        NSDictionary *dict = [argDict objectForKey:@"data"];
        NSArray *dataArray = [dict objectForKey:@"signInTaskBos"];
        if (!kSHANArrayIsEmpty(dataArray)) {
            for (NSDictionary *dict in dataArray) {
                SHANSignInModel *model = [SHANSignInModel yy_modelWithDictionary:dict];
                [mutableArray addObject:model];
            }
        }
        NSMutableDictionary *mutableDict = [NSMutableDictionary new];
        [mutableDict shanSetObjectSafely:[dict shanObjectOrNilForKey:@"isSignToday"] aKey:@"isSignToday"];
        [mutableDict shanSetObjectSafely:[mutableArray copy] aKey:@"signInTaskBos"];
        success([mutableDict mutableCopy]);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

/// 签到
+ (void)shanGetSignInSuccess:(successCompletion)success
                     Failure:(failureCompletion)failure {
    
    [SHANNetWorkRequest getWithPath:kSHAN_apiSigningTask params:nil success:^(NSDictionary * _Nonnull argDict) {
        NSDictionary *dataDict = [argDict objectForKey:@"data"];
        if (kSHANDictIsEmpty(dataDict)) {
            success([[SHANSignInModel alloc] init]);
        } else {
            SHANSignInModel *model = [SHANSignInModel yy_modelWithDictionary:[argDict objectForKey:@"data"]];
            success(model);
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}
@end
