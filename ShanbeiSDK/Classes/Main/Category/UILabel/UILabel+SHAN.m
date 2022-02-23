//
//  UILabel+SHAN.m
//  Pods
//
//  Created by GoodBoy on 2021/9/22.
//

#import "UILabel+SHAN.h"
#import "NSString+SHAN.h"
#import "UIView+SHAN.h"
@implementation UILabel (SHAN)

- (CGSize)textSizeWithSize:(CGSize)size {
    NSLineBreakMode lineBreakMode = self.lineBreakMode;
    if (lineBreakMode == NSLineBreakByTruncatingTail) lineBreakMode = NSLineBreakByWordWrapping;
    return [self.text shan_sizeForFont:self.font size:size mode:lineBreakMode];
}

- (CGFloat)textHeightWithWidth:(CGFloat)w {
    return [self textSizeWithSize:CGSizeMake(w, CGFLOAT_MAX)].height;
}

- (CGFloat)textWidth {
    return [self textSizeWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
}

- (CGFloat)textHeight {
    return [self textSizeWithSize:CGSizeMake(self.width, CGFLOAT_MAX)].height;
}

- (void)setMiniFontSize:(CGFloat)size {
    self.minimumScaleFactor = size / self.font.pointSize;
}

- (CGFloat)miniFontSize {
    return self.minimumScaleFactor * self.font.pointSize;
}

- (instancetype)initWith:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color {
    self = [super init];
    if (self) {
        self.text = title;
        self.font = font;
        self.textColor = color;
    }
    return self;
}

@end
