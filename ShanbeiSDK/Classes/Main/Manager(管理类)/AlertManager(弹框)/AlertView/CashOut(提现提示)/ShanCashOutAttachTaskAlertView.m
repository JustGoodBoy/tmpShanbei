//
//  ShanCashOutAttachTaskAlertView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/2/9.
//

#import "ShanCashOutAttachTaskAlertView.h"
#import "SHANCommonUIHeader.h"
#import "NSString+SHAN.h"
@interface ShanCashOutAttachTaskAlertView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation ShanCashOutAttachTaskAlertView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight);
    bgView.backgroundColor = [UIColor shan_colorWithHexString:@"000000" alphaComponent:0.8 ];
    [self addSubview:bgView];
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [bgView addGestureRecognizer:tapG];
    
    CGFloat W = 283;
    CGFloat H = 279;
    UIImageView *bgImageView = [UIImageView new];
    UIImage *image = [UIImage SHANImageNamed:@"shan_cashout_attach_bg" className:[self class]];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = image;
    [bgView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.centerY.mas_equalTo(bgView).offset(-16*kSHANScreenW_Radius);
        make.size.mas_equalTo(CGSizeMake(W, H));
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont shan_PingFangRegularFont:16];
    [bgImageView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(107);
        make.centerX.mas_equalTo(bgImageView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(231, 60));
    }];
    
    // 关闭
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.adjustsImageWhenHighlighted = NO;
    [closeBtn setImage:[UIImage SHANImageNamed:@"shan_icon_alert_close_alpha" className:[self class]] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgImageView);
        make.right.mas_equalTo(bgImageView.mas_right);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    UIButton *watchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    watchBtn.adjustsImageWhenHighlighted = NO;
    [watchBtn setImage:[UIImage SHANImageNamed:@"shan_go_watch_btn" className:[self class]] forState:UIControlStateNormal];
    [watchBtn addTarget:self action:@selector(watchAction) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:watchBtn];
    [watchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.bottom.mas_equalTo(bgImageView.mas_bottom).offset(-24);
        make.size.mas_equalTo(CGSizeMake(221, 57));
    }];
}

- (void)shan_showAlert {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    NSString *titleTxt = @"再看1个广告视频，即可提现成功并再得<0.1元>现金红包";
    NSMutableAttributedString *content = [titleTxt getAttributedString:[UIColor shan_colorWithHexString:@"#A0715A"] highLightColor:[UIColor shan_colorWithHexString:@"#FD4148"] font:[UIFont shan_PingFangMediumFont:16]];
    _titleLabel.attributedText = content;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Action
/// 关闭
- (void)closeAction {
    [self removeFromSuperview];
}

- (void)watchAction {
    [self removeFromSuperview];
    !self.didNextStepAction ? : self.didNextStepAction();
}

@end
