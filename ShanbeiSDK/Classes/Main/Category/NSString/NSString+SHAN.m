//
//  NSString+SHAN.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/17.
//

#import "NSString+SHAN.h"
@implementation NSString (SHAN)

/// 计算富文本字体高度
/// @param content 内容
/// @param font 字体
/// @param width 字体所占宽度
- (CGFloat)shan_getHeightwithContent:(NSString *)content
                            withFont:(UIFont *)font
                           withWidth:(CGFloat)width {
    
    NSMutableAttributedString *tmpAttStr = [[NSMutableAttributedString alloc] initWithString:content];
    NSRange range = NSMakeRange(0, content.length);
    [tmpAttStr addAttribute:NSFontAttributeName value:font range:range];
    CGSize attSize = [tmpAttStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return attSize.height;
}

/// Returns the size of the string if it were rendered with the specified constraints.
/// @param font The font to use for computing the string size.
/// @param size The maximum acceptable size for the string. This value is used to calculate where line breaks and wrapping would occur.
/// @param lineBreakMode The line break options for computing the size of the string. For a list of possible values, see NSLineBreakMode.
- (CGSize)shan_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    if (!self.length) return CGSizeZero;
    
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr
                                         context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (NSString *)removeSurplusZero:(NSString *)content {
    NSString *lastTwoStr = [content substringFromIndex:content.length - 2];
    if ([lastTwoStr isEqualToString:@"00"]) {
        return [content substringToIndex:content.length - 3];
    }
    NSString *lastStr = [content substringFromIndex:content.length - 1];
    if ([lastStr isEqualToString:@"0"]) {
        return [content substringToIndex:content.length - 1];
    }
    return content;
}

- (NSMutableAttributedString *)getAttributedString:(UIColor *)normalColor highLightColor:(UIColor *)highLightColor font:(UIFont *)font {
    NSString *content = self;
    if ([content containsString:@"<"]) {
        NSArray  *contentArray = [content componentsSeparatedByString:@"<"];
        NSArray  *contentSubArray = [contentArray[1] componentsSeparatedByString:@">"];
        // 标红字体
        NSString *highlightString = contentSubArray[0];
        // 标红之前的字体
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:contentArray[0] attributes:@{
            NSForegroundColorAttributeName:normalColor,
            NSFontAttributeName:font
        }];
        NSAttributedString *highlight= [[NSAttributedString alloc] initWithString:highlightString attributes:@{
            NSForegroundColorAttributeName:highLightColor,
            NSFontAttributeName:font
        }];
        [attString appendAttributedString:highlight];
        
        // 标红之后的字体
        NSAttributedString *after = [[NSAttributedString alloc] initWithString:contentSubArray[1] attributes:@{
            NSForegroundColorAttributeName:normalColor,
            NSFontAttributeName:font
        }];
        [attString appendAttributedString:after];
        
        return attString;
    } else {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:content attributes:@{
            NSForegroundColorAttributeName:normalColor,
            NSFontAttributeName:font
        }];
        return attString;
    }
}

/// 字典转json字符串
+ (NSString *)shan_getJsonString:(NSDictionary *)dic {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
        return jsonString;
    }else{
        return nil;
    }
}
@end
