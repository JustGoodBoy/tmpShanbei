//
//  UIImage+ShanAddition.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ShanAddition)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
