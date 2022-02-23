//
//  SHANInviteModel.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/10/26.
//

#import "SHANInviteModel.h"

@implementation SHANInviteItem

@end

@implementation SHANInviteModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"inviteTaskPos":[SHANInviteItem class]
    };
}

@end


