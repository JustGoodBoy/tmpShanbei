//
//  SHANCommentManager.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import "SHANCommentManager.h"

static SHANCommentManager *_commentMark = nil;

@implementation SHANCommentManager

+ (instancetype)sharedCommentMark {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _commentMark = [[super allocWithZone:NULL] init];
    });
    
    return _commentMark;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [SHANCommentManager sharedCommentMark];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [SHANCommentManager sharedCommentMark];
}

@end
