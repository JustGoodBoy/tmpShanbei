//
//  SHANSleepCollectionViewCell.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/25.
//

#import "SHANSleepCollectionViewCell.h"
#import "UIButton+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "UIImage+SHAN.h"
#import "UIFont+SHAN.h"
@interface SHANSleepCollectionViewCell ()
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *coinImgView;
@property (nonatomic, strong) UILabel *coinLabel;
@end

@implementation SHANSleepCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImage *bgImage = [UIImage SHANImageNamed:@"shan_sleepTask_coin_light" className:[self class]];
    _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 49, 49)];
    _bgImgView.image = bgImage;
    _bgImgView.userInteractionEnabled = YES;
    [self addSubview:_bgImgView];
    _bgImgView.hidden = YES;
    
    UIImage *notReceivedImg = [UIImage SHANImageNamed:@"shan_sleepTask_notReceived" className:[self class]];
    _coinImgView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 11, 34, 34)];
    _coinImgView.image = notReceivedImg;
    _coinImgView.userInteractionEnabled = YES;
    [self addSubview:_coinImgView];
    
    _coinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_coinImgView.frame) + 6, self.frame.size.width, 16)];
    _coinLabel.font = [UIFont shan_PingFangRegularFont:11];
    _coinLabel.textColor = [UIColor shan_colorWithHexString:@"#FF8900" alphaComponent:0.5];
    _coinLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_coinLabel];
}

- (void)setRewardState:(SHANSleepTaskRewardState)rewardState {
    if (rewardState == 0) {
        _bgImgView.hidden = YES;
        UIImage *receivedImg = [UIImage SHANImageNamed:@"shan_sleepTask_Received" className:[self class]];
        _coinImgView.image = receivedImg;
        _coinLabel.text = @"已领";
        _coinLabel.textColor = [UIColor shan_colorWithHexString:@"#FF8900" alphaComponent:0.5];
    } else if (rewardState == 1) {
        _bgImgView.hidden = NO;
        UIImage *receiveImg = [UIImage SHANImageNamed:@"shan_sleepTask_receive" className:[self class]];
        _coinImgView.image = receiveImg;
        _coinLabel.text = @"可领";
        _coinLabel.textColor = [UIColor shan_colorWithHexString:@"#FF8900"];
    } else {
        _bgImgView.hidden = YES;
        UIImage *notReceivedImg = [UIImage SHANImageNamed:@"shan_sleepTask_notReceived" className:[self class]];
        _coinImgView.image = notReceivedImg;
        _coinLabel.text = @"待完成";
        _coinLabel.textColor = [UIColor shan_colorWithHexString:@"#D2D8F8" alphaComponent:0.43];
    }
}
@end
