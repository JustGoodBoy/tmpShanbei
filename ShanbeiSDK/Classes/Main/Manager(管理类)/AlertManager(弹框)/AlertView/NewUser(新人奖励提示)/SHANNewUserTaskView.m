//
//  SHANNewUserTaskView.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2022/1/21.
//

#import "SHANNewUserTaskView.h"
#import "SHANCommonUIHeader.h"
#import "ShanOpenNewUserRedPacketView.h"

/// 新人用户显示红包
static NSString * const kShanNewUserRedPacket = @"kShanNewUserRedPacket";
/// 新人用户点击红包
static NSString * const kShanNewUserClickRedPacket = @"kShanNewUserClickRedPacket";

@interface SHANNewUserTaskView ()
@property (nonatomic, strong) UILabel *moneyLabel;
@end

@implementation SHANNewUserTaskView

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
    
    CGFloat W = 294;
    CGFloat H = 374;
    UIImageView *bgImageView = [UIImageView new];
    UIImage *image = [UIImage SHANImageNamed:@"shan_newuser_task_bg" className:[self class]];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = image;
    [bgView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.centerY.mas_equalTo(bgView).offset(-11*kSHANScreenW_Radius);
        make.size.mas_equalTo(CGSizeMake(W, H));
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor shan_colorWithHexString:@"#FEF3BC"];
    titleLabel.font = [UIFont shan_PingFangMediumFont:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"恭喜！你收到一个现金红包";
    [bgImageView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.top.mas_equalTo(40);
    }];
    
    UIImage *openBtnImg = [UIImage SHANImageNamed:@"shan_newuser_open_btn" className:[self class]];
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.adjustsImageWhenHighlighted = NO;
    [openBtn setImage:openBtnImg forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(openBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:openBtn];
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.top.mas_equalTo(204);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
//    _moneyLabel = [UILabel new];
//    _moneyLabel.font = [UIFont shan_PingFangSemiboldFont:86];
//    _moneyLabel.textColor = [UIColor shan_colorWithHexString:@"#FEF3BC"];
//    [bgImageView addSubview:_moneyLabel];
//    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(87);
//        make.centerX.mas_equalTo(bgImageView).offset(-12);
//    }];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.font = [UIFont shan_PingFangSemiboldFont:86];
    _moneyLabel.textColor = [UIColor shan_colorWithHexString:@"#FEF3BC"];
    [bgImageView addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(87);
        make.centerX.mas_equalTo(bgImageView).offset(-12);
        make.height.mas_equalTo(94);
    }];
    
    UILabel *unit = [UILabel new];
    unit.font = [UIFont shan_PingFangRegularFont:16];
    unit.textColor = [UIColor shan_colorWithHexString:@"#FEF3BC"];
    unit.text = @"元";
    [bgImageView addSubview:unit];
    [unit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_moneyLabel.mas_bottom).offset(-12);
        make.left.mas_equalTo(_moneyLabel.mas_right);
    }];
    
    UILabel *maxLabel = [UILabel new];
    maxLabel.font = [UIFont shan_PingFangRegularFont:12];
    maxLabel.textColor = [UIColor shan_colorWithHexString:@"#FEF3BC"];
    maxLabel.text = @"最高";
    maxLabel.textAlignment = NSTextAlignmentCenter;
    maxLabel.layer.cornerRadius = 12;
    maxLabel.layer.masksToBounds = YES;
    maxLabel.layer.borderWidth = 1;
    maxLabel.layer.borderColor = [UIColor shan_colorWithHexString:@"#FEF3BC"].CGColor;
    [bgImageView addSubview:maxLabel];
    [maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_moneyLabel).offset(18);
        make.left.mas_equalTo(_moneyLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(42, 24));
    }];
    
    // 关闭
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.adjustsImageWhenHighlighted = NO;
    [closeBtn setImage:[UIImage SHANImageNamed:@"shan_icon_alert_close_alpha" className:[self class]] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bgImageView.mas_top).offset(-12);
        make.right.mas_equalTo(bgImageView.mas_right).offset(-11);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
}

- (void)shan_showAlert:(NSString *)awardCash {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _moneyLabel.text = awardCash;
}

#pragma mark - Action
/// 关闭
- (void)closeAction {
    [self removeFromSuperview];
}

- (void)openBtnAction {
    [self removeFromSuperview];
    !self.clickCashOutBlock ? : self.clickCashOutBlock();
}

/// 记录新人用户红包
+ (void)shan_saveNewUserRedPacket {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShanNewUserRedPacket];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 是否出现过新人用户红包
+ (BOOL)shan_isAriseNewUserRedPacket {
    // 是否记录过，记录过就不显示，没记录就显示
    BOOL isArise = [[NSUserDefaults standardUserDefaults] boolForKey:kShanNewUserRedPacket];
    return isArise;
}

/// 记录新人用户点击红包
+ (void)shan_saveClickNewUserRedPacketState:(BOOL)state {
    [[NSUserDefaults standardUserDefaults] setBool:state forKey:kShanNewUserClickRedPacket];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 是否点击过过新人用户红包
+ (BOOL)shan_isClickNewUserRedPacketState {
    BOOL isClick = [[NSUserDefaults standardUserDefaults] boolForKey:kShanNewUserClickRedPacket];
    return isClick;
}

@end
