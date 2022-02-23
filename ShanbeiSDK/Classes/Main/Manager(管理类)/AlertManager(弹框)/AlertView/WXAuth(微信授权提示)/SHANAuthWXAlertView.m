//
//  SHANAuthWXAlertView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/22.
//

#import "SHANAuthWXAlertView.h"
#import "SHANHeader.h"
#import "UIImage+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
#import "UIView+SHANGetController.h"
#import "SHANWXApiManager.h"
@implementation SHANAuthWXAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGFloat bodyWidth = 283;
    CGFloat bodyHeight = 178;
    UIView *bodyView = [UIView new];
    bodyView.frame = CGRectMake((self.bounds.size.width - bodyWidth)/2.0, (self.bounds.size.height - bodyHeight)/2.0, bodyWidth, bodyHeight);
    bodyView.backgroundColor = [UIColor whiteColor];
    bodyView.layer.cornerRadius = 16;
    bodyView.layer.masksToBounds = YES;
    [self addSubview:bodyView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(0, 32, bodyWidth, 18);
    titleLabel.text = @"授权微信后";
    titleLabel.font = [UIFont shan_PingFangMediumFont:15];
    titleLabel.textColor = [UIColor shan_colorWithHexString:@"333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bodyView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.frame = CGRectMake(0, 60, bodyWidth, 18);
    subTitleLabel.text = @"提现到您的微信钱包";
    subTitleLabel.font = [UIFont shan_PingFangMediumFont:15];
    subTitleLabel.textColor = [UIColor shan_colorWithHexString:@"333333"];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [bodyView addSubview:subTitleLabel];
    
    UIColor *mainColor = [UIColor shan_colorWithHexString:@"#FD5558"];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = [UIFont shan_PingFangRegularFont:14];
    cancelBtn.adjustsImageWhenHighlighted = NO;
    cancelBtn.frame = CGRectMake(30, 122, 100, 32);
    cancelBtn.layer.cornerRadius = 16;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = mainColor.CGColor;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:mainColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(closeBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:cancelBtn];
    
    UIButton *authBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    authBtn.titleLabel.font = [UIFont shan_PingFangRegularFont:14];
    authBtn.adjustsImageWhenHighlighted = NO;
    authBtn.frame = CGRectMake(153, 122, 100, 32);
    authBtn.layer.cornerRadius = 16;
    authBtn.layer.masksToBounds = YES;
    authBtn.backgroundColor = mainColor;
    [authBtn setTitle:@"去授权" forState:UIControlStateNormal];
    [authBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [authBtn addTarget:self action:@selector(authBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bodyView addSubview:authBtn];
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.adjustsImageWhenHighlighted = NO;
    closeBtn.frame = CGRectMake(CGRectGetMaxX(bodyView.frame) - 32, CGRectGetMinY(bodyView.frame) - 18 - 32, 32, 32);
    [closeBtn setImage:[UIImage SHANImageNamed:@"taskFinished_close" className:[self class]] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
}

- (void)closeBtnBtnAction {
    [self removeFromSuperview];
}

- (void)authBtnBtnAction {
    // 直接在UIWindow上添加不了UIAlertController；此处没有未安装微信提示；如果要，再添加
    [[SHANWXApiManager sharedManager] shanSendAuthRequestInViewController:self.viewController];
    [self closeBtnBtnAction];
}

@end
