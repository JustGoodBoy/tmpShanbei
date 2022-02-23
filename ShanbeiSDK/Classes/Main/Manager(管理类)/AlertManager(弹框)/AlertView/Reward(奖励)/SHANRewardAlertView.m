//
//  SHANRewardAlertView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/25.
//

#import "SHANRewardAlertView.h"
#import "SHANHeader.h"
#import "UIImage+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
@interface SHANRewardAlertView ()

@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *otherBtn;
@property (nonatomic, assign) BOOL isAttach;
@property (nonatomic, copy) NSString *attachTaskID;
@end
@implementation SHANRewardAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(SHANRewardBackGroundType)type {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    NSString *tipsTxtColor = @"D2D8F8";
    NSString *rewardTxtColor = @"FFD043";
    NSString *btnTxtColor = @"814400";
    CGFloat width = 283.0;
    CGFloat height = 230.0;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kSHANScreenWidth - width)*0.5,  (kSHANScreenHeight - height)*0.5, width, height)];
    bgImageView.image = [UIImage SHANImageNamed:@"shan_reward_body_dark_bg" className:[self class]];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgImageView];
    
    // 图片背景是的光芒往右偏移
    UIImageView *coin_bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(14, -142, 243, 243)];
    coin_bgImg.image = [UIImage SHANImageNamed:@"shan_icon_coin_bg" className:[self class]];
    [bgImageView addSubview:coin_bgImg];
    
    UIImageView *coinImg = [[UIImageView alloc] initWithFrame:CGRectMake(95, 88, 80, 80)];
    coinImg.image = [UIImage SHANImageNamed:@"shan_icon_coin" className:[self class]];
    [coin_bgImg addSubview:coinImg];
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, CGRectGetWidth(bgImageView.frame), 22)];
    _tipsLabel.text = @"恭喜您获得积分";
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.textColor = [UIColor shan_colorWithHexString:tipsTxtColor];
    _tipsLabel.font = [UIFont shan_PingFangRegularFont:16];
    [bgImageView addSubview:_tipsLabel];
    
    _coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tipsLabel.frame) + 13, CGRectGetWidth(bgImageView.frame), 25)];
    _coinLabel.textColor = [UIColor shan_colorWithHexString:rewardTxtColor];
    _coinLabel.textAlignment = NSTextAlignmentCenter;
    _coinLabel.font = [UIFont shan_PingFangMediumFont:18];
    [bgImageView addSubview:_coinLabel];
    
    UIImage *tmpImage = [UIImage SHANImageNamed:@"shan_sleepTask_sleepBtn" className:[self class]];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 30, 0, 30);
    UIImage *attachBtnImage = [tmpImage resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    
    _otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _otherBtn.adjustsImageWhenHighlighted = NO;
    _otherBtn.frame = CGRectMake(40, 162, 215, 49);
    _otherBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:16];
    [_otherBtn setBackgroundImage:attachBtnImage forState:UIControlStateNormal];
    [_otherBtn addTarget:self action:@selector(otherBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_otherBtn setTitleColor:[UIColor shan_colorWithHexString:btnTxtColor] forState:UIControlStateNormal];
    [bgImageView addSubview:_otherBtn];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.adjustsImageWhenHighlighted = NO;
    closeBtn.frame = CGRectMake((kSHANScreenWidth - 32)*0.5, CGRectGetMaxY(bgImageView.frame) + 24, 32, 32);
    [closeBtn setImage:[UIImage SHANImageNamed:@"taskFinished_close" className:[self class]] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
}

#pragma mark - Public
/// 设置正常的奖励提示框
- (void)shan_setNormalRewardTitle:(NSString *)title reward:(NSString *)reward {
    _isAttach = false;
    _tipsLabel.text = title;
    _coinLabel.text = reward;
    [_otherBtn setTitle:@"开心收下" forState:UIControlStateNormal];
}

/// 设置有追加任务的奖励提示框
- (void)shan_setAttachRewardTitle:(NSString *)title reward:(NSString *)reward rewardTips:(NSString *)rewardTips attachTaskID:(NSString *)attachTaskID{
    _attachTaskID = attachTaskID;
    _isAttach = true;
    _tipsLabel.text = title;
    _coinLabel.text = reward;
    [_otherBtn setTitle:rewardTips forState:UIControlStateNormal];
}

#pragma mark - Action
- (void)otherBtnAction {
    if (_isAttach) {
        !self.didAttachTaskWithIDAction ? : self.didAttachTaskWithIDAction(self.attachTaskID);
    }
    [self removeFromSuperview];
}

- (void)closeBtnBtnAction {
    [self removeFromSuperview];
}

@end
