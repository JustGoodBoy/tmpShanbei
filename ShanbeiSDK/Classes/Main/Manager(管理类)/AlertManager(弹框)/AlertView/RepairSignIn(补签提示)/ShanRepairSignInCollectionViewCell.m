//
//  ShanRepairSignInCollectionViewCell.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/21.
//

#import "ShanRepairSignInCollectionViewCell.h"
#import "SHANCommonUIHeader.h"
#import "ShanSignedModel.h"
@interface ShanRepairSignInCollectionViewCell ()

@property (nonatomic, strong) UIImageView *bodyView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *coinLabel;
@end

@implementation ShanRepairSignInCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _bodyView = [UIImageView new];
    [self.contentView addSubview:_bodyView];
    [_bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo([ShanRepairSignInCollectionViewCell shan_cellSize]);
    }];
    
    _titleLabel = [UILabel new];
    [_bodyView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.centerX.mas_equalTo(_bodyView);
    }];
    
    UIImageView *coinImgView = [UIImageView new];
    coinImgView.image = [UIImage SHANImageNamed:@"shan_icon_repair_sign_in_coin" className:[self class]];
    [_bodyView addSubview:coinImgView];
    [coinImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(21);
        make.centerX.mas_equalTo(_bodyView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    _coinLabel = [UILabel new];
    _coinLabel.font = [UIFont shan_PingFangRegularFont:11];
    [_bodyView addSubview:_coinLabel];
    [_coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(coinImgView.mas_bottom).offset(-2);
        make.centerX.mas_equalTo(_bodyView);
    }];
}

- (void)setModel:(ShanSignInTaskBosModel *)model {
    BOOL isSignIn = [model.signStatus isEqualToString:@"1"];
    UIColor *bgColor = [UIColor shan_colorWithHexString:@"#FFFCF8"];
    if (isSignIn) {
        UIFont *signedFont = [UIFont shan_PingFangMediumFont:11];
        UIColor *signedColor = [UIColor whiteColor];
        bgColor = [UIColor shan_colorWithHexString:@"#FFBE00"];
        
        _titleLabel.font = signedFont;
        _titleLabel.textColor = signedColor;
        _coinLabel.textColor = signedColor;
        
        _titleLabel.text = @"已领";
    } else {
        UIFont *unSignedFont = [UIFont shan_PingFangRegularFont:11];
        UIColor *unSignedColor = [UIColor shan_colorWithHexString:@"#A0715A"];
        bgColor = [UIColor shan_colorWithHexString:@"#FFFCF8"];
        
        _titleLabel.font = unSignedFont;
        _titleLabel.textColor = unSignedColor;
        _coinLabel.textColor = unSignedColor;
        
        BOOL isRepair = [model.signStatus isEqualToString:@"0"];
        _titleLabel.text = isRepair ? @"可补签" : model.title;
    }
    _bodyView.image = [UIImage shan_imageViewWithRadius:6 color:bgColor];
    _coinLabel.text = model.awardCoin;
}

+ (CGSize)shan_cellSize {
    return CGSizeMake(68, 78);
}

@end
