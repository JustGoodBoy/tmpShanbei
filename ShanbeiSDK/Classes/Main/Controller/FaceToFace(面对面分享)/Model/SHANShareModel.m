//
//  SHANShareModel.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/10/27.
//

#import "SHANShareModel.h"
#import "SHANAccountManager.h"
#import "NSDictionary+SHAN.h"
#import "SHANNetWorkRequest.h"
#import "SHANURL.h"
#import "SHANHeader.h"
#import "YYModel.h"
@implementation SHANShareModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"Description":@"description"
    };
}

@end


@implementation SHANShareModel(HTTP)

/// 获取分享信息
+ (void)shanGetShareInfoSuccess:(successCompletion)success
                        Failure:(failureCompletion)failure {    
    [SHANNetWorkRequest getWithPath:kSHAN_apiShareContent params:nil success:^(NSDictionary * _Nonnull argDict) {
        NSDictionary *dict = [argDict objectForKey:@"data"];
        SHANShareModel *model = [SHANShareModel yy_modelWithDictionary:dict];
        success(model);
    } failure:^(NSString * _Nonnull errorMessage) {
        failure(errorMessage);
    }];
}
@end
