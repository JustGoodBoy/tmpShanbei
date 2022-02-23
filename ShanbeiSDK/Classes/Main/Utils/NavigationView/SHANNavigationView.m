//
//  SHANNavigationView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import "SHANNavigationView.h"
#import "SHANHeader.h"
#import "UIImage+SHAN.h"
#import "UIFont+SHAN.h"
#import "UIColor+SHANHexString.h"

@interface SHANNavigationView ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView  *rightView;
@property (nonatomic, strong) UILabel *explainLabel;

@end

@implementation SHANNavigationView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.backButton = [[UIButton alloc] init];
        self.backButton.frame = CGRectMake(16, kSHANStatusBarHeight + 7, 25, 25);
        [self.backButton setImage:[UIImage SHANImageNamed:@"nav_icon_white_back" className:[self class]] forState:UIControlStateNormal];
        self.backButton.adjustsImageWhenHighlighted = NO;
        [self.backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backButton];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.backButton.frame) + 16, kSHANStatusBarHeight, kSHANScreenWidth - 57 - 57, 40)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.opaque = YES;
        self.titleLabel.font = [UIFont shan_PingFangMediumFont:18];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        
        self.rightView = [[UIView alloc] initWithFrame:CGRectMake(kSHANScreenWidth - 57, kSHANStatusBarHeight, 57 - 16, 40)];
        self.rightView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.rightView];
        self.rightView.hidden = YES;
        
        self.explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.rightView.frame), 40)];
        self.explainLabel.backgroundColor = [UIColor clearColor];
        self.explainLabel.font = [UIFont shan_PingFangRegularFont:14];
        self.explainLabel.textAlignment = NSTextAlignmentRight;
        self.explainLabel.text = @"说明";
        self.explainLabel.textColor = [UIColor whiteColor];
        [self.rightView addSubview:self.explainLabel];
        
        self.explainLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *explainTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toExplainAction)];
        [explainTag setNumberOfTapsRequired:1];
        [self.explainLabel addGestureRecognizer:explainTag];
    }
    return self;
}

- (void)showRight {
    self.rightView.hidden = NO;
}

- (void)setIsWhiteBackground:(BOOL)isWhiteBackground {
    if (isWhiteBackground) {
        [self.backButton setImage:[UIImage SHANImageNamed:@"nav_icon_black_back" className:[self class]] forState:UIControlStateNormal];
        self.titleLabel.textColor = [UIColor shan_colorWithHexString:@"#333333"];
        self.explainLabel.textColor = [UIColor shan_colorWithHexString:@"#333333"];
    }
}

#pragma mark - Action
- (void)backBtnAction {
    !self.backClickBlock ? : self.backClickBlock();
}

- (void)toExplainAction {
    !self.explainClickBlock ? : self.explainClickBlock();
}

@end
