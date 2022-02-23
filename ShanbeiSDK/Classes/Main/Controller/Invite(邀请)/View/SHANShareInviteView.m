//
//  SHANShareInviteView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/10/27.
//

#import "SHANShareInviteView.h"
#import "UIView+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
#import "SHANHeader.h"
#import "UIImage+SHAN.h"
#import "UIButton+SHAN.h"
#define platformViewHeight 125
#define btnBaseTag 2021

/// 分享面板
@interface SHANShareInviteView()
@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIView *shareView;
@end

@implementation SHANShareInviteView

- (instancetype)initWithShareInviteView {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.frame = [UIApplication sharedApplication].delegate.window.bounds;
    self.bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight)];
    self.bodyView.backgroundColor = [UIColor shan_colorWithHexString:@"#000000" alphaComponent:0.8];
    [self addSubview:self.bodyView];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlert)];
    [_bodyView addGestureRecognizer:tapGesture];
    
    _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kSHANScreenHeight, kSHANScreenWidth, platformViewHeight + kSHANTabBarHeight)];
    _shareView.backgroundColor = [UIColor whiteColor];
    [_bodyView addSubview:_shareView];
    
    UIView *platformView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _shareView.width, platformViewHeight)];
    platformView.backgroundColor = [UIColor shan_colorWithHexString:@"#F5F7FA"];
    [_shareView addSubview:platformView];
    
    NSArray *btnList = @[
        @{@"icon":@"shan_share_wechat_friend",@"name":@"微信好友"},
        @{@"icon":@"shan_share_wechat_moments",@"name":@"朋友圈"},
        @{@"icon":@"shan_share_facing_each_other",@"name":@"面对面扫码"}];
    CGFloat margin = (kSHANScreenWidth - 3*80)/4;
    for (int i = 0; i < 3; i++) {
        NSDictionary *dict = btnList[i];
        UIImage *image = [UIImage SHANImageNamed:dict[@"icon"] className:[self class]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = btnBaseTag + i;
        btn.adjustsImageWhenHighlighted = NO;
        btn.frame = CGRectMake(margin + i*(80 + margin), 22, 80, 80);
        btn.titleLabel.font = [UIFont shan_PingFangRegularFont:12];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitle:dict[@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor shan_colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [platformView addSubview:btn];
        [btn addTarget:self action:@selector(platformBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn shan_verticalImageAndTitle:16];
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake((_shareView.width - 100)/2, platformViewHeight, 100, 49);
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.titleLabel.font = [UIFont shan_PingFangRegularFont:15];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor shan_colorWithHexString:@"#9B9DA2"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:cancelBtn];
}

#pragma mark - public
//展示
- (void)showAlert {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.top = kSHANScreenHeight - kSHANTabBarHeight - platformViewHeight;
    }];
}

//隐藏
- (void)dismissAlert {
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.top = kSHANScreenHeight;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication].delegate.window removeFromSuperview];
        [self removeFromSuperview];
        [[UIApplication sharedApplication].delegate.window resignKeyWindow];
    }];
}

#pragma mark - Action
- (void)platformBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag - btnBaseTag;
    !self.sharePlatformBlock ? : self.sharePlatformBlock(tag);
    [self dismissAlert];
}

- (void)cancelBtnAction {
    [self dismissAlert];
}

@end
