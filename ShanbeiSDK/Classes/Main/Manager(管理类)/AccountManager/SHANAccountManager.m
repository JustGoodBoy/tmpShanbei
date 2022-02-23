//
//  SHANAccountManager.m
//  Pods
//
//  Created by GoodBoy on 2021/9/18.
//

#import "SHANAccountManager.h"

static SHANAccountManager *_manager = nil;

@implementation SHANAccountManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[super allocWithZone:NULL] init];
    });
    return _manager;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [SHANAccountManager sharedManager];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [SHANAccountManager sharedManager];
}

@end
