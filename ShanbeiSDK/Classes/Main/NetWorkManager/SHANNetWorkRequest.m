//
//  SHANNetWorkRequest.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import "SHANNetWorkRequest.h"
#import "SHANNetWorkRequestSetterManager.h"
#import "SHANNetWorkRequestSerivce.h"
#import "SHANNetWorkRequestCode.h"
@implementation SHANNetWorkRequest

/// 默认HOST-GET 请求
+ (void)getWithPath:(NSString *)path params:(id)params success:(successCompletionHandler)success failure:(failureCompletionHandler)failure {
    NSString *urlStr = [[SHANNetWorkRequestSetterManager mark].shanNetHost stringByAppendingString:path];
    [[SHANNetWorkRequestSerivce httpService] sendRequestWithHttpMethod:@"GET" URLPath:urlStr parameters:params completionHandler:^(id  _Nonnull data, NSError * _Nonnull error) {
        [self netRequestAchiverWith:data code:[SHANNetWorkRequestSetterManager mark].shanNetCode success:success failure:failure];
    }];
}

/// 默认HOST-POST请求
+ (void)postWithPath:(NSString *)path params:(id)params success:(successCompletionHandler)success failure:(failureCompletionHandler)failure {
    NSString *urlStr = [[SHANNetWorkRequestSetterManager mark].shanNetHost stringByAppendingString:path];
    [[SHANNetWorkRequestSerivce httpService] sendRequestWithHttpMethod:@"POST" URLPath:urlStr parameters:params completionHandler:^(id  _Nonnull data, NSError * _Nonnull error) {
        [self netRequestAchiverWith:data code:[SHANNetWorkRequestSetterManager mark].shanNetCode success:success failure:failure];
    }];
}

/// 自定义HOST-GET 请求
+ (void)getCustomHostWithPath:(NSString *)path params:(id)params customHost:(NSString *)host success:(successCompletionHandler)success failure:(failureCompletionHandler)failure {
    [self getCustomHostWithPath:path params:params customHost:host code:[SHANNetWorkRequestSetterManager mark].shanNetCode success:success failure:failure];
}

/// 自定义HOST-POST 请求
+ (void)postCustomHostWithPath:(NSString *)path params:(id)params customHost:(NSString *)host success:(successCompletionHandler)success failure:(failureCompletionHandler)failure {
    [self postCustomHostWithPath:path params:params customHost:host code:[SHANNetWorkRequestSetterManager mark].shanNetCode success:success failure:failure];
}

/// 自定义HOST-GET 请求,code发生改变
+ (void)getCustomHostWithPath:(NSString *)path params:(id)params customHost:(NSString *)host code:(NSInteger)code success:(successCompletionHandler)success failure:(failureCompletionHandler)failure {
    NSString *urlStr = [host stringByAppendingString:path];
    [[SHANNetWorkRequestSerivce httpService] sendRequestWithHttpMethod:@"GET" URLPath:urlStr parameters:params completionHandler:^(id  _Nonnull data, NSError * _Nonnull error) {
        [self netRequestAchiverWith:data code:code success:success failure:failure];
    }];
}

/// 自定义HOST-POST 请求,code发生改变
+ (void)postCustomHostWithPath:(NSString *)path params:(id)params customHost:(NSString *)host code:(NSInteger)code success:(successCompletionHandler)success failure:(failureCompletionHandler)failure {
    NSString *urlStr = [host stringByAppendingString:path];
    [[SHANNetWorkRequestSerivce httpService] sendRequestWithHttpMethod:@"POST" URLPath:urlStr parameters:params completionHandler:^(id  _Nonnull data, NSError * _Nonnull error) {
        [self netRequestAchiverWith:data code:code success:success failure:failure];
    }];
}

+ (void)netRequestAchiverWith:(id)data code:(NSInteger)code success:(successCompletionHandler)success failure:(failureCompletionHandler)failure {

    SHANNetWorkRequestCode *netdata = [[SHANNetWorkRequestCode alloc] initWithData:data code:code];
    if (netdata.success) {
        if (success) success(netdata.retDataDict);
    }else{
        if (failure) failure(netdata.errMessage);
    }
}

@end
