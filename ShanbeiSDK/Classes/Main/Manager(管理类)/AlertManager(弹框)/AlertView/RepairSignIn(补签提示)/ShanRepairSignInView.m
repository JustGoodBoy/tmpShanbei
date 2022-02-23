//
//  ShanRepairSignInView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/21.
//

#import "ShanRepairSignInView.h"
#import "SHANCommonUIHeader.h"
#import "ShanRepairSignInCollectionView.h"
#import "ShanSignedModel.h"
#import "NSString+SHAN.h"
@interface ShanRepairSignInView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) ShanRepairSignInCollectionView *collectionView;
@end

@implementation ShanRepairSignInView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight);
    bgView.backgroundColor = [UIColor shan_colorWithHexString:@"000000" alphaComponent:0.8 ];
    [self addSubview:bgView];
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [bgView addGestureRecognizer:tapG];
    
    CGFloat W = 335;
    CGFloat H = 408;
    UIImageView *bgImageView = [UIImageView new];
    UIImage *image = [UIImage SHANImageNamed:@"shan_repair_sign_in_bg" className:[self class]];
    bgImageView.userInteractionEnabled = YES;
    bgImageView.image = image;
    [bgView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView);
        make.centerY.mas_equalTo(bgView).offset(-16*kSHANScreenW_Radius);
        make.size.mas_equalTo(CGSizeMake(W, H));
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor shan_colorWithHexString:@"#FEF3BC"];
    _titleLabel.font = [UIFont shan_PingFangMediumFont:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.top.mas_equalTo(32);
    }];
    
    _collectionView = [[ShanRepairSignInCollectionView alloc] initWithFrame:CGRectMake(0, 93, W, 195)];
    _collectionView.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:_collectionView];
    
    UIImage *repairBtnImg = [UIImage SHANImageNamed:@"shan_repair_sign_in_btn" className:[self class]];
    UIButton *repairBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    repairBtn.adjustsImageWhenHighlighted = NO;
    [repairBtn setImage:repairBtnImg forState:UIControlStateNormal];
    [repairBtn addTarget:self action:@selector(repairBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:repairBtn];
    [repairBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.bottom.mas_equalTo(-24);
        make.size.mas_equalTo(CGSizeMake(310, 57));
    }];
    
    _tipsLabel = [UILabel new];
    _tipsLabel.text = @"完成补签及今日任务，预估今日收益5000积分";
    _tipsLabel.font = [UIFont shan_PingFangRegularFont:13];
    [bgImageView addSubview:_tipsLabel];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.bottom.mas_equalTo(repairBtn.mas_top).offset(-16);
    }];
    
    // 关闭
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.adjustsImageWhenHighlighted = NO;
    [closeBtn setImage:[UIImage SHANImageNamed:@"shan_icon_alert_close_alpha" className:[self class]] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bgImageView.mas_top).offset(-8);
        make.right.mas_equalTo(bgImageView);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
}

- (void)shan_showAlert:(ShanSignedModel *)model {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _collectionView.dataList = [model.signInTaskBos mutableCopy];
    _titleLabel.text = [NSString stringWithFormat:@"您已漏签%@日",model.unSignDays];
    NSMutableAttributedString *tips = [model.signCopy getAttributedString:[UIColor shan_colorWithHexString:@"#A0715A"] highLightColor:[UIColor shan_colorWithHexString:@"#FD3D45"] font:[UIFont shan_PingFangRegularFont:13]];
    _tipsLabel.attributedText = tips;
}

#pragma mark - Action
/// 关闭
- (void)closeAction {
    [self removeFromSuperview];
}

- (void)repairBtnAction {
    [self removeFromSuperview];
    if (_clickRepairBlock) _clickRepairBlock();
}

@end
