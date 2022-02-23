//
//  ShanRepairSignInCollectionViewBigCell.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/21.
//

#import "ShanRepairSignInCollectionViewBigCell.h"
#import "SHANCommonUIHeader.h"
#import "ShanSignedModel.h"
@interface ShanRepairSignInCollectionViewBigCell ()

@property (nonatomic, strong) UIImageView *bodyView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *coinLabel;
@end

@implementation ShanRepairSignInCollectionViewBigCell

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
        make.size.mas_equalTo([ShanRepairSignInCollectionViewBigCell shan_cellSize]);
    }];
    
    _titleLabel = [UILabel new];
    [_bodyView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(12);
    }];
    
    UIImageView *coinImgView = [UIImageView new];
    coinImgView.image = [UIImage SHANImageNamed:@"shan_icon_repair_sign_in_coin" className:[self class]];
    [_bodyView addSubview:coinImgView];
    [coinImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-1);
        make.bottom.mas_equalTo(-1);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    _coinLabel = [UILabel new];
    _coinLabel.font = [UIFont shan_PingFangRegularFont:11];
    [_bodyView addSubview:_coinLabel];
    [_coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(2);
        make.left.mas_equalTo(12);
    }];
}

- (void)setModel:(ShanSignInTaskBosModel *)model {
    BOOL isSignIn = [model.signStatus isEqualToString:@"1"];
    UIColor *bgColor = [UIColor shan_colorWithHexString:@"#FFFCF8"];
    if (isSignIn) {
        UIFont *signedFont = [UIFont shan_PingFangMediumFont:13];
        UIColor *signedColor = [UIColor whiteColor];
        bgColor = [UIColor shan_colorWithHexString:@"#FFBE00"];
        
        _titleLabel.font = signedFont;
        _titleLabel.textColor = signedColor;
        _coinLabel.textColor = signedColor;
        
        _titleLabel.text = @"已领";
    } else {
        UIFont *unSignedFont = [UIFont shan_PingFangRegularFont:13];
        UIColor *unSignedColor = [UIColor shan_colorWithHexString:@"#A0715A"];
        bgColor = [UIColor shan_colorWithHexString:@"#FFFCF8"];
        
        _titleLabel.font = unSignedFont;
        _titleLabel.textColor = unSignedColor;
        _coinLabel.textColor = unSignedColor;
        
        BOOL isRepair = [model.signStatus isEqualToString:@"0"];
        _titleLabel.text = isRepair ? @"可补签" : model.title;
    }
    _bodyView.image = [UIImage shan_imageViewWithRadius:6 color:bgColor];
//    _coinLabel.text = model.awardCoin;
    _coinLabel.text = @"神秘大礼包";
}

+ (CGSize)shan_cellSize {
    return CGSizeMake(149, 78);
}

@end
