//
//  SHANCashDrawalModel.m
//  Pods
//
//  Created by GoodBoy on 2021/9/23.
//

#import "SHANCashDrawalModel.h"

@implementation SHANCashDrawalModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"ID":@"id",
        @"Description":@"description"
    };
}

@end
