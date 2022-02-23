//
//  SHANCashTaskAlertView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/22.
//

#import "SHANCashTaskAlertView.h"
#import "SHANHeader.h"
#import "UIImage+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"

@interface SHANCashTaskAlertView ()

@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *sureButton;
@end

@implementation SHANCashTaskAlertView

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
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kSHANScreenWidth - 283)*0.5, (kSHANScreenHeight - 372)*0.5 - 51*kSHANScreenW_Radius, 283, 372)];
    bgImageView.image = [UIImage SHANImageNamed:@"taskFinished_bg" className:[self class]];
    [bgView addSubview:bgImageView];
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 201, CGRectGetWidth(bgImageView.frame), 22)];
    _tipsLabel.text = @"恭喜，您已完成任务";
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.textColor = [UIColor shan_colorWithHexString:shanMainTextColor];
    _tipsLabel.font = [UIFont shan_PingFangRegularFont:16];
    [bgImageView addSubview:_tipsLabel];
    
    _coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tipsLabel.frame) + 13, CGRectGetWidth(bgImageView.frame), 25)];
    _coinLabel.textColor = [UIColor shan_colorWithHexString:@"#FD474D"];
    _coinLabel.textAlignment = NSTextAlignmentCenter;
    _coinLabel.font = [UIFont shan_PingFangMediumFont:18];
    [bgImageView addSubview:_coinLabel];
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.adjustsImageWhenHighlighted = NO;
    _sureButton.frame = CGRectMake((kSHANScreenWidth - 221)*0.5, CGRectGetMaxY(bgImageView.frame) - 15 - 57, 221, 57);
    [_sureButton setImage:[UIImage SHANImageNamed:@"taskFinished_cashout" className:[self class]] forState:UIControlStateNormal];
    [_sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_sureButton];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.adjustsImageWhenHighlighted = NO;
    closeBtn.frame = CGRectMake((kSHANScreenWidth - 32)*0.5, CGRectGetMaxY(bgImageView.frame) + 24, 32, 32);
    [closeBtn setImage:[UIImage SHANImageNamed:@"taskFinished_close" className:[self class]] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
}

- (void)shan_showAlert:(NSString *)awardCash {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _coinLabel.text = awardCash;
}

#pragma mark - setter
- (void)setContent:(NSString *)content {
    _coinLabel.text = content;
}

- (void)setSureBtnTxt:(NSString *)sureBtnTxt {
    if (![sureBtnTxt isEqualToString:@"去提现"]) {
        [_sureButton setImage:[UIImage SHANImageNamed:@"taskFinished_accept" className:[self class]] forState:UIControlStateNormal];
    } else {
        [_sureButton setImage:[UIImage SHANImageNamed:@"taskFinished_cashout" className:[self class]] forState:UIControlStateNormal];
    }
}

#pragma mark - Action
- (void)sureButtonAction {
    !self.didSureAction ? : self.didSureAction();
    [self closeBtnBtnAction];
}

- (void)closeBtnBtnAction {
    !self.didCloseAction ? : self.didCloseAction();
    [self removeFromSuperview];
}

@end
