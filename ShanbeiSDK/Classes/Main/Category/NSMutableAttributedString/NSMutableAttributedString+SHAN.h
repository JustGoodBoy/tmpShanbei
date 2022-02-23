//
//  NSMutableAttributedString+SHAN.h
//  Pods
//
//  Created by GoodBoy on 2021/9/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (SHAN)

/// 计算富文本字体高度
/// @param attStr 富文本
/// @param width 字体所占宽度
- (CGFloat)shan_getHeightWithAttStr:(NSMutableAttributedString *)attStr
                          withWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
