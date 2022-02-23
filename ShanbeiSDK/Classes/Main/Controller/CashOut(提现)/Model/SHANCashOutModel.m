//
//  SHANCashOutModel.m
//  Pods
//
//  Created by GoodBoy on 2021/9/23.
//

#import "SHANCashOutModel.h"
#import "SHANWXUserInfoModel.h"
#import "SHANCashDrawalModel.h"
@implementation SHANCashOutModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"weChatInfo":[SHANWXUserInfoModel class],
        @"cashWithdrawalAmountList":[SHANCashDrawalModel class]
    };
}

@end
