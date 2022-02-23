//
//  SHANProfitEmptyView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/26.
//

#import "SHANProfitEmptyView.h"
#import "UIImage+SHAN.h"
#import "SHANHeader.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
@implementation SHANProfitEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *emptyView = [[UIImageView alloc] init];
    emptyView.frame = CGRectMake((kSHANScreenWidth - 84)/2, 0, 84, 96);
    emptyView.image = [UIImage SHANImageNamed:@"shan_profit_empty" className:self.class];
    [self addSubview:emptyView];
    
    UILabel *emptyLabel = [[UILabel alloc] init];
    emptyLabel.frame = CGRectMake(0, 116, kSHANScreenWidth, 22);
    emptyLabel.text = @"暂时没有收益";
    emptyLabel.textColor = [UIColor shan_colorWithHexString:@"#202124"];
    emptyLabel.font = [UIFont shan_PingFangMediumFont:16];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:emptyLabel];
    
    UILabel *emptyTipsLabel = [[UILabel alloc] init];
    emptyTipsLabel.frame = CGRectMake(0, 146, kSHANScreenWidth, 17);
    emptyTipsLabel.text = @"可以前往任务去多做任务哦~";
    emptyTipsLabel.textColor = [UIColor shan_colorWithHexString:@"#92949A"];
    emptyTipsLabel.font = [UIFont shan_PingFangRegularFont:12];
    emptyTipsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:emptyTipsLabel];
    
    UIButton *goBtn = [[UIButton alloc] init];
    goBtn.frame = CGRectMake((kSHANScreenWidth - 190)/2, 195, 190, 42);
    goBtn.adjustsImageWhenHighlighted = NO;
    goBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:16];
    goBtn.layer.cornerRadius = 21;
    goBtn.layer.masksToBounds = YES;
    goBtn.backgroundColor = [UIColor shan_colorWithHexString:@"#FD5558"];
    [goBtn setTitle:@"点击前往" forState:UIControlStateNormal];
    [goBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(goBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:goBtn];
}

#pragma mark - Action
- (void)goBtnAction {
    !self.clickGoTaskCenter ? : self.clickGoTaskCenter();
}

@end
