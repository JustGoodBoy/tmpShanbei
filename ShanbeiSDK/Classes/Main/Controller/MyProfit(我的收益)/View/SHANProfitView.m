//
//  SHANProfitView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import "SHANProfitView.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
#import "UIView+SHAN.h"
#import "NSString+SHAN.h"
#import "SHANHeader.h"
#import "SHANControlManager.h"
#import "SHANAccountManager.h"
@interface SHANProfitView ()

@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UILabel *cashLabel;
@property (nonatomic, strong) UIButton *cashOutBtn;
@end

@implementation SHANProfitView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *coinTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, kSHANScreenWidth/3 - 1, 20)];
    coinTitleLabel.text = @"积分收益";
    coinTitleLabel.textAlignment = NSTextAlignmentCenter;
    coinTitleLabel.textColor = [UIColor whiteColor];
    coinTitleLabel.font = [UIFont shan_PingFangRegularFont:14];
    [self addSubview:coinTitleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(coinTitleLabel.frame), 42, 0.5, 28)];
    line.backgroundColor = [UIColor shan_colorWithHexString:@"#FF9799"];
    [self addSubview:line];
    
    UILabel *cashTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSHANScreenWidth/3, 32, kSHANScreenWidth/3, 20)];
    cashTitleLabel.text = @"现金收益";
    cashTitleLabel.textAlignment = NSTextAlignmentCenter;
    cashTitleLabel.textColor = [UIColor whiteColor];
    cashTitleLabel.font = [UIFont shan_PingFangRegularFont:14];
    [self addSubview:cashTitleLabel];
    
    _coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(coinTitleLabel.frame) + 4, CGRectGetWidth(coinTitleLabel.frame), 26)];
    _coinLabel.textAlignment = NSTextAlignmentCenter;
    _coinLabel.textColor = [UIColor whiteColor];
    _coinLabel.font = [UIFont shan_PingFangMediumFont:24];
    [self addSubview:_coinLabel];
    
    _cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(cashTitleLabel.frame), CGRectGetMaxY(cashTitleLabel.frame) + 4, CGRectGetWidth(cashTitleLabel.frame), 26)];
    _cashLabel.font = [UIFont shan_PingFangMediumFont:12];
    _cashLabel.textColor = [UIColor whiteColor];
    [self addSubview:_cashLabel];
    
    _cashOutBtn = [[UIButton alloc] init];
    _cashOutBtn.frame = CGRectMake(kSHANScreenWidth - (kSHANScreenWidth/3 - 37) - 20, 56, kSHANScreenWidth/3 - 37, 30);
    _cashOutBtn.layer.cornerRadius = 15;
    _cashOutBtn.layer.masksToBounds = YES;
    _cashOutBtn.backgroundColor = [UIColor whiteColor];
    _cashOutBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:14];
    [_cashOutBtn setTitle:@"去提现" forState:UIControlStateNormal];
    [_cashOutBtn setTitleColor:[UIColor shan_colorWithHexString:@"#FD5558"] forState:UIControlStateNormal];
    [_cashOutBtn addTarget:self action:@selector(cashOutBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cashOutBtn];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 102, kSHANScreenWidth - 32, 17)];
    tipsLabel.text = @"当前兑换比例：10000积分=1元(比例受每日广告收益影响浮动)";
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.font = [UIFont shan_PingFangLightFont:12];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipsLabel];
}

#pragma mark - Public(公开⽅法)
- (void)shanReloadProfit {
    
    NSString *coin = [SHANAccountManager sharedManager].coin;
    if (kSHANStringIsEmpty(coin)) {
        coin = @"0";
    }
    _coinLabel.text = coin;
    
    NSString *cash = [SHANAccountManager sharedManager].cash;
    if (kSHANStringIsEmpty(cash)) {
        cash = @"0";
    }
    cash = [NSString stringWithFormat:@"%.2f",[cash floatValue]/100];
    cash = [cash removeSurplusZero:cash];
    cash = [NSString stringWithFormat:@"%@元",cash];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cash];
    NSDictionary *attributedDict = @{
        NSFontAttributeName:[UIFont systemFontOfSize:24.0],
    };
    [string setAttributes:attributedDict range:NSMakeRange(0, string.length-1)];
    _cashLabel.attributedText = string;
    _cashLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Action
- (void)cashOutBtnAction {
    [SHANControlManager openCashOutViewController];
}
@end
