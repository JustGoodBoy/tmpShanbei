//
//  SHANMyProfitViewController.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

/// 我的收益
#import "SHANMyProfitViewController.h"
#import "SHANNavigationView.h"
#import "SHANHeader.h"
#import "UIColor+SHANHexString.h"
#import "SHANAlertViewManager.h"
#import "SHANProfitView.h"
#import "SHANProfitRecordModel+HTTP.h"
#import "SHANAccountManager.h"
#import "SHANProfitListView.h"
#import "NSDictionary+SHAN.h"
#define profitViewHeight 142

@interface SHANMyProfitViewController ()

@property (nonatomic, strong) SHANProfitView *profitView;
@property (nonatomic, strong) SHANProfitListView *profitListView;
@property (nonatomic, strong) NSMutableArray *coinRecordArray;
@property (nonatomic, strong) NSMutableArray *cashRecordArray;
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation SHANMyProfitViewController

#pragma mark - LifeCycle(⽣命周期)
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.selectIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadProfit];
    [self getRecordData:self.selectIndex];
}

#pragma mark - UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor shan_colorWithHexString:@"FD5558"];
    
    SHANNavigationView *navigationView = [[SHANNavigationView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANStatusBarHeight + 40) title:@"我的收益"];
    [self.view addSubview:navigationView];
    navigationView.backgroundColor = UIColor.clearColor;
    [navigationView showRight];
    __weak typeof(self) weakself = self;
    navigationView.backClickBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    navigationView.explainClickBlock = ^{
        [[SHANAlertViewManager sharedManager] showAlertOfRule];
    };
    
    self.profitView = [[SHANProfitView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationView.frame), kSHANScreenWidth, profitViewHeight)];
    self.profitView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.profitView];
    
    _profitListView = [[SHANProfitListView alloc] initWithFrame:CGRectMake(0, profitViewHeight + kSHANStatusBarHeight + 40, kSHANScreenWidth, kSHANScreenHeight - (profitViewHeight + kSHANStatusBarHeight + 40))];
    _profitListView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_profitListView];
    [self profitListMethod];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_profitListView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _profitListView.bounds;
    maskLayer.path = maskPath.CGPath;
    _profitListView.layer.mask = maskLayer;
    
}

#pragma mark - Private(私有⽅法)
- (void)reloadProfit {
    [_profitView shanReloadProfit];
}

- (void)getRecordData:(SHANRecordType)type {
    __weak typeof(self) weakself = self;
    [SHANProfitRecordModel shanGetCoinRecordWithType:type success:^(id  _Nonnull data) {
        NSArray *array = (NSArray *)data;
        if (type == SHANRecordTypeCoin) {
            weakself.profitListView.coinArray = [array mutableCopy];
        }
        if (type == SHANRecordTypeCash) {
            weakself.profitListView.cashArray = [array mutableCopy];
        }
        
    } failure:^(NSString * _Nonnull errorMessage) {
        
    }];
}

- (void)profitListMethod {
    __weak typeof(self) weakself = self;
    _profitListView.clickProfitRecordBlock = ^(NSInteger index) {
        weakself.selectIndex = index;
        [weakself getRecordData:index];
    };
}

@end
