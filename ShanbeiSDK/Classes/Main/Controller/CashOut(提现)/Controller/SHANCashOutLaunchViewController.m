//
//  SHANCashOutLaunchViewController.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/22.
//

/// 提现发起
#import "SHANCashOutLaunchViewController.h"
#import "SHANNavigationView.h"
#import "SHANHeader.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
#import "UIImage+SHAN.h"
#import "SHANControlManager.h"

@implementation SHANCashOutLaunchViewController

#pragma mark - LifeCycle(⽣命周期)
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    SHANNavigationView *navigationView = [[SHANNavigationView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANStatusBarHeight + 40) title:@"提现发起"];
    [self.view addSubview:navigationView];
    navigationView.backgroundColor = [UIColor whiteColor];
    navigationView.isWhiteBackground = YES;
    __weak typeof(self) weakself = self;
    navigationView.backClickBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
    UIImageView *checkedImgView = [[UIImageView alloc] init];
    checkedImgView.frame = CGRectMake((kSHANScreenWidth - 64)/2, CGRectGetMaxY(navigationView.frame) + 32, 64, 64);
    checkedImgView.image = [UIImage SHANImageNamed:@"shan_checked" className:[self class]];
    [self.view addSubview:checkedImgView];
    
    UILabel *checkedLabel = [[UILabel alloc] init];
    checkedLabel.frame = CGRectMake(51, CGRectGetMaxY(checkedImgView.frame) + 24, kSHANScreenWidth - 102, 22);
    checkedLabel.text = @"提现申请提交成功";
    checkedLabel.textAlignment = NSTextAlignmentCenter;
    checkedLabel.font = [UIFont shan_PingFangMediumFont:16];
    checkedLabel.textColor = [UIColor shan_colorWithHexString:@"#333333"];
    [self.view addSubview:checkedLabel];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.frame = CGRectMake(51, CGRectGetMaxY(checkedLabel.frame) + 12, kSHANScreenWidth - 102, 56);
    tipsLabel.numberOfLines = 0;
    tipsLabel.lineBreakMode = NSLineBreakByClipping;
    tipsLabel.text = @"正在为您处理，提现高峰期到账可能有一定延迟,请您耐心等待";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont shan_PingFangRegularFont:14];
    tipsLabel.textColor = [UIColor shan_colorWithHexString:@"#999999"];
    [self.view addSubview:tipsLabel];
    
    UIButton *backHomeBtn = [[UIButton alloc] init];
    backHomeBtn.frame = CGRectMake(51, CGRectGetMaxY(tipsLabel.frame) + 80, kSHANScreenWidth - 102, 48);
    backHomeBtn.layer.cornerRadius = 24;
    backHomeBtn.layer.masksToBounds = YES;
    backHomeBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:16];
    backHomeBtn.backgroundColor = [UIColor shan_colorWithHexString:@"#FF655C"];
    [backHomeBtn setTitle:@"返回主页" forState:UIControlStateNormal];
    [backHomeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.view addSubview:backHomeBtn];
    [backHomeBtn addTarget:self action:@selector(backHomeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *recordBtn = [[UIButton alloc] init];
    recordBtn.frame = CGRectMake((kSHANScreenWidth - 70)/2, CGRectGetMaxY(backHomeBtn.frame) + 15, 70, 30);
    recordBtn.titleLabel.font = [UIFont shan_PingFangRegularFont:14];
    recordBtn.backgroundColor = [UIColor whiteColor];
    [recordBtn setTitle:@"查看记录" forState:UIControlStateNormal];
    [recordBtn setTitleColor:[UIColor shan_colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self.view addSubview:recordBtn];
    [recordBtn addTarget:self action:@selector(recordBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Action
- (void)backHomeBtnAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)recordBtnAction {
    [SHANControlManager openMyProfitViewController];
}

@end
