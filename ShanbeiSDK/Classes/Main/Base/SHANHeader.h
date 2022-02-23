//
//  SHANHeader.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#ifndef SHANHeader_h
#define SHANHeader_h

#import "SHANStatusBarTool.h"

#define kSHANScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kSHANScreenHeight       [UIScreen mainScreen].bounds.size.height

// 机型UI适配宏
#define kSHANScreenScale    [UIScreen mainScreen].scale

#define kSHANScreenW_Radius    (kSHANScreenWidth / 375.0)
#define kSHANCurveScreen (kshanGetStatusBarHeight > 20) // 刘海屏幕
#define kSHANStatusBarHeight (kshanGetStatusBarHeight)
#define kSHANTabBarHeight (kSHANCurveScreen ? 83 : 49)

// 是否空对象
#define kSHANStringIsEmpty(str)     ([str isKindOfClass:[NSNull class]] || str == nil || ![str isKindOfClass:[NSString class]] || [str length] < 1 ? YES : NO)
#define kSHANArrayIsEmpty(array)    (array == nil || [array isKindOfClass:[NSNull class]] || ![array isKindOfClass:[NSArray class]] || array.count == 0)
#define kSHANDictIsEmpty(dict)      (dict == nil || [dict isKindOfClass:[NSNull class]] || ![dict isKindOfClass:[NSDictionary class]] || dict.allKeys.count == 0)
#define kSHANObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))


#ifdef DEBUG
    #define NSLog(FORMAT, ...) fprintf(stderr, "[%s][%d行] %s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
    #define NSLog(FORMAT, ...) nil
#endif

#define shanMainTextColor @"#A0715A"

#endif /* SHANHeader_h */
