//
//  SHANInviteCollectionViewCell.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/10/26.
//

#import "SHANInviteCollectionViewCell.h"
#import "SHANHeader.h"
#import "UIColor+SHANHexString.h"
#import "UIButton+SHAN.h"
#import "UIImage+SHAN.h"
#import "UIFont+SHAN.h"
#import "SHANInviteModel.h"
@interface SHANInviteCollectionViewCell()
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation SHANInviteCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _iconBtn.adjustsImageWhenHighlighted = NO;
    _iconBtn.frame = CGRectMake(0, 0, 50*kSHANScreenW_Radius, 62);
    _iconBtn.backgroundColor = [UIColor clearColor];
    _iconBtn.titleLabel.font = [UIFont shan_PingFangRegularFont:11];
    [_iconBtn setTitleColor:[UIColor shan_colorWithHexString:@"#A0715A"] forState:UIControlStateNormal];
    [self.contentView addSubview:_iconBtn];
    
    
    UIImage *noInviteIcon = [UIImage SHANImageNamed:@"shan_icon_noInvite" className:[self class]];
    [_iconBtn setImage:noInviteIcon forState:UIControlStateNormal];
    [_iconBtn setTitle:@"可领1元" forState:UIControlStateNormal];
    [_iconBtn shan_verticalImageAndTitle:6];
}

- (void)setInfoWithModel:(SHANInviteItem *)model isInvited:(BOOL)isInvited {
    if (isInvited) {
        UIImage *inviteIcon = [UIImage SHANImageNamed:@"shan_icon_coin" className:[self class]];
        [_iconBtn setImage:inviteIcon forState:UIControlStateNormal];
        [_iconBtn setTitle:@"已领取" forState:UIControlStateNormal];
        [_iconBtn setTitleColor:[UIColor shan_colorWithHexString:@"#FF8900"] forState:UIControlStateNormal];
    } else {
        NSString *btnTxt = kSHANStringIsEmpty(model.content) ? @"可领1元" : model.content;
        UIImage *noInviteIcon = [UIImage SHANImageNamed:@"shan_icon_noInvite" className:[self class]];
        [_iconBtn setImage:noInviteIcon forState:UIControlStateNormal];
        [_iconBtn setTitle:btnTxt forState:UIControlStateNormal];
        [_iconBtn setTitleColor:[UIColor shan_colorWithHexString:@"#A0715A"] forState:UIControlStateNormal];
    }
    [_iconBtn shan_verticalImageAndTitle:6];
}

@end
