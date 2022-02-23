//
//  SHANTaskBoxAlertView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/18.
//

#import "SHANTaskBoxAlertView.h"
#import "SHANHeader.h"
#import "UIImage+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"

@interface SHANTaskBoxAlertView ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *attachTaskBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation SHANTaskBoxAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGFloat width = 303.0;
    CGFloat left = (kSHANScreenWidth - 303.0)*0.5;
    CGFloat top = kSHANStatusBarHeight + 115;
    UIImageView *boxImgView = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, width, width)];
    boxImgView.image = [UIImage SHANImageNamed:@"taskCenter_boxAlert_bg" className:[self class]];
    boxImgView.userInteractionEnabled = YES;
    [self addSubview:boxImgView];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(boxImgView.frame) - 21, CGRectGetWidth(boxImgView.frame), 25)];
    _contentLabel.textColor = [UIColor shan_colorWithHexString:@"#FDEAD0"];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.font = [UIFont shan_PingFangMediumFont:18];
    [boxImgView addSubview:_contentLabel];
    
    // 追加任务
    _attachTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _attachTaskBtn.frame = CGRectMake((kSHANScreenWidth - 249)*0.5, CGRectGetMaxY(boxImgView.frame) + 57, 249, 57);
    _attachTaskBtn.adjustsImageWhenHighlighted = NO;
    _attachTaskBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:16];
    [_attachTaskBtn setTitleColor:[UIColor shan_colorWithHexString:@"#FDEAD0"] forState:UIControlStateNormal];
    [_attachTaskBtn addTarget:self action:@selector(attachTaskBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_attachTaskBtn];
    
    UIImage *attachTaskBtnImage = [UIImage SHANImageNamed:@"taskCenter_btn_bg" className:[self class]];
    UIEdgeInsets attachTaskBtnEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 30);
    attachTaskBtnImage = [attachTaskBtnImage resizableImageWithCapInsets:attachTaskBtnEdgeInsets resizingMode:UIImageResizingModeStretch];
    [_attachTaskBtn setBackgroundImage:attachTaskBtnImage forState:UIControlStateNormal];
    
    // 关闭
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.frame = CGRectMake(257, 72, 24, 24);
    _closeBtn.adjustsImageWhenHighlighted = NO;
    [_closeBtn setImage:[UIImage SHANImageNamed:@"taskFinished_close" className:[self class]] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [boxImgView addSubview:_closeBtn];
}

- (void)setInfoWithCoin:(NSString *)coin attachCoin:(NSString *)attachCoin {
    _contentLabel.text = [NSString stringWithFormat:@"恭喜，获得%@积分",coin];
    NSString *text = [NSString stringWithFormat:@"看视频再领%@积分",attachCoin];
    [_attachTaskBtn setTitle:text forState:UIControlStateNormal];
}

#pragma mark - Action
/// 追加任务
- (void)attachTaskBtnAction {
    !self.didAttachTaskAction ? : self.didAttachTaskAction();
    [self disMissAlert];
}

/// 关闭
- (void)closeBtnBtnAction {
    [self disMissAlert];
}

- (void)disMissAlert {
    [self removeFromSuperview];
}
@end
