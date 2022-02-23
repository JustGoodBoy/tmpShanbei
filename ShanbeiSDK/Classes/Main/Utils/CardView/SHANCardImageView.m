//
//  SHANCardImageView.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/10/26.
//

#import "SHANCardImageView.h"
#import "UIImage+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
#import "UIView+SHAN.h"
#import "SHANHeader.h"

@interface SHANCardImageView()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation SHANCardImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImage *image = [UIImage SHANImageNamed:@"taskCenter_task_bg" className:[self class]];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(70, 40, 20, 40);
    self.userInteractionEnabled = YES;
    self.image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, self.width, 22)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor shan_colorWithHexString:@"A0715A"];
    _titleLabel.font = [UIFont shan_PingFangMediumFont:16];
    [self addSubview:_titleLabel];
}

- (void)setCardTitle:(NSString *)cardTitle {
    _titleLabel.text = cardTitle;
}

@end
