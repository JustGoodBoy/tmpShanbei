//
//  NSMutableAttributedString+SHAN.m
//  Pods
//
//  Created by GoodBoy on 2021/9/22.
//

#import "NSMutableAttributedString+SHAN.h"

@implementation NSMutableAttributedString (SHAN)

/// 计算富文本字体高度
/// @param attStr 富文本
/// @param width 字体所占宽度
- (CGFloat)shan_getHeightWithAttStr:(NSMutableAttributedString *)attStr
                           withWidth:(CGFloat)width {
    CGSize attSize = [attStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return attSize.height;
}

@end
