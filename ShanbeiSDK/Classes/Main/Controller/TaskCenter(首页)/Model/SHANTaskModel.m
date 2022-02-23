//
//  SHANTaskModel.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import "SHANTaskModel.h"
#import "SHANUserTaskModel.h"
#import "SHANAdvertisingPositionConfigModel.h"

@implementation SHANTaskModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"userTask":[SHANUserTaskModel class],
        @"advertisingPositionConfig":[SHANAdvertisingPositionConfigModel class]
    };
}

@end
