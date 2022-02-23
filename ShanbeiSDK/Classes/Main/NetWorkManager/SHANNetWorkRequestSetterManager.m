//
//  SHANNetWorkRequestSetterManager.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import "SHANNetWorkRequestSetterManager.h"

@implementation SHANNetWorkRequestSetterManager

+ (SHANNetWorkRequestSetterManager *)mark {
    static SHANNetWorkRequestSetterManager *markService = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        markService = [[SHANNetWorkRequestSetterManager alloc] init];
    });
    return markService;
}

@end
