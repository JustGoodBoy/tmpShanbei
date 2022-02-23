//
//  SHANRuleAlertView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import "SHANRuleAlertView.h"
#import "SHANHeader.h"
#import "UIImage+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"

@implementation SHANRuleAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIView *bodyView = [[UIView alloc] initWithFrame:CGRectMake((kSHANScreenWidth - 283)*0.5, (kSHANScreenHeight - 318)*0.5 - 19, 283, 318)];
    bodyView.backgroundColor = [UIColor whiteColor];
    bodyView.layer.cornerRadius = 16;
    bodyView.layer.masksToBounds = YES;
    [self addSubview:bodyView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, CGRectGetWidth(bodyView.frame), 25)];
    titleLabel.text = @"规则说明";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor shan_colorWithHexString:@"#333333"];
    titleLabel.font = [UIFont shan_PingFangMediumFont:18];
    [bodyView addSubview:titleLabel];
    
    NSString *ruleString = @"1.积分是什么：积分是一种虚拟币，您赚取的积分每天凌晨会自动兑换成现金（兑换比例受每日广告收益影响浮动），兑换后的现金可用于提现，使您获得收益；\n2.积分如何获取：完成任务即可获得积分。体验越深入，获得积分越多。";
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:5];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:ruleString attributes:@{
        NSForegroundColorAttributeName: [UIColor shan_colorWithHexString:@"#999999"],
        NSFontAttributeName: [UIFont shan_PingFangRegularFont:14],
        NSParagraphStyleAttributeName: paraStyle
    }];
    
    UILabel *ruleLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 53, CGRectGetWidth(bodyView.frame) - 46, 168)];
    ruleLabel.numberOfLines = 0;
    [bodyView addSubview:ruleLabel];
    ruleLabel.attributedText = content;
    
    UIButton *knownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    knownBtn.frame = CGRectMake(23, CGRectGetHeight(bodyView.frame) - 24 - 42, 237, 42);
    knownBtn.backgroundColor = [UIColor shan_colorWithHexString:@"#FD5558"];
    knownBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:18];
    [knownBtn setTitle:@"知道啦" forState:UIControlStateNormal];
    [knownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [knownBtn addTarget:self action:@selector(knownBtnAction) forControlEvents:UIControlEventTouchUpInside];
    knownBtn.layer.cornerRadius = 21;
    knownBtn.layer.masksToBounds = YES;
    [bodyView addSubview:knownBtn];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake((kSHANScreenWidth - 32)*0.5, CGRectGetMaxY(bodyView.frame) + 24, 32, 32);
    [closeBtn setImage:[UIImage SHANImageNamed:@"taskFinished_close" className:[self class]] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
}

- (void)knownBtnAction {
    !self.didKnownAction ? : self.didKnownAction();
}

- (void)closeBtnBtnAction {
    !self.didCloseAction ? : self.didCloseAction();
}
@end
