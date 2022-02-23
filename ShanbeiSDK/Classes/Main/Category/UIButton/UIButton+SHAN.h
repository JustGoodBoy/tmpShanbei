//
//  UIButton+SHAN.h
//  Pods
//
//  Created by GoodBoy on 2021/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (SHAN)

/// 垂直图文排版，+上图下文, -下图上文
- (void)shan_verticalImageAndTitle:(CGFloat)len;

/// 水平图文排版，+左图右文(无需预设图文), -左文右图(需预设图文)
- (void)shan_horizontalImageAndTitle:(CGFloat)len;

@end

NS_ASSUME_NONNULL_END
