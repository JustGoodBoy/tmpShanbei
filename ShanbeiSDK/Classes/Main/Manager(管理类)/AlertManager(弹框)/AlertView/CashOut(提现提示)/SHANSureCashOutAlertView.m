//
//  SHANSureCashOutAlertView.m
//  Pods
//
//  Created by GoodBoy on 2021/9/17.
//

#import "SHANSureCashOutAlertView.h"
#import "SHANHeader.h"
#import "UIImage+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"

@interface SHANSureCashOutAlertView ()

@property (nonatomic, strong) UILabel *cashLabel;
@property (nonatomic, strong) UILabel *modeLabel;

@end

@implementation SHANSureCashOutAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bodyView = [[UIView alloc] initWithFrame:CGRectMake(46, (kSHANScreenHeight - 248)*0.5, kSHANScreenWidth - 92, 248)];
    bodyView.backgroundColor = [UIColor whiteColor];
    bodyView.layer.cornerRadius = 16;
    bodyView.layer.masksToBounds = YES;
    [self addSubview:bodyView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, CGRectGetWidth(bodyView.frame), 25)];
    titleLabel.text = @"提现确认";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont shan_PingFangMediumFont:18];
    titleLabel.textColor = [UIColor shan_colorWithHexString:@"#333333"];
    [bodyView addSubview:titleLabel];
    
    UILabel *cashTitleLabel = [[UILabel alloc] init];
    cashTitleLabel.frame = CGRectMake(24, 70, 100, 20);
    cashTitleLabel.text = @"提现金额：";
    cashTitleLabel.font = [UIFont shan_PingFangRegularFont:14];
    cashTitleLabel.textColor = [UIColor shan_colorWithHexString:@"#999999"];
    [bodyView addSubview:cashTitleLabel];
    
    CGFloat cashLabelWidth = CGRectGetWidth(bodyView.frame) - CGRectGetMaxX(cashTitleLabel.frame) - 32;
    _cashLabel = [[UILabel alloc] init];
    _cashLabel.frame = CGRectMake(CGRectGetMaxX(cashTitleLabel.frame), CGRectGetMinY(cashTitleLabel.frame), cashLabelWidth, 20);
    _cashLabel.textAlignment = NSTextAlignmentRight;
    _cashLabel.font = [UIFont shan_PingFangRegularFont:14];
    _cashLabel.textColor = [UIColor shan_colorWithHexString:@"#FD5558"];
    [bodyView addSubview:_cashLabel];
    
    UILabel *modeTitleLabel = [[UILabel alloc] init];
    modeTitleLabel.frame = CGRectMake(24, CGRectGetMaxY(cashTitleLabel.frame) + 32, 100, 20);
    modeTitleLabel.text = @"提现方式：";
    modeTitleLabel.font = [UIFont shan_PingFangRegularFont:14];
    modeTitleLabel.textColor = [UIColor shan_colorWithHexString:@"#999999"];
    [bodyView addSubview:modeTitleLabel];
    
    _modeLabel = [[UILabel alloc] init];
    _modeLabel.frame = CGRectMake(CGRectGetMaxX(cashTitleLabel.frame), CGRectGetMinY(modeTitleLabel.frame), cashLabelWidth, 20);
    _modeLabel.textAlignment = NSTextAlignmentRight;
    _modeLabel.font = [UIFont shan_PingFangRegularFont:14];
    _modeLabel.textColor = [UIColor shan_colorWithHexString:@"#333333"];
    [bodyView addSubview:_modeLabel];
    
    UIButton *cashOutBtn = [[UIButton alloc] init];
    cashOutBtn.frame = CGRectMake(23, CGRectGetHeight(bodyView.frame) - 24 - 42, CGRectGetWidth(bodyView.frame) - 46, 42);
    cashOutBtn.layer.cornerRadius = 21;
    cashOutBtn.layer.masksToBounds = YES;
    cashOutBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:16];
    cashOutBtn.backgroundColor = [UIColor shan_colorWithHexString:@"#FD5558"];
    [cashOutBtn setTitle:@"确认提现" forState:UIControlStateNormal];
    [cashOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cashOutBtn addTarget:self action:@selector(cashOutBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:cashOutBtn];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(kSHANScreenWidth - 46 - 32, CGRectGetMinY(bodyView.frame) - 24 - 32, 32, 32);
    [closeBtn setImage:[UIImage SHANImageNamed:@"taskFinished_close" className:[self class]] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
}

#pragma mark - setter
- (void)setCashMoney:(NSString *)cashMoney {
    _cashMoney = cashMoney;
    _cashLabel.text = cashMoney;
}

- (void)setMode:(NSString *)mode {
    _mode = mode;
    _modeLabel.text = mode;
}

#pragma mark - Action
- (void)cashOutBtnAction:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    !self.didSureAction ? : self.didSureAction();
}

- (void)closeBtnBtnAction {
    !self.didCloseAction ? : self.didCloseAction();
}
@end
