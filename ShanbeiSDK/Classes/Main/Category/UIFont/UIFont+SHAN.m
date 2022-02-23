//
//  UIFont+SHAN.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import "UIFont+SHAN.h"

@implementation UIFont (SHAN)

+ (UIFont *)shan_PingFangRegularFont:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}

+ (UIFont *)shan_PingFangMediumFont:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
}

+ (UIFont *)shan_PingFangLightFont:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Light" size:size];
}

+ (UIFont *)shan_PingFangSemiboldFont:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
}

@end
