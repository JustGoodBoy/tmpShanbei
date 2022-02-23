//
//  ShanOpenNewUserRedPacketView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/2/8.
//

#import "ShanOpenNewUserRedPacketView.h"
#import "SHANCommonUIHeader.h"
#import "SHANControlManager.h"
#import "SHANAccountManager.h"
#import "ShanbeiManager.h"
#import "SHANHUD.h"
#import "SHANNewUserTaskView.h"
@interface ShanOpenNewUserRedPacketView ()
@property (nonatomic, strong) UILabel *moneyLabel;
@end

@implementation ShanOpenNewUserRedPacketView
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
    CGFloat H = 339;
    UIImageView *bgImageView = [UIImageView new];
    UIImage *image = [UIImage SHANImageNamed:@"shan_open_newuser_task_bg" className:[self class]];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = image;
    [bgView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.centerY.mas_equalTo(bgView).offset(-26*kSHANScreenW_Radius);
        make.size.mas_equalTo(CGSizeMake(W, H));
    }];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.font = [UIFont shan_PingFangSemiboldFont:86];
    _moneyLabel.textColor = [UIColor shan_colorWithHexString:@"#FD4148"];
    [bgImageView addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(71);
        make.centerX.mas_equalTo(bgImageView).offset(-5);
        make.height.mas_equalTo(94);
    }];
    
    UILabel *unit = [UILabel new];
    unit.font = [UIFont shan_PingFangRegularFont:16];
    unit.textColor = [UIColor shan_colorWithHexString:@"#FD4148"];
    unit.text = @"元";
    [bgImageView addSubview:unit];
    [unit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_moneyLabel.mas_bottom).offset(-12);
        make.left.mas_equalTo(_moneyLabel.mas_right);
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
    
    UIButton *cashOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cashOutBtn.adjustsImageWhenHighlighted = NO;
    [cashOutBtn setImage:[UIImage SHANImageNamed:@"shan_go_cashout_btn" className:[self class]] forState:UIControlStateNormal];
    [cashOutBtn addTarget:self action:@selector(cashOutAction) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:cashOutBtn];
    [cashOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.bottom.mas_equalTo(bgImageView.mas_bottom).offset(-44);
        make.size.mas_equalTo(CGSizeMake(221, 57));
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

- (void)cashOutAction {
    [self removeFromSuperview];
    [SHANNewUserTaskView shan_saveClickNewUserRedPacketState:YES];
    if ([SHANAccountManager sharedManager].isLogin) {
        [SHANControlManager openCashOutViewController];
    } else {
        if ([ShanbeiManager shareManager].loginBlock) {
            [ShanbeiManager shareManager].loginBlock();
        }
    }
}
@end
