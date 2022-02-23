//
//  ShanEatTimeGuideView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/2/8.
//

#import "ShanEatTimeGuideView.h"
#import "SHANCommonUIHeader.h"
#import "UIView+SHAN.h"
/// 吃饭时间引导
static NSString * const kShanEatTimeGuide = @"kShanEatTimeGuide";

@implementation ShanEatTimeGuideView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor shan_colorWithHexString:@"000000" alphaComponent:0.8];
    [self addSubview:bgView];
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [bgView addGestureRecognizer:tapG];
    
    UIImage *eatTimeBtnImg = [UIImage SHANImageNamed:@"shan_eat_time_btn" className:self.class];
    UIButton *eatTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eatTimeBtn.adjustsImageWhenHighlighted = NO;
    [eatTimeBtn setImage:eatTimeBtnImg forState:UIControlStateNormal];
    [eatTimeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:eatTimeBtn];
    [eatTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(kSHANCurveScreen ? -62 : -28);
        make.left.mas_equalTo(22);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    
    UIImageView *tipsImgView = [UIImageView new];
    tipsImgView.image = [UIImage SHANImageNamed:@"shan_eat_time_tips" className:self.class];
    [bgView addSubview:tipsImgView];
    [tipsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(eatTimeBtn.mas_top);
        make.left.mas_equalTo(eatTimeBtn);
        make.size.mas_equalTo(CGSizeMake(131, 45));
    }];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.text = @"这里是开饭时间~";
    tipsLabel.font = [UIFont shan_PingFangRegularFont:14];
    tipsLabel.textColor = [UIColor shan_colorWithHexString:@"#100808"];
    [tipsImgView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.centerX.mas_equalTo(tipsImgView);
    }];
}

- (void)shan_showAlert {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)closeAction {
    [[UIApplication sharedApplication].delegate.window removeFromSuperview];
    [self removeFromSuperview];
    [[UIApplication sharedApplication].delegate.window resignKeyWindow];
}

/// 记录吃饭提示新手引导
+ (void)saveEatTimeGuide {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShanEatTimeGuide];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 是否需要显示新手引导
+ (BOOL)shan_isNeedShowGuide {
    // 是否记录过，记录过就不显示，没记录就显示
    BOOL isShowed = [[NSUserDefaults standardUserDefaults] boolForKey:kShanEatTimeGuide];
    
    BOOL isNeedShowGuide = !isShowed;
    if (isNeedShowGuide) {
        [self saveEatTimeGuide];
    }
    return isNeedShowGuide;
}

@end
