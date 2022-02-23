//
//  SHANTaskFinishedAlertView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import "SHANTaskFinishedAlertView.h"
#import "SHANHeader.h"
#import "UIImage+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"

@interface SHANTaskFinishedAlertView ()

@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@end

@implementation SHANTaskFinishedAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kSHANScreenWidth - 283)*0.5, (kSHANScreenHeight - 372)*0.5 - 51*kSHANScreenW_Radius, 283, 372)];
    bgImageView.image = [UIImage SHANImageNamed:@"taskFinished_bg" className:[self class]];
    [self addSubview:bgImageView];
    
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
    
    UIButton *acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.adjustsImageWhenHighlighted = NO;
    acceptBtn.frame = CGRectMake((kSHANScreenWidth - 221)*0.5, CGRectGetMaxY(bgImageView.frame) - 15 - 57, 221, 57);
    [acceptBtn setImage:[UIImage SHANImageNamed:@"taskFinished_accept" className:[self class]] forState:UIControlStateNormal];
    [acceptBtn addTarget:self action:@selector(acceptBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:acceptBtn];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.adjustsImageWhenHighlighted = NO;
    closeBtn.frame = CGRectMake((kSHANScreenWidth - 32)*0.5, CGRectGetMaxY(bgImageView.frame) + 24, 32, 32);
    [closeBtn setImage:[UIImage SHANImageNamed:@"taskFinished_close" className:[self class]] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
}

#pragma mark - setter
- (void)setContent:(NSString *)content {
    _coinLabel.text = content;
}

- (void)setTaskType:(SHANTaskType)taskType {
    _tipsLabel.text = taskType == 0 ? @"恭喜，您已完成任务" : @"好友邀请码提交成功";
}
#pragma mark - Action
- (void)acceptBtnAction {
    !self.didAcceptAction ? : self.didAcceptAction();
}

- (void)closeBtnBtnAction {
    !self.didCloseAction ? : self.didCloseAction();
}

@end
