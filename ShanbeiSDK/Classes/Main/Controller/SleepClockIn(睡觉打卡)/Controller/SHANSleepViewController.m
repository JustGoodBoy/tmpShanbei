//
//  SHANSleepViewController.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/11/24.
//

#import "SHANSleepViewController.h"
#import "SHANSleepView.h"
#import "SHANShareInviteView.h"
#import "SHANWXApiManager.h"
#import "SHANControlManager.h"
#import "SHANSleepModel.h"
#import "SHANTimeStamp.h"
#import "ShanTimerManager.h"
#import "SHANHeader.h"
#import "NSDictionary+SHAN.h"
#import "SHANAlertViewManager.h"
#import "SHANAccountManager.h"
#import "SHANHUD.h"
#import "SHANNoticeName.h"
#import "SHANInviteModel+HTTP.h"
#import "SHANAdManager.h"
#import "SHANTaskModel.h"
#import "SHANUserTaskModel.h"
#import "SHANAdvertisingPositionConfigModel.h"
#import "ShanbeiManager.h"
@interface SHANSleepViewController ()
@property (nonatomic, strong) SHANSleepView *sleepView;
@property (nonatomic, assign) NSInteger timeLag;    // 刷新时间
@property (nonatomic, copy) NSString *taskRecordId; // 睡觉打卡记录ID
@property (nonatomic, copy) NSString *invitationCode;
@property (nonatomic, copy) NSString *downloadURL;
@end

@implementation SHANSleepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getSleepData];
    [self keepOnSleepTimer];
    [self addNotice];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getInvitationCode];
}

- (void)setupUI {
    _sleepView = [[SHANSleepView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_sleepView];
    __weak typeof(self) weakself = self;
    self.sleepView.clickBackBlock = ^{
        [weakself backAction];
    };
    self.sleepView.clickShareBlock = ^{
        [weakself shareAction];
    };
    self.sleepView.clickSleepBlock = ^{
        [weakself reoprtStartSleep];
    };
    self.sleepView.clickRewardBlock = ^{
        [weakself reoprtSleepTask];
    };
}

- (void)dealloc {
    NSLog(@"dealloc---");
}

#pragma mark - Private
- (void)addNotice{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAccountInfo) name:SHANReloadAccountIDNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shanTaskCenterAttachTaskWithTaskIDNotification:) name:SHANTaskCenterAttachTaskWithTaskIDNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shanSleepTaskFinishRewardvodAdTaskNotification:) name:SHANSleepTaskFinishRewardvodAdTaskNotification object:nil];
    
}

- (void)startSleepTimer {
    NSInteger unit = self.timeLag > 0 ? (self.timeLag) : (60*60);
    __weak typeof(self) weakself = self;
    [[ShanTimerManager sharedManager] shan_startSleepTimer];
    [ShanTimerManager sharedManager].sleepTimerBlock = ^(NSInteger duration) {
        [weakself.sleepView shan_reloadSleepBtn:duration];
        
        // 每个时间单位 都去刷新
        if (duration == unit || duration == unit*2 || duration == unit*3 || duration == unit*4
            || duration == unit*5 || duration == unit*6 || duration == unit*7 || duration == unit*8) {
            [weakself getSleepData];
        }
        
        // 8小时后重置
        if (duration > 3600*8) {
            [[ShanTimerManager sharedManager] shan_cancelSleepTimer];
            [SHANTimeStamp shan_clearSleepStartTimeStamp];
            [weakself.sleepView shan_renewSleepBtn];
        }
    };
}

/// 进入页面判断是否继续睡觉打卡
- (void)keepOnSleepTimer {
    self.timeLag = [SHANTimeStamp shan_getSleepTimeLag];
    if ([SHANTimeStamp shan_isHaveSleepStartTimeStamp]) {
        [self startSleepTimer];
    }
}

/// 是否需要登录
- (BOOL)isNeedLogin {
    if ([SHANAccountManager sharedManager].isLogin) {
        return false;
    } else {
        [SHANHUD showInfoWithTitle:@"未登录"];
        return true;
    }
}

#pragma mark - Notice
- (void)reloadAccountInfo {
    [self getInvitationCode];
}

- (void)shanTaskCenterAttachTaskWithTaskIDNotification:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    self.taskRecordId = [NSString stringWithFormat:@"%@",[dic shanObjectOrNilForKey:@"taskRecordId"]];
    NSArray *configArray = _hideSleepModel.advertisingPositionConfig;
    if (kSHANArrayIsEmpty(configArray)) {
        [SHANHUD showInfoWithTitle:@"暂无广告"];
        return;
    }
    SHANAdvertisingPositionConfigModel *configModel = configArray.firstObject;
    [[SHANAdManager sharedManager] shanLoadRewardvodAdWithPosId:configModel.advertisingPositionId type:SHANTaskListTypeOfHideSleep attachTaskID:self.taskRecordId];
}

/// 完成视频任务，发送的通知
- (void)shanSleepTaskFinishRewardvodAdTaskNotification:(NSNotification *)notification {
    [self reportHideSleepTask];
}

#pragma mark - Http
/// 获取睡觉打卡数据
- (void)getSleepData {
    NSLog(@"刷新睡觉数据");
    [SHANSleepModel shanGetSleepInfoWithTaskId:_sleepModel.userTask.id_ success:^(SHANSleepModel * _Nonnull model) {
        if (model) {
            self.timeLag = model.timeLag;
            self.sleepView.sleepModel = model;
            [SHANTimeStamp shan_saveSleepTimeLag:self.timeLag];
        }
        NSLog(@"刷新睡觉数据成功");
    } failure:^(NSString * _Nonnull errorMessage) {
        NSLog(@"刷新睡觉数据失败");
        NSLog(@"%@",errorMessage);
    }];
}

/// 开始打卡
- (void)reoprtStartSleep {
    if (![SHANAccountManager sharedManager].isLogin) {
        if ([ShanbeiManager shareManager].loginBlock) {
            [ShanbeiManager shareManager].loginBlock();
        }
        return;
    }
    [SHANSleepModel shanGetSleepStartWithTaskId:_sleepModel.userTask.id_ success:^(NSDictionary * _Nonnull dic) {
        NSLog(@"睡觉打卡任务开始");
        [self startSleepTimer];
    } failure:^(NSString * _Nonnull errorMessage) {
        [SHANTimeStamp shan_clearSleepStartTimeStamp];
        [SHANHUD showInfoWithTitle:errorMessage];
    }];
}

/// 完成睡觉任务，上报（领取积分）
- (void)reoprtSleepTask {
    [SHANSleepModel shanReportSleepTaskWithTaskId:_sleepModel.userTask.id_ success:^(NSDictionary * _Nonnull dic) {
        if (kSHANDictIsEmpty(dic)) return;
        [self getSleepData];
        self.taskRecordId = [dic shanObjectOrNilForKey:@"taskRecordId"];
        NSString *awardIntegral = [dic shanObjectOrNilForKey:@"awardIntegral"];
        [[SHANAlertViewManager sharedManager] showAlertOfSleepTask:awardIntegral attachTaskID:self.taskRecordId];
        NSLog(@"上报睡觉任务成功");
    } failure:^(NSString * _Nonnull errorMessage) {
        NSLog(@"上报睡觉任务失败");
        NSLog(@"%@",errorMessage);
        [SHANHUD showInfoWithTitle:@"领取失败"];
    }];
}

/// 睡觉打卡-领取奖励-追加任务上报
- (void)reportHideSleepTask {
    [SHANSleepModel shanReportHideSleepTaskWithTaskId:_hideSleepModel.userTask.id_
                                         taskRecordId:self.taskRecordId
                                              success:^(NSDictionary * _Nonnull dic) {
        NSDictionary *dataDict = [dic objectForKey:@"data"];
        if (kSHANDictIsEmpty(dataDict)) return;
        NSString *awardIntegral = [dataDict shanObjectOrNilForKey:@"awardIntegral"];
        [[SHANAlertViewManager sharedManager] showAlertOfHideSleepTask:awardIntegral];
        NSLog(@"%@",dic);
    } failure:^(NSString * _Nonnull errorMessage) {
        NSLog(@"%@",errorMessage);
        [SHANHUD showInfoWithTitle:errorMessage];
    }];
}

/// 获取邀请码
- (void)getInvitationCode {
    [SHANInviteModel shanGetInviteListSuccess:^(id  _Nonnull data) {
        SHANInviteModel *model = (SHANInviteModel *)data;
        self.downloadURL = model.url;
        self.invitationCode = model.invitationCode;
    } Failure:^(NSString * _Nonnull errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
}

#pragma mark - Acticon
- (void)backAction {
    [self back];
}

- (void)shareAction {
    if (![SHANAccountManager sharedManager].isLogin) {
        if ([ShanbeiManager shareManager].loginBlock) {
            [ShanbeiManager shareManager].loginBlock();
        }
        return;
    }
    
    SHANShareInviteView *shareView = [[SHANShareInviteView alloc] initWithShareInviteView];
    [shareView showAlert];
    NSString *url = self.downloadURL;
    NSString *code = self.invitationCode;
    shareView.sharePlatformBlock = ^(NSInteger index) {
        if (index == 0 || index == 1) {
            if ([[SHANWXApiManager sharedManager] shanIsWXAppInstalled]) {
                NSString *appName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
                NSString *shareText = [NSString stringWithFormat:@"我在用这款%@APP：\n每天躺着睡觉就能赚钱！\n下载安装后填我邀请码\n%@\n即可领取现金红包，每天可提现\n下载地址：%@",appName,code,url];
                [[SHANWXApiManager sharedManager] shanShareWithText:shareText scene:index];
            } else {
                [[SHANWXApiManager sharedManager] shanUninstalledWXAppTips:self];
            }
        }
        if (index == 2) {
            [SHANControlManager openFaceToFaceViewController];
        }
    };
}

@end
