//
//  ShanAttachTaskAgainAlertView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/2/9.
//

#import "ShanAttachTaskAgainAlertView.h"
#import "SHANCommonUIHeader.h"

@interface ShanAttachTaskAgainAlertView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *awardLabel;
@property (nonatomic, strong) UIButton *sureButton;
@end

@implementation ShanAttachTaskAgainAlertView
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
    
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = [UIImage SHANImageNamed:@"taskFinished_bg" className:[self class]];
    [bgView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.centerY.mas_equalTo(bgView.mas_centerY).offset(-51*kSHANScreenW_Radius);
        make.size.mas_equalTo(CGSizeMake(283, 372));
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"本轮奖励已领取哦!";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor shan_colorWithHexString:shanMainTextColor];
    _titleLabel.font = [UIFont shan_PingFangRegularFont:16];
    [bgImageView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.top.mas_equalTo(201);
    }];
    
    _awardLabel = [UILabel new];
    _awardLabel.textColor = [UIColor shan_colorWithHexString:@"#FD474D"];
    _awardLabel.textAlignment = NSTextAlignmentCenter;
    _awardLabel.font = [UIFont shan_PingFangMediumFont:18];
    [bgImageView addSubview:_awardLabel];
    [_awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(13);
        make.centerX.mas_equalTo(bgImageView);
    }];
    
     
    UIImage *image = [UIImage SHANImageNamed:@"taskCenter_btn_bg" className:[self class]];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 40, 0, 40);
    UIImage *btnBgImg = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake((kSHANScreenWidth - 221)*0.5, CGRectGetMaxY(bgImageView.frame) - 30 - 57, 221, 57);
    _sureButton.adjustsImageWhenHighlighted = NO;
    [_sureButton setBackgroundImage:btnBgImg forState:UIControlStateNormal];
    [_sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _sureButton.titleLabel.font = [UIFont shan_PingFangMediumFont:16];
    [_sureButton setTitleColor:[UIColor shan_colorWithHexString:@"#FDEAD0"] forState:UIControlStateNormal];
    [bgImageView addSubview:_sureButton];
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.bottom.mas_equalTo(bgImageView.mas_bottom).offset(-24);
        make.size.mas_equalTo(CGSizeMake(221, 57));
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.adjustsImageWhenHighlighted = NO;
    [closeBtn setImage:[UIImage SHANImageNamed:@"taskFinished_close" className:[self class]] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.top.mas_equalTo(bgImageView.mas_bottom).offset(24);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
}

- (void)shan_showAlert {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

#pragma mark - setter
- (void)setTitleTxt:(NSString *)titleTxt {
    _titleLabel.text = titleTxt;
}

- (void)setAwardTxt:(NSString *)awardTxt {
    _awardLabel.text = awardTxt;
}

- (void)setSureBtnTxt:(NSString *)sureBtnTxt {
    [_sureButton setTitle:sureBtnTxt forState:UIControlStateNormal];
}

#pragma mark - Action
- (void)sureButtonAction {
    !self.didSureAction ? : self.didSureAction();
    [self closeBtnBtnAction];
}

- (void)closeBtnBtnAction {
    [self removeFromSuperview];
}


@end
