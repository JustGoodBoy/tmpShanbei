//
//  ShanReportTaskManager.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/11/19.
//

#import "ShanReportTaskManager.h"
#import "SHANNetWorkRequest.h"
#import "SHANURL.h"
#import "NSDictionary+SHAN.h"
#import "SHANAccountManager.h"
#import "SHANHeader.h"
#import "NSString+SHAN.h"
#import "NSString+SHAN_AES.h"
#import "NSString+SHAN_RSA.h"
#import "NSString+SHAN_encryption.h"
@implementation ShanReportTaskManager
/*
    上报逻辑
 获取token:
    1、上报之前获取加密的token
    2、key：使用公钥（RSA）解密key的值
       data：拿到key的值后使用AES解密data，拿到token
 上报:
    3、上报接口添加参数:@"encryptToken": RSA 加密token,公钥为客户端写死的公钥
    4、获取随机16位公钥 randomKey(每次都不一样)
    5、将参数转为json
    6、新参数:
            key : RSA 加密randomKey,公钥为客户端写死的公钥
            data: AES加密json,公钥为上面的randomKey
 */

/*
 常规任务上报
 睡觉领取积分上报
 现金红包任务上报
 */

/// 上报接口
+ (void)shanReportTaskWithType:(SHANTaskListType)type
                        taskId:(NSString *)taskId
                       success:(void(^)(NSDictionary *dic))success
                       failure:(void(^)(NSString *errorMessage))failure {
    if (type == SHANTaskListTypeOfBox) {
        [self reportTaskRecordOfGet:type taskId:taskId success:^(NSDictionary *dic) {
            success(dic);
        } failure:^(NSString *errorMessage) {
            failure(errorMessage);
        }];
    } else {
        // 获取token
        [self shan_getEncryptTokenOfSuccess:^(NSString * _Nonnull token) {
            
            // 获取token之后,接口上报
            [self reportTaskRecordOfPost:type token:token taskId:taskId success:^(NSDictionary *dic) {
                success(dic);
            } failure:^(NSString *errorMessage) {
                failure(errorMessage);
            }];
            
        } failure:^(NSString * _Nonnull errorMessage) {
            failure(errorMessage);
        }];
    }
}

#pragma mark - Private
/// 获取token之后,接口上报(POST)
+ (void)reportTaskRecordOfPost:(SHANTaskListType)type
                         token:(NSString *)token
                        taskId:(NSString *)taskId
                       success:(void(^)(NSDictionary *dic))success
                       failure:(void(^)(NSString *errorMessage))failure {
    NSString *path = @"pub/save/user/task/record/v2";
    NSString *accountId = [SHANAccountManager sharedManager].shanAccountId;
    NSString *encryptToken = [NSString shan_RSA_encryptString:token publicKey:RSA_PublicKey];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict shanSetObjectSafely:accountId aKey:@"accountId"];
    [dict shanSetObjectSafely:encryptToken aKey:@"encryptToken"];
    
    if (type == SHANTaskListTypeOfCash || type == SHANTaskListTypeOfHideCashOut) {
        
        [dict shanSetObjectSafely:taskId aKey:@"userTaskId"];
        path = @"pub/receive/rewards/report/v2";
        
    } else {
        [dict shanSetObjectSafely:taskId aKey:@"userTaskId"];
    }
    
    // 获取随机16位公钥, RSA 加密
    NSString *randomKey = [NSString shan_getRandomString:16];
    NSString *key = [NSString shan_RSA_encryptString:randomKey publicKey:RSA_PublicKey];
    
    // AES加密json
    NSString *jsonStr = [NSString shan_getJsonString:dict];
    NSString *dataStr = [NSString shan_AES_encryptText:jsonStr key:randomKey];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params shanSetObjectSafely:key aKey:@"key"];
    [params shanSetObjectSafely:dataStr aKey:@"data"];
    
    [SHANNetWorkRequest postWithPath:path params:params success:^(NSDictionary * _Nonnull argDict) {
        success(argDict);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

/// 获取token之后,接口上报(GET)
+ (void)reportTaskRecordOfGet:(SHANTaskListType)type
                       taskId:(NSString *)taskId
                      success:(void(^)(NSDictionary *dic))success
                      failure:(void(^)(NSString *errorMessage))failure {
    NSString *path = @"pub/treasure/chest/task";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (type == SHANTaskListTypeOfBox) {
        [params shanSetObjectSafely:taskId aKey:@"taskId"];
        path = @"pub/treasure/chest/task";
    }
    [SHANNetWorkRequest getWithPath:path params:params success:^(NSDictionary * _Nonnull argDict) {
        success(argDict);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

/// 获取token
+ (void)shan_getEncryptTokenOfSuccess:(void(^)(NSString *token))success
                              failure:(void(^)(NSString *errorMessage))failure {
    [SHANNetWorkRequest getWithPath:kSHAN_apiEncryptToken params:nil success:^(NSDictionary * _Nonnull argDict) {
        NSDictionary *dict = [argDict objectForKey:@"data"];
        NSString *tokenString = @"";
        if (!kSHANDictIsEmpty(dict)) {
            NSString *encryptKey = [dict shanObjectOrNilForKey:@"key"];
            NSString *encryptData = [dict shanObjectOrNilForKey:@"data"];
            /*
             key：使用公钥（RSA）解密key的值
             data：拿到key的值后使用AES解密data，拿到token
             */
            NSString *key = [NSString shan_RSA_decryptString:encryptKey publicKey:RSA_PublicKey];
            
            tokenString = [NSString shan_AES_decryptText:encryptData key:key];
        }
        success(tokenString);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}

@end
