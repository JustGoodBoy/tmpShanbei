//
//  SHANCashOutViewController.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

/// 提现
#import "SHANCashOutViewController.h"
#import "SHANNavigationView.h"
#import "SHANHeader.h"
#import "UIColor+SHANHexString.h"
#import "SHANCashOutView.h"
#import "SHANWXApiManager.h"
#import "WXApi.h"
#import "SHANWXUserInfoModel+HTTP.h"
#import "SHANCashOutModel+HTTP.h"
#import "SHANAdManager.h"
#import "SHANAccountManager.h"
#import "SHANAlertViewManager.h"
#import "NSDictionary+SHAN.h"
#import "SHANNoticeName.h"
#import "SHANControlManager.h"
#import "SHANHUD.h"
#import "SHANLoadingManager.h"
#import "ShanWithdrawalModel.h"
#import "SHANTaskModel+HTTP.h"
#import "SHANUserTaskModel.h"
#import "ShanReportTaskManager.h"
#import "ShanCashOutAttachTaskAlertView.h"
#import "SHANCashTaskAlertView.h"
#import "ShanClickReportModel.h"
#import "SHANAdvertisingPositionConfigModel.h"
@interface SHANCashOutViewController ()<SHANWXApiManagerDelegate>

@property (nonatomic, strong) SHANCashOutView *cashOutView;
@property (nonatomic, strong) NSMutableArray *taskList;
@end

@implementation SHANCashOutViewController

#pragma mark - LifeCycle(⽣命周期)
- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskList = [NSMutableArray new];
    [self setupUI];
    [self initupNotice];
    [SHANWXApiManager sharedManager].delegate = self;
    [self getTaskListData];
}
                    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self cashOutPageInfo];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor shan_colorWithHexString:@"FD5558"];
    SHANNavigationView *navigationView = [[SHANNavigationView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANStatusBarHeight + 40) title:@"提现"];
    [self.view addSubview:navigationView];
    navigationView.backgroundColor = [UIColor shan_colorWithHexString:@"FD5558"];
    __weak typeof(self) weakself = self;
    navigationView.backClickBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    _cashOutView = [[SHANCashOutView alloc] initWithFrame:CGRectMake(0, kSHANStatusBarHeight + 40, kSHANScreenWidth, kSHANScreenHeight - kSHANStatusBarHeight - 40)];
    [self.view addSubview:_cashOutView];
    _cashOutView.judgeFirstCashOutBlock = ^{
        // 查询提现次数
        [weakself requestUserWithdrawalTimes];
    };
}

#pragma mark - Notice
- (void)initupNotice {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmCashOut:) name:SHANCashOutPageDrawDepositNotification object:nil];
    // 首次提现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstCashOutAttachADTask) name:ShanFirstCashOutAttachADTaskFinishNotification object:nil];
}

#pragma mark - Private
- (void)showAttachView {
    ShanCashOutAttachTaskAlertView *view = [[ShanCashOutAttachTaskAlertView alloc] initWithFrame:self.view.bounds];
    [view shan_showAlert];
    __weak typeof(self) weakself = self;
    view.didNextStepAction = ^{
        [weakself todoHideCashOutTask];
    };
}

/// 去任务列表中找隐藏任务，并做任务
- (void)todoHideCashOutTask {
    SHANTaskModel *model = [self getTaskModelWithType:SHANTaskListTypeOfHideCashOut];
    NSArray *configArray = model.advertisingPositionConfig;
    if (kSHANArrayIsEmpty(configArray)) {
        [SHANHUD showInfoWithTitle:@"暂无广告"];
        return;
    }
    SHANAdvertisingPositionConfigModel *configModel = configArray.firstObject;
    [[SHANAdManager sharedManager] shanLoadRewardvodAdWithPosId:configModel.advertisingPositionId type:SHANTaskListTypeOfHideCashOut];
//    [[SHANAdManager sharedManager] shanLoadRewardvodAdWithPosId:@"b4a2ca550c29315749" type:SHANTaskListTypeOfHideCashOut];
}

#pragma mark - HTTP
/// 获取任务列表
- (void)getTaskListData {
    __weak typeof(self) weakself = self;
    [SHANTaskModel shanGetTaskOfSuccess:^(id  _Nonnull data) {
        NSArray *array = (NSArray *)data;
        weakself.taskList = [array mutableCopy];
    } failure:^(NSString * _Nonnull errorMessage) {
        
    }];
}

/// 获取提现页数据信息
- (void)cashOutPageInfo {
    __weak typeof(self) weakself = self;
    [SHANCashOutModel shanCashOutPageInfoOfSuccess:^(id  _Nonnull data) {
        SHANCashOutModel *model = data;
        weakself.cashOutView.cashOutModel = model;
        [SHANAccountManager sharedManager].cash = model.cash;
    } failure:^(NSString * _Nonnull errorMessage) {
        NSLog(@"errorMessage:%@",errorMessage);
    }];
}

/// 查询用户提现次数
- (void)requestUserWithdrawalTimes {
    SHANTaskModel *model = [self getTaskModelWithType:SHANTaskListTypeOfHideCashOut];
    if (!model.userTask.gain) {
        [self.cashOutView shan_cashOut];
        return;
    }
    __weak typeof(self) weakself = self;
    [ShanWithdrawalModel shan_withdrawalTimesOfSuccess:^(NSInteger times) {
        if (times == 0) {
            [weakself showAttachView];
        } else {
            [weakself.cashOutView shan_cashOut];
        }
        NSLog(@"提现次数：%ld",(long)times);
    } failure:^(NSString * _Nonnull errMsg) {
        [weakself showAttachView];
        NSLog(@"ShanWithdrawalModel errorMessage:%@",errMsg);
    }];
}


/// 根据任务类型获取任务model
- (SHANTaskModel *)getTaskModelWithType:(SHANTaskListType)type {
    for (SHANTaskModel *model in _taskList) {
        SHANUserTaskModel *userTaskModel = model.userTask;
        if ([userTaskModel.advertisingType integerValue] == type) {
            return model;
        }
    }
    return nil;
}

/// 绑定微信
- (void)bindWeChat:(NSString *)code {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params shanSetObjectSafely:code aKey:@"code"];
    
    __weak typeof(self) weakself = self;
    [SHANWXUserInfoModel shanBindWeChatWithParams:params success:^(id  _Nonnull data) {
        SHANWXUserInfoModel *model = data;
        [SHANAccountManager sharedManager].nickname = model.nickname;
        [SHANAccountManager sharedManager].headImgUrl = model.headimgurl;
        [[NSUserDefaults standardUserDefaults] setValue:model.openid forKey:@"SHANWXUserInfoOpenID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [weakself.cashOutView shanReloadAccountInfo];
    } failure:^(NSString * _Nonnull errorMessage) {
        NSLog(@"errorMessage:%@",errorMessage);
    }];
}

#pragma mark - Notice
/// 通知--提现
- (void)confirmCashOut:(NSNotification *)notification {
    NSString *drawMoneyId = [notification object];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params shanSetObjectSafely:drawMoneyId aKey:@"withdrawMoneyId"];
    
    [[SHANLoadingManager sharedManager] startAnimating];
    [SHANCashOutModel shanCashOutWithParams:params success:^(id  _Nonnull data) {
        [[SHANLoadingManager sharedManager] stopAnimating];
        [[SHANAlertViewManager sharedManager] disMissAlertOfCashOut];
        [SHANControlManager openCashOutLaunchViewController];
        NSLog(@"Message:%@",data);
    } failure:^(NSString * _Nonnull errorMessage) {
        [[SHANLoadingManager sharedManager] stopAnimating];
        [[SHANAlertViewManager sharedManager] disMissAlertOfCashOut];
        [SHANHUD showInfoWithTitle:errorMessage];
        NSLog(@"errorMessage:%@",errorMessage);
    }];
}

/// 看视频结束
- (void)firstCashOutAttachADTask {
    SHANTaskModel *model = [self getTaskModelWithType:SHANTaskListTypeOfHideCashOut];
    NSString *taskId = model.userTask.id_;
    [ShanReportTaskManager shanReportTaskWithType:SHANTaskListTypeOfHideCashOut taskId:taskId success:^(NSDictionary * _Nonnull dic) {
        NSDictionary *dataDic = [dic shanObjectOrNilForKey:@"data"];
        if (!kSHANDictIsEmpty(dataDic)) {
            NSString *awardCash = [NSString stringWithFormat:@"%@",[dataDic shanObjectOrNilForKey:@"awardCash"]];
            [self showAward:awardCash];
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        NSLog(@"%@",errorMessage);
#ifdef DEBUG
        [SHANHUD showInfoWithTitle:errorMessage];
#else
#endif
    }];
}

- (void)showAward:(NSString *)awardCash {
    SHANCashTaskAlertView *view = [[SHANCashTaskAlertView alloc] initWithFrame:self.view.bounds];
    NSString *content = [NSString stringWithFormat:@"+%@元 现金",awardCash];
    [view shan_showAlert:content];
    view.sureBtnTxt = @"开心收下";
    __weak typeof(self) weakself = self;
    view.didSureAction = ^{
        [weakself.cashOutView shan_cashOut];
    };
    view.didCloseAction = ^{
        [weakself.cashOutView shan_cashOut];
    };
}

#pragma mark - SHANWXApiManagerDelegate
- (void)shanManagerDidRecvAuthResponse:(SendAuthResp *)response {
    SendAuthResp *resp = response;
    NSLog(@"code:%@",resp.code);
    if (resp.code.length > 0){
        [self bindWeChat:resp.code];
    }
}

@end
