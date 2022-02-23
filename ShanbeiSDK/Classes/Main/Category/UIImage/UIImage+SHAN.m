//
//  UIImage+SHAN.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

#import "UIImage+SHAN.h"
#import "UIImage+ShanAddition.h"
@implementation UIImage (SHAN)

+ (UIImage *)SHANImageNamed:(NSString *)name className:(Class)className {
    NSString *bundleNameWithExtension = @"ShanbeiSDK.bundle";
    NSString *bundlePath = [[NSBundle bundleForClass:className].resourcePath stringByAppendingPathComponent:bundleNameWithExtension];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *img = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return img;
}

/// 带圆角和颜色的图片
+ (UIImage *)shan_imageViewWithRadius:(CGFloat)radius color:(UIColor *)color {
    
    UIImage *colorImage = [UIImage imageWithColor:color size:CGSizeMake(radius * 2 + 1, radius * 2 + 1)];
    colorImage = [colorImage imageByRoundCornerRadius:radius];
    colorImage = [colorImage stretchableImageWithLeftCapWidth:radius topCapHeight:radius];
    return colorImage;
}


@end
