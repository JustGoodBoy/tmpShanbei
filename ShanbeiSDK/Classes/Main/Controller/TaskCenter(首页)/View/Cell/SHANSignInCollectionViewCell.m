//
//  SHANSignInCollectionViewCell.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/10/25.
//

#import "SHANSignInCollectionViewCell.h"
#import "SHANHeader.h"
#import "SHANCommonUIHeader.h"
#import "ShanSignedModel.h"

#define itemWidth (32*kSHANScreenW_Radius)
#define itemHeight 80

@interface SHANSignInCollectionViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UIImageView *repairSignInImgView;
@end

@implementation SHANSignInCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor shan_colorWithHexString:@"#A0715A"];
    _titleLabel.font = [UIFont shan_PingFangRegularFont:11];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(9);
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    _icon = [[UIImageView alloc] init];
    _icon.image = [UIImage SHANImageNamed:@"taskCenter_unsignIn" className:[self class]];
    [self.contentView addSubview:_icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(31);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    _coinLabel = [UILabel new];
    _coinLabel.text = @"1000";
    _coinLabel.textAlignment = NSTextAlignmentCenter;
    _coinLabel.textColor = [UIColor shan_colorWithHexString:@"#A0715A"];
    _coinLabel.font = [UIFont shan_PingFangRegularFont:11];
    [self.contentView addSubview:_coinLabel];
    [_coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_icon.mas_bottom).offset(6);
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    
    UIImage *repairImg = [UIImage SHANImageNamed:@"shan_icon_repair_btn" className:self.class];
    _repairSignInImgView = [UIImageView new];
    _repairSignInImgView.userInteractionEnabled = YES;
    _repairSignInImgView.image = repairImg;
    [self.contentView addSubview:_repairSignInImgView];
    [_repairSignInImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 29));
    }];
    _repairSignInImgView.hidden = YES;
}

- (void)setSignInModel:(ShanSignInTaskBosModel *)model todaySignId:(NSString *)todaySignId{
    if (!model) return;
    UIColor *highLightColor = [UIColor shan_colorWithHexString:@"#FF8900"];
    UIColor *normalColor = [UIColor shan_colorWithHexString:@"A0715A"];
    //signStatus: 0 未签到  1 已签到 2 未到签到时间
    if ([model.signStatus isEqualToString:@"1"]) {
        _titleLabel.text = @"已领";
        _titleLabel.textColor = highLightColor;
        _coinLabel.textColor = highLightColor;
        [_icon setImage:[UIImage SHANImageNamed:@"shan_icon_coin" className:[self class]]];
        
        // 已签到，可翻倍
        if ([model.countdown integerValue] > 0) {
            _repairSignInImgView.hidden = NO;
            UIImage *multipleImg = [UIImage SHANImageNamed:@"shan_icon_multiple_btn" className:self.class];
            _repairSignInImgView.image = multipleImg;
            _titleLabel.text = @"";
        } else {
            _repairSignInImgView.hidden = YES;
        }
    } else if ([model.signStatus isEqualToString:@"2"]) {
        _titleLabel.text = model.title;
        _titleLabel.textColor = normalColor;
        _coinLabel.textColor = normalColor;
        [_icon setImage:[UIImage SHANImageNamed:@"taskCenter_unsignIn" className:[self class]]];
        _repairSignInImgView.hidden = YES;
    } else if ([model.signStatus isEqualToString:@"0"]) {
        _coinLabel.textColor = normalColor;
        _titleLabel.textColor = normalColor;
        [_icon setImage:[UIImage SHANImageNamed:@"taskCenter_unsignIn" className:[self class]]];
        /// 做一下处理，如果是是补签且今天，不显示补签按钮
        if ([todaySignId isEqualToString:model.signTaskId]) {
            _titleLabel.text = model.title;
            _repairSignInImgView.hidden = YES;
        } else {
            _titleLabel.text = @"";
            _repairSignInImgView.hidden = NO;
            UIImage *repairImg = [UIImage SHANImageNamed:@"shan_icon_repair_btn" className:self.class];
            _repairSignInImgView.image = repairImg;
        }
    }
}

- (void)setCoinLabelText:(NSString *)text {
    if (kSHANStringIsEmpty(text)) return;
    _coinLabel.text = text;
}

+ (CGSize)shan_cellSize {
    return CGSizeMake(40, 85);
}

@end
