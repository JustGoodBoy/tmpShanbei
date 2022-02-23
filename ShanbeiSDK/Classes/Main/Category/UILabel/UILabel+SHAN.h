//
//  UILabel+SHAN.h
//  Pods
//
//  Created by GoodBoy on 2021/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (SHAN)

- (CGSize)textSizeWithSize:(CGSize)size;
- (CGFloat)textHeightWithWidth:(CGFloat)w;
- (CGFloat)textWidth;
- (CGFloat)textHeight;

@property(nonatomic) CGFloat miniFontSize;

- (instancetype)initWith:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
