//
//  UIColor+SHANHexString.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (SHANHexString)

/// 十六进制数转颜色
/// @param hexString 十六进制数
+ (nullable UIColor *)shan_colorWithHexString:(NSString *)hexString;

/// 十六进制数转颜色
/// @param hexString 十六进制数
/// @param alphaComponent 透明度 0~1
+ (nullable UIColor *)shan_colorWithHexString:(NSString *)hexString alphaComponent:(CGFloat)alphaComponent;

/// 当前颜色的十六进制值
- (nullable NSString *)shan_hexadecimalString;

/// 随机颜色
+ (nullable UIColor *)shan_randomColor;

@end

NS_ASSUME_NONNULL_END
