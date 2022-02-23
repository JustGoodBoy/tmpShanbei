//
//  UIImage+SHAN.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SHAN)

+ (UIImage *)SHANImageNamed:(NSString *)name className:(Class)className;

/// 带圆角和颜色的图片
+ (UIImage *)shan_imageViewWithRadius:(CGFloat)radius color:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
