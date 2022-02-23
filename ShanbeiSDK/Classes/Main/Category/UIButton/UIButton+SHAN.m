//
//  UIButton+SHAN.m
//  Pods
//
//  Created by GoodBoy on 2021/9/22.
//

#import "UIButton+SHAN.h"
#import "UIView+SHAN.h"
#import "UILabel+SHAN.h"
@implementation UIButton (SHAN)

/// 垂直图文排版，+上图下文, -下图上文
- (void)shan_verticalImageAndTitle:(CGFloat)len {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize imgSiz = self.imageView.size;
        CGSize titleSize = self.titleLabel.frame.size;
        CGSize textSize = CGSizeMake(self.titleLabel.textWidth, 0);
        CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
        if (titleSize.width + 0.5 < frameSize.width) {
            titleSize.width = frameSize.width;
        }
        if (len > 0) {
            self.imageEdgeInsets = UIEdgeInsetsMake(-len - titleSize.height, 0, 0, -titleSize.width);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imgSiz.width, -len - imgSiz.height, 0);
        } else {
            self.imageEdgeInsets = UIEdgeInsetsMake(imgSiz.height - len, 0, 0, -titleSize.width);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imgSiz.width, titleSize.height - len, 0);
        }
    });
}

/// 水平图文排版，+左图右文(无需预设图文), -左文右图(需预设图文)
- (void)shan_horizontalImageAndTitle:(CGFloat)len {
    if (len > 0) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -len/2, 0, len/2);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, len/2, 0, -len/2);
    } else {
        len = -len;
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat txtLen = self.imageView.width + len/2;
            CGFloat imgLen = MIN(self.titleLabel.width, self.titleLabel.textWidth) + len/2;
            
            self.imageEdgeInsets = UIEdgeInsetsMake(0, imgLen, 0, -imgLen);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -txtLen, 0, txtLen);
        });
    }
}

@end
