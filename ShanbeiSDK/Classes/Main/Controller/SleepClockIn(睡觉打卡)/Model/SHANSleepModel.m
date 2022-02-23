//
//  SHANSleepModel.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/11/24.
//

#import "SHANSleepModel.h"
#import "SHANNetWorkRequest.h"
#import "SHANURL.h"
#import "SHANHeader.h"
#import "YYModel.h"
#import "NSDictionary+SHAN.h"
#import "SHANAccountManager.h"
#import "ShanReportTaskManager.h"
#import "NSString+SHAN.h"
#import "NSString+SHAN_AES.h"
#import "NSString+SHAN_RSA.h"
#import "NSString+SHAN_encryption.h"
@implementation SHANSleepModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"Description":@"description"
    };
}

@end

@implementation SHANSleepModel (HTTP)

/// 睡觉打卡任务信息
+ (void)shanGetSleepInfoWithTaskId:(NSString *)taskId
                           success:(void(^)(SHANSleepModel *model))success
                           failure:(void(^)(NSString *errorMessage))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params shanSetObjectSafely:taskId aKey:@"taskId"];
    [SHANNetWorkRequest getWithPath:@"pub/sleep/gain/coin/task" params:params success:^(NSDictionary * _Nonnull argDict) {
        NSDictionary *dataDict = [argDict objectForKey:@"data"];
        
        if (kSHANDictIsEmpty(dataDict)) {
            success([[SHANSleepModel alloc] init]);
        } else {
            SHANSleepModel *model = [SHANSleepModel yy_modelWithDictionary:dataDict];
            success(model);
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

/// 睡觉打卡任务计时
+ (void)shanGetSleepStartWithTaskId:(NSString *)taskId
                            success:(void(^)(NSDictionary *dic))success
                            failure:(void(^)(NSString *errorMessage))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params shanSetObjectSafely:taskId aKey:@"taskId"];
    [SHANNetWorkRequest getWithPath:@"pub/sleep/gain/coin/task/time" params:params success:^(NSDictionary * _Nonnull argDict) {
        success(argDict);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

/// 睡觉打卡任务上报
+ (void)shanReportSleepTaskWithTaskId:(NSString *)taskId
                              success:(void(^)(NSDictionary *dic))success
                              failure:(void(^)(NSString *errorMessage))failure {
    NSString *accountId = [SHANAccountManager sharedManager].shanAccountId;
    NSString *encryptToken = [NSString shan_RSA_encryptString:@"" publicKey:RSA_PublicKey];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict shanSetObjectSafely:accountId aKey:@"accountId"];
    [dict shanSetObjectSafely:taskId aKey:@"userTaskId"];
    [dict shanSetObjectSafely:encryptToken aKey:@"encryptToken"];
    
    // 获取随机16位公钥, RSA 加密
    NSString *randomKey = [NSString shan_getRandomString:16];
    NSString *key = [NSString shan_RSA_encryptString:randomKey publicKey:RSA_PublicKey];
    
    // AES加密json
    NSString *jsonStr = [NSString shan_getJsonString:dict];
    NSString *dataStr = [NSString shan_AES_encryptText:jsonStr key:randomKey];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params shanSetObjectSafely:key aKey:@"key"];
    [params shanSetObjectSafely:dataStr aKey:@"data"];
    [SHANNetWorkRequest postWithPath:@"pub/sleep/gain/coin/task/report/v2" params:params success:^(NSDictionary * _Nonnull argDict) {
        NSDictionary *dataDict = [argDict objectForKey:@"data"];
        success(dataDict);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

/// 睡觉打卡-领取奖励-追加任务上报
+ (void)shanReportHideSleepTaskWithTaskId:(NSString *)taskId
                             taskRecordId:(NSString *)taskRecordId
                                  success:(void(^)(NSDictionary *dic))success
                                  failure:(void(^)(NSString *errorMessage))failure {
    
    
    
    [ShanReportTaskManager shan_getEncryptTokenOfSuccess:^(NSString * _Nonnull token) {
        NSString *accountId = [SHANAccountManager sharedManager].shanAccountId;
        NSString *encryptToken = [NSString shan_RSA_encryptString:token publicKey:RSA_PublicKey];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict shanSetObjectSafely:accountId aKey:@"accountId"];
        [dict shanSetObjectSafely:taskId aKey:@"userTaskId"];
        [dict shanSetObjectSafely:taskRecordId aKey:@"taskRecordId"];
        [dict shanSetObjectSafely:encryptToken aKey:@"encryptToken"];
        
        
        // 获取随机16位公钥, RSA 加密
        NSString *randomKey = [NSString shan_getRandomString:16];
        NSString *key = [NSString shan_RSA_encryptString:randomKey publicKey:RSA_PublicKey];
        
        // AES加密json
        NSString *jsonStr = [NSString shan_getJsonString:dict];
        NSString *dataStr = [NSString shan_AES_encryptText:jsonStr key:randomKey];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params shanSetObjectSafely:key aKey:@"key"];
        [params shanSetObjectSafely:dataStr aKey:@"data"];
        [SHANNetWorkRequest postWithPath:@"pub/save/user/task/record/v2" params:params success:^(NSDictionary * _Nonnull argDict) {
            success(argDict);
        } failure:^(NSString * _Nonnull errorMessage) {
            failure(errorMessage);
        }];
        
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
    
    
}

@end
