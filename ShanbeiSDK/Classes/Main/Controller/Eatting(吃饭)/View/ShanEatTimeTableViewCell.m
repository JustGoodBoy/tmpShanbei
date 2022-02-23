//
//  ShanEatTimeTableViewCell.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/22.
//

#import "ShanEatTimeTableViewCell.h"
#import "SHANCommonUIHeader.h"
#import "ShanEatModel.h"
@interface ShanEatTimeTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
/// 时间
@property (nonatomic, strong) UILabel *timeLabel;
/// 奖励
@property (nonatomic, strong) UILabel *awardLabel;
/// 领取状态
@property (nonatomic, strong) UILabel *receiveLabel;
@end

@implementation ShanEatTimeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor shan_colorWithHexString:@"#353B4E"];
    _titleLabel.font = [UIFont shan_PingFangMediumFont:16];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.contentView);
    }];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [UIColor shan_colorWithHexString:@"#9A9A9A"];
    _timeLabel.font = [UIFont shan_PingFangRegularFont:12];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(4);
    }];
    
    UIImageView *coin = [UIImageView new];
    coin.image = [UIImage SHANImageNamed:@"shan_icon_coin" className:self.class];
    [self.contentView addSubview:coin];
    [coin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(_titleLabel);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    _awardLabel = [UILabel new];
    _awardLabel.textColor = [UIColor shan_colorWithHexString:@"#FF8900"];
    _awardLabel.font = [UIFont shan_PingFangRegularFont:16];
    [self.contentView addSubview:_awardLabel];
    [_awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(coin.mas_right).offset(4);
        make.centerY.mas_equalTo(_titleLabel);
    }];
    
    _receiveLabel = [UILabel new];
    _receiveLabel.font = [UIFont shan_PingFangRegularFont:14];
    [self.contentView addSubview:_receiveLabel];
    [_receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24);
        make.centerY.mas_equalTo(_titleLabel);
    }];
}

- (void)setModel:(ShanMealSubsideBosModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    _timeLabel.text = model.timePeriod;
    _awardLabel.text = model.awardIntegral;
    
    // 领取状态:  1 已领取  2 已过期  3 可领取  4 待领取
    NSString *receiveStatus = @"待领取";
    NSString *colorHex = @"#353B4E";
    if ([model.receiveStatus intValue] == 1) {
        receiveStatus = @"已领取";
        colorHex = @"#FF7E2D";
    } else if ([model.receiveStatus intValue] == 2) {
        receiveStatus = @"已过期";
        colorHex = @"#9A9A9A";
    } else if ([model.receiveStatus intValue] == 3) {
        receiveStatus = @"可领取";
        colorHex = @"#FD474D";
    } else if ([model.receiveStatus intValue] == 4) {
        receiveStatus = @"待领取";
        colorHex = @"#353B4E";
    }
    _receiveLabel.text = receiveStatus;
    _receiveLabel.textColor = [UIColor shan_colorWithHexString:colorHex];
}

+ (CGSize)shan_cellSize {
    return CGSizeMake(kSHANScreenWidth, 63);
}
@end
