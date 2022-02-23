//
//  SHANInviteCodeView.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/10/26.
//

#import "SHANInviteCodeView.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
#import "UIView+SHAN.h"
#import "SHANHUD.h"
#import "SHANHeader.h"
@interface SHANInviteCodeView()
@property (nonatomic, strong) UIButton *reproduceBtn;
@property (nonatomic, copy) UILabel *contentLabel;
@end

@implementation SHANInviteCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _reproduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _reproduceBtn.frame = CGRectMake(self.width - 52, 7, 42, 18);
    _reproduceBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:13];
    [_reproduceBtn setTitle:@"复制" forState:UIControlStateNormal];
    [_reproduceBtn setTitleColor:[UIColor shan_colorWithHexString:@"#FD474D"] forState:UIControlStateNormal];
    [_reproduceBtn addTarget:self action:@selector(reproduceBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_reproduceBtn];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 7, self.width - 80, 18)];
    _contentLabel.textColor = [UIColor shan_colorWithHexString:@"#A0715A"];
    _contentLabel.font = [UIFont shan_PingFangRegularFont:13];
    _contentLabel.text = @"我的邀请码：";
    [self addSubview:_contentLabel];
}

- (void)setInviteCode:(NSString *)inviteCode {
    _inviteCode = inviteCode;
    if (kSHANStringIsEmpty(_inviteCode)) {
        return;
    }
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"我的邀请码：" attributes:@{
        NSFontAttributeName:[UIFont shan_PingFangRegularFont:13],
    }];
    NSAttributedString *code = [[NSAttributedString alloc] initWithString:_inviteCode attributes:@{
        NSFontAttributeName:[UIFont shan_PingFangMediumFont:13],
    }];
    [content appendAttributedString:code];
    _contentLabel.attributedText = content;
}

- (void)reproduceBtnAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.inviteCode;
    [SHANHUD showInfoWithTitle:@"复制成功"];
}

@end
