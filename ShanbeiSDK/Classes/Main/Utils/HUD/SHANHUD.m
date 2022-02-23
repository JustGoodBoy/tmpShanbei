//
//  SHANHUD.m
//  Pods
//
//  Created by GoodBoy on 2021/9/26.
//

#import "SHANHUD.h"
#import "UIFont+SHAN.h"

#define kSHANHUDScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kSHANHUDScreenHeight  [UIScreen mainScreen].bounds.size.height

@implementation SHANHUD

/// 提示框
+ (void)showInfoWithTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor blackColor];
    titleLabel.layer.cornerRadius = 8;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    NSDictionary *attrs = @{
        NSFontAttributeName:[UIFont shan_PingFangMediumFont:15]
    };
    CGSize size = [title sizeWithAttributes:attrs];
    CGFloat contentWidth = (size.width + 40);
    [titleLabel setFrame:CGRectMake((kSHANHUDScreenWidth - contentWidth)/2, (kSHANHUDScreenHeight - 50)/2, contentWidth, 50)];
    [[UIApplication sharedApplication].keyWindow addSubview:titleLabel];
    
    // 移除
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [titleLabel removeFromSuperview];
    });
}


@end
