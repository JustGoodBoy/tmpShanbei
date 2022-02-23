//
//  SHANCashOutFrequencyAlertView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/17.
//

#import "SHANCashOutFrequencyAlertView.h"
#import "SHANHeader.h"
#import "UIImage+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"

@interface SHANCashOutFrequencyAlertView ()

@property (nonatomic, strong) UILabel *frequencyLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SHANCashOutFrequencyAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bodyView = [[UIView alloc] initWithFrame:CGRectMake(46, (kSHANScreenHeight - 208)*0.5, kSHANScreenWidth - 92, 208)];
    bodyView.backgroundColor = [UIColor whiteColor];
    bodyView.layer.cornerRadius = 16;
    bodyView.layer.masksToBounds = YES;
    [self addSubview:bodyView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, CGRectGetWidth(bodyView.frame), 60)];
    _titleLabel.numberOfLines = 0;
    [bodyView addSubview:_titleLabel];
    
    _frequencyLabel = [[UILabel alloc] init];
    _frequencyLabel.frame =CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) + 8, CGRectGetWidth(_titleLabel.frame), 24);
    _frequencyLabel.textColor = [UIColor shan_colorWithHexString:@"#999999"];
    _frequencyLabel.font = [UIFont shan_PingFangRegularFont:14];
    _frequencyLabel.textAlignment = NSTextAlignmentCenter;
    [bodyView addSubview:_frequencyLabel];
    
    UIButton *cashOutBtn = [[UIButton alloc] init];
    cashOutBtn.frame = CGRectMake(23, CGRectGetHeight(bodyView.frame) - 24 - 42, CGRectGetWidth(bodyView.frame) - 46, 42);
    cashOutBtn.layer.cornerRadius = 21;
    cashOutBtn.layer.masksToBounds = YES;
    cashOutBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:16];
    cashOutBtn.backgroundColor = [UIColor shan_colorWithHexString:@"#FD5558"];
    [cashOutBtn setTitle:@"去提现" forState:UIControlStateNormal];
    [cashOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cashOutBtn addTarget:self action:@selector(cashOutBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:cashOutBtn];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(kSHANScreenWidth - 46 - 32, CGRectGetMinY(bodyView.frame) - 16 - 32, 32, 32);
    [closeBtn setImage:[UIImage SHANImageNamed:@"taskFinished_close" className:[self class]] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
}

#pragma mark - Public
- (void)setCurrent:(NSString *)current AndFrequency:(NSString *)frequency {
    // content
    NSString *leftString = @"当前进度(";
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:leftString];
    NSAttributedString *currentString = [[NSAttributedString alloc] initWithString:current attributes:@{
        NSForegroundColorAttributeName: [UIColor shan_colorWithHexString:@"#FD5558"]
    }];
    [contentString appendAttributedString:currentString];
    
    NSAttributedString *rightString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%@)",frequency]];
    [contentString appendAttributedString:rightString];
    _frequencyLabel.attributedText = contentString;
    
    // title
    NSString *titleString = [NSString stringWithFormat:@"完成提现%@次\n即可获得该提现资格",frequency];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:10];
    paraStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:titleString attributes: @{
        NSParagraphStyleAttributeName:paraStyle,
        NSFontAttributeName: [UIFont shan_PingFangMediumFont:16],
        NSForegroundColorAttributeName: [UIColor shan_colorWithHexString:@"#333333"]
    }];
    _titleLabel.attributedText = string;
}

#pragma mark - Action
- (void)cashOutBtnAction {
    !self.didToCashOutAction ? : self.didToCashOutAction();
}

- (void)closeBtnBtnAction {
    !self.didCloseAction ? : self.didCloseAction();
}
@end
