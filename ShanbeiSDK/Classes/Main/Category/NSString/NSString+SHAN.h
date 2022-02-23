//
//  NSString+SHAN.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SHAN)

/// 计算富文本字体高度
/// @param content 内容
/// @param font 字体
/// @param width 字体所占宽度
- (CGFloat)shan_getHeightwithContent:(NSString *)content
                            withFont:(UIFont *)font
                           withWidth:(CGFloat)width;

/// 计算富文本字体高度
/// @param attStr 富文本
/// @param width 字体所占宽度
- (CGFloat)shan_getHeightWithAttStr:(NSMutableAttributedString *)attStr
                          withWidth:(CGFloat)width;

/// Returns the size of the string if it were rendered with the specified constraints.
/// @param font The font to use for computing the string size.
/// @param size The maximum acceptable size for the string. This value is used to calculate where line breaks and wrapping would occur.
/// @param lineBreakMode The line break options for computing the size of the string. For a list of possible values, see NSLineBreakMode.
- (CGSize)shan_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

/// 去除多余的0，0.30 ---> 0.3
- (NSString *)removeSurplusZero:(NSString *)content;


/// 富文本
/// @param normalColor 正常颜色
/// @param highLightColor 高亮颜色
/// @param font 字体
- (NSMutableAttributedString *)getAttributedString:(UIColor *)normalColor highLightColor:(UIColor *)highLightColor font:(UIFont *)font;


/// 字典转json字符串
+ (NSString *)shan_getJsonString:(NSDictionary *)dic;


@end

NS_ASSUME_NONNULL_END
