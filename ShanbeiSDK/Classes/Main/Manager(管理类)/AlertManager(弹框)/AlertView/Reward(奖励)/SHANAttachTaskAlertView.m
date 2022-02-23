//
//  SHANAttachTaskAlertView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/10/26.
//

#import "SHANAttachTaskAlertView.h"
#import "SHANHeader.h"
#import "UIImage+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
#import "SHANMenu.h"
@interface SHANAttachTaskAlertView ()

@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UIButton *attachTaskBtn;
@property (nonatomic, strong) UIButton *skipAdBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, assign) NSInteger attachTaskType; //附加任务类型
@property (nonatomic, strong) UILabel *tipsLabel;
@end

@implementation SHANAttachTaskAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGFloat W = 283;
    CGFloat H = (372 + 40); // 372 UI图片给的高度， 40 “不看广告”按钮高度+底部边距
    CGFloat X = (kSHANScreenWidth - W)*0.5;
    CGFloat Y = (kSHANScreenHeight - H)*0.5 - 51*kSHANScreenW_Radius;
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(372 - 40, 0, 15, 0);
    UIImage *image = [UIImage SHANImageNamed:@"taskFinished_bg" className:[self class]];
    bgImageView.image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    [self addSubview:bgImageView];
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 201, CGRectGetWidth(bgImageView.frame), 22)];
//    _tipsLabel.text = @"恭喜，您已完成今日签到任务";
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.textColor = [UIColor shan_colorWithHexString:shanMainTextColor];
    _tipsLabel.font = [UIFont shan_PingFangRegularFont:16];
    [bgImageView addSubview:_tipsLabel];
    
    _coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tipsLabel.frame) + 13, CGRectGetWidth(bgImageView.frame), 25)];
    _coinLabel.textColor = [UIColor shan_colorWithHexString:@"#FD474D"];
    _coinLabel.textAlignment = NSTextAlignmentCenter;
    _coinLabel.font = [UIFont shan_PingFangMediumFont:18];
    [bgImageView addSubview:_coinLabel];
    
    // 追加任务
    _attachTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _attachTaskBtn.frame = CGRectMake((kSHANScreenWidth - 221)*0.5, CGRectGetMaxY(bgImageView.frame) - 52 - 57, 221, 57);
    _attachTaskBtn.adjustsImageWhenHighlighted = NO;
    _attachTaskBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:16];
    [_attachTaskBtn setTitleColor:[UIColor shan_colorWithHexString:@"#FDEAD0"] forState:UIControlStateNormal];
    [_attachTaskBtn addTarget:self action:@selector(attachTaskBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_attachTaskBtn];
    
    UIImage *attachTaskBtnImage = [UIImage SHANImageNamed:@"taskCenter_btn_bg" className:[self class]];
    UIEdgeInsets attachTaskBtnEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 30);
    attachTaskBtnImage = [attachTaskBtnImage resizableImageWithCapInsets:attachTaskBtnEdgeInsets resizingMode:UIImageResizingModeStretch];
    [_attachTaskBtn setBackgroundImage:attachTaskBtnImage forState:UIControlStateNormal];
    
    // 跳过广告
    _skipAdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _skipAdBtn.frame = CGRectMake(CGRectGetMinX(_attachTaskBtn.frame), CGRectGetMaxY(bgImageView.frame) - 40, CGRectGetWidth(_attachTaskBtn.frame), 20);
    _skipAdBtn.titleLabel.font = [UIFont shan_PingFangRegularFont:14];
    [_skipAdBtn setTitle:@"不看广告，直接领取" forState:UIControlStateNormal];
    [_skipAdBtn setTitleColor:[UIColor shan_colorWithHexString:@"#A0715A"] forState:UIControlStateNormal];
    [_skipAdBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_skipAdBtn];
//    _skipAdBtn.alpha = 0.1;
    
    // 关闭
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.frame = CGRectMake((kSHANScreenWidth - 32)*0.5, CGRectGetMaxY(bgImageView.frame) + 24, 32, 32);
    [_closeBtn setImage:[UIImage SHANImageNamed:@"taskFinished_close" className:[self class]] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn];
//    _closeBtn.alpha = 0.1;
    
//    [UIView animateWithDuration:3 animations:^{
//        self.closeBtn.alpha = 1;
//        self.skipAdBtn.alpha = 1;
//    }];
}

#pragma mark - Public
/// 设置奖励数据
/// @param coin 本次任务奖励
/// @param attachCoin 附加任务奖励
/// @param attachType 附加任务类型，SHANTaskListTypeOfHideSign是签到追加任务
- (void)setInfoWithCoin:(NSString *)coin attachCoin:(NSString *)attachCoin attachType:(NSInteger)attachType {
    _coinLabel.text = [NSString stringWithFormat:@"+%@积分",coin];
    NSString *text = [NSString stringWithFormat:@"看视频再领%@积分",attachCoin];
    [_attachTaskBtn setTitle:text forState:UIControlStateNormal];
    _attachTaskType = attachType;
    
    // 因为签到任务不在任务列表里面，所以根据attachType推断本次任务是否是签到任务
    NSString *tag = attachType == SHANTaskListTypeOfHideSign ? @"今日签到" : @"";
    _tipsLabel.text = [NSString stringWithFormat:@"恭喜，您已完成%@任务",tag];
}

#pragma mark - Action
/// 追加任务
- (void)attachTaskBtnAction {
    !self.didAttachTaskAction ? : self.didAttachTaskAction(self.attachTaskType);
    [self closeAction];
}

/// 关闭
- (void)closeAction {
    [self removeFromSuperview];
}

@end
