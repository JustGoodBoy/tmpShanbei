//
//  SHANTaskCenterViewController.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/15.
//

/// 任务中心
#import "SHANTaskCenterViewController.h"
#import "SHANCommentManager.h"
#import "SHANHeader.h"
#import "SHANTaskCenterView.h"
#import "SHANTaskModel+HTTP.h"
#import "UIDevice+SHAN.h"
#import "UIImage+SHAN.h"
#import "SHANAdManager.h"
#import "SHANAccountManager.h"
#import "SHANNoticeName.h"
#import "SHANUserAccountModel+HTTP.h"
#import "SHANAccountManager.h"
#import "NSDictionary+SHAN.h"
#import "SHANSignInModel+HTTP.h"
#import "SHANHUD.h"
#import "SHANUserTaskModel.h"
#import "SHANAlertViewManager.h"
#import "SHANControlManager.h"
#import "SHANInviteModel+HTTP.h"
#import "ShanReportTaskManager.h"
#import "SHANTimeStamp.h"
#import "YYModel.h"
#import "ShanTimerManager.h"
#import "SHANAdvertisingPositionConfigModel.h"
#import "SHANNewUserTaskView.h"
#import "UIColor+SHANHexString.h"
#import "ShanSignedModel.h"
#import "NSString+HHMMSS.h"
#import "SHANCashTaskAlertView.h"
#import "ShanAttachTaskAgainAlertView.h"
#import "ShanClickReportModel.h"
@interface SHANTaskCenterViewController ()

@property (nonatomic, strong) SHANTaskCenterView *taskCenterView;

@property (nonatomic, strong) NSMutableArray *taskArray;
/// 任务列表，原数据，因为有隐藏任务（签到 追加视频任务）
@property (nonatomic, strong) NSMutableArray *originalTaskArray;
/// 任务类型
@property (nonatomic,assign) SHANTaskListType taskType;
/// 签到model
@property (nonatomic, strong) ShanSignedModel *signedModel;
/// 补签Id
@property (nonatomic, copy) NSString *repairSignInID;
/// 本轮宝箱追加任务是否做过
@property (nonatomic, assign) ShanBoxTaskState boxTaskState;

/// 是否离开当前vc
@property (nonatomic, assign) BOOL isLeaveVC;
@end

@implementation SHANTaskCenterViewController

#pragma mark -  LifeCycle (生命周期)
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initupData];
    [self setupUIView];
    [self initupNotice];
    [self getSignInListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isLeaveVC = NO;
    [self getTaskData];
    [self getUserAccountInfo];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.isLeaveVC = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
- (void)setupUIView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat height = kSHANScreenHeight;
    if ([SHANCommentManager sharedCommentMark].showType == SHANShowViewControllerTypeTabbar || [SHANCommentManager sharedCommentMark].showType == SHANShowViewControllerTypeNavTabbar) {
        height = kSHANScreenHeight - kSHANTabBarHeight;
    }
    _taskCenterView = [[SHANTaskCenterView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, height)];
    __weak typeof(self) weakSelf = self;
    _taskCenterView.inviteFriendBlock = ^(NSString * _Nonnull code, NSString * _Nonnull taskId) {
        [weakSelf invitationFriendWithCode:code TaskId:taskId];
    };
    _taskCenterView.didTaskTypeBlock = ^(SHANTaskListType type) {
        weakSelf.taskType = type;
    };
    _taskCenterView.reportTaskBlock = ^(SHANTaskListType type) {
        // 待扩展，可能后期要使用到其他任务
        if (type == SHANTaskListTypeOfBox) {
            weakSelf.taskType = type;
            [weakSelf reportRoutineTask:SHANTaskListTypeOfBox];
        }
        if (type == SHANTaskListTypeOfSleep) {
            weakSelf.taskType = type;
            [weakSelf openSleepViewController];
        }
        if (type == SHANTaskListTypeOfEat) {
            weakSelf.taskType = type;
            [weakSelf openEatViewController];
        }
    };
    [self.view addSubview:_taskCenterView];
    
    /// 给宝箱添加点击事件
    _taskCenterView.boxImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTaskBoxAction)];
    [singleTap setNumberOfTapsRequired:1];
    [_taskCenterView.boxImgView addGestureRecognizer:singleTap];
    
    if (self.isShowNavBack) {
        [self setupBackBtn];
    }
}

- (void)setupBackBtn {
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(16, kSHANStatusBarHeight + 7, 25, 25);
    backButton.adjustsImageWhenHighlighted = NO;
    [backButton setImage:[UIImage SHANImageNamed:@"nav_icon_white_back" className:[self class]] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

#pragma mark - Private(私有⽅法)
- (void)initupData {
    self.taskArray = [[NSMutableArray alloc] init];
    self.originalTaskArray = [[NSMutableArray alloc] init];
    [[SHANAdManager sharedManager] shanSetAdSDKConfigure];
}

- (void)initupNotice {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTaskData) name:SHANReloadAccountIDNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shanTaskCenterFinishRewardvodAdTaskNotification:) name:SHANTaskCenterFinishRewardvodAdTaskNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInTask:) name:SHANTaskCenterSignInTaskNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shanTaskCenterAttachTaskNotification:) name:SHANTaskCenterAttachTaskNotification object:nil];
}

/// 完成好友邀请任务
- (void)finishedInviteFriendTask:(NSString *)awardCash {
    NSString *reward = awardCash;
    if (kSHANStringIsEmpty(reward)) {
        reward = @"1";
    }
    [[SHANAlertViewManager sharedManager] showAlertOfTaskFinishedWithReward:reward taskType:SHANTaskTypeOfCashRMB];
}

/// 重置
- (void)initReloadRewardInfo {
    [SHANAccountManager sharedManager].coin = @"0";
    [SHANAccountManager sharedManager].cash = @"0";
    [self.taskCenterView shanReloadRewardInfo];
}

/// 根据任务类型从任务列表中获取 任务model
- (SHANTaskModel *)getTaskModelWithType:(SHANTaskListType)type {
    for (SHANTaskModel *model in _originalTaskArray) {
        SHANUserTaskModel *userTaskModel = model.userTask;
        if ([userTaskModel.advertisingType integerValue] == type) {
            return model;
        }
    }
    return nil;
}

/// 接口上报完成后，领取奖励
- (void)receiveRewards:(NSDictionary *)dataDic {
    SHANTaskModel *model = [self getTaskModelWithType:self.taskType];
    switch (self.taskType) {
        case SHANTaskListTypeOfHideRewardVideo: // 看视频（广告）赚积分任务-追加任务奖励
        {
            self.taskCenterView.videoTaskState = ShanVideoTaskState_Done;
            [[SHANAlertViewManager sharedManager] showAlertOfTaskFinishedWithReward:model.userTask.awardIntegral taskType:SHANTaskTypeOfCoin];
        }
            break;
        case SHANTaskListTypeOfHideBox: // 宝箱任务-追加任务奖励
        {
            if ([self.taskCenterView.boxImgView.timeLabel.text isEqualToString:@"点击领取"]) {
                self.boxTaskState = ShanBoxTaskState_Normal;
            } else {
                self.boxTaskState = ShanBoxTaskState_Done;
            }
            [[SHANAlertViewManager sharedManager] showAlertOfTaskFinishedWithReward:model.userTask.awardIntegral taskType:SHANTaskTypeOfCoin];
        }
            break;
        case SHANTaskListTypeOfHideSign: // 签到任务-追加任务奖励
        {
            [[SHANAlertViewManager sharedManager] showAlertOfTaskFinishedWithReward:[dataDic shanObjectOrNilForKey:@"data"] taskType:SHANTaskTypeOfCoin];
            
        }
            break;
        case SHANTaskListTypeOfRewardVideo: // 看视频（广告）赚积分奖励
        {
            SHANTaskModel *attachModel = [self getTaskModelWithType:SHANTaskListTypeOfHideRewardVideo];
            // 如果该任务对应的追加任务，是可执行状态，就追加显示任务；不可，就不显示
            if (attachModel.userTask.gain) {
                [[SHANAlertViewManager sharedManager] showAlertOfAttachTaskWithcoin:model.userTask.awardIntegral attachCoin:attachModel.userTask.awardIntegral attachTask:SHANTaskListTypeOfHideRewardVideo];
            } else {
                [[SHANAlertViewManager sharedManager] showAlertOfTaskFinishedWithReward:model.userTask.awardIntegral taskType:SHANTaskTypeOfCoin];
            }
            self.taskCenterView.videoTaskState = ShanVideoTaskState_NotDone;
            [self.taskCenterView shan_rewardCountDown:600];
        }
            break;
        case SHANTaskListTypeOfCash: // 现金领取任务奖励
        {
            if (!kSHANDictIsEmpty(dataDic)) {
                NSString *awardCash = [NSString stringWithFormat:@"%@",[dataDic shanObjectOrNilForKey:@"awardCash"]];
//                [[SHANAlertViewManager sharedManager] showAlertOfCashTask:awardCash];
                
                SHANCashTaskAlertView *view = [[SHANCashTaskAlertView alloc] initWithFrame:self.view.bounds];
                NSString *content = [NSString stringWithFormat:@"+%@元 现金",awardCash];
                [view shan_showAlert:content];
                view.sureBtnTxt = @"去提现";
                view.didSureAction = ^{
                    [SHANControlManager openCashOutViewController];
                };
                
                [[ShanTimerManager sharedManager] shan_cancelCashTimer];
            }
        }
            break;
        case SHANTaskListTypeOfBox: // 宝箱任务奖励
        {
            if (!kSHANDictIsEmpty(dataDic)) {
                [self boxTaskStartTimer:[[dataDic shanObjectOrNilForKey:@"timeLag"] integerValue]];
                
                SHANTaskModel *attachModel = [self getTaskModelWithType:SHANTaskListTypeOfHideBox];
                NSString *awardCoin = [dataDic shanObjectOrNilForKey:@"awardIntegral"];
                if (attachModel.userTask.gain) {
                    NSString *attachCoin = kSHANStringIsEmpty(attachModel.userTask.awardIntegral) ? @"" : attachModel.userTask.awardIntegral;
                    [[SHANAlertViewManager sharedManager] showAlertOfBoxTaskWithcoin:awardCoin attachCoin:attachCoin];
                } else {
                    [[SHANAlertViewManager sharedManager] showAlertOfTaskFinishedWithReward:awardCoin taskType:SHANTaskTypeOfCoin];
                }
                /// 上报宝箱任务成功后，将宝箱状态设置为未领取追加奖励
                self.boxTaskState = ShanBoxTaskState_NotDone;
            }
        }
            break;
        default:
            break;
    }
}

/// 根据任务类型，看追加任务的视频
- (void)didAttachTask:(SHANTaskListType)type {
    SHANTaskModel *model = [self getTaskModelWithType:type];
    NSArray *configArray = model.advertisingPositionConfig;
    if (kSHANArrayIsEmpty(configArray)) {
        [SHANHUD showInfoWithTitle:@"暂无广告"];
        return;
    }
    SHANAdvertisingPositionConfigModel *configModel = configArray.firstObject;
    [[SHANAdManager sharedManager] shanLoadRewardvodAdWithPosId:configModel.advertisingPositionId type:type];
}


/// 宝箱倒计时
- (void)boxTaskStartTimer:(NSInteger)timeLag {
    NSInteger duration = timeLag * 60;
    [[ShanTimerManager sharedManager] shan_startBoxTimerWith:duration];
    [ShanTimerManager sharedManager].boxCountDownBlock = ^(NSInteger countdown) {
        if (countdown > 0) {
            self.taskCenterView.boxImgView.timeLabel.text = [NSString shan_getMMSSFromSS:countdown];
        } else {
            self.boxTaskState = ShanBoxTaskState_Normal;
            self.taskCenterView.boxImgView.timeLabel.text = @"点击领取";
        }
    };
}

/// 提示老用户奖励
- (void)tipsOldUserAward {
    SHANTaskModel *model = [self getTaskModelWithType:SHANTaskListTypeOfCash];
    if ([[ShanbeiManager shareManager] isLogin] && !model.userTask.gain && [SHANNewUserTaskView shan_isClickNewUserRedPacketState] && !self.isLeaveVC) {
        [SHANNewUserTaskView shan_saveClickNewUserRedPacketState:NO];
        [SHANHUD showInfoWithTitle:@"您已领过新人奖励，本轮奖励不再发放！"];
    }
}

#pragma mark - Notification(通知⽅法)
/// 刷新 账户信息、任务信息、签到信息
- (void)reloadTaskData {
    [self getTaskData];
    [self getSignInListData];
    [self getUserAccountInfo];
}

/// 完成广告视频通知
- (void)shanTaskCenterFinishRewardvodAdTaskNotification:(NSNotification *)notification {
    if (!kSHANStringIsEmpty(self.repairSignInID) && self.taskType == SHANTaskListTypeOfHideSign) {
        [self signIn:self.repairSignInID];
        return;
    }
    self.repairSignInID = @"";
    [self reportRoutineTask:self.taskType];
}

/// 追加任务（隐藏任务）- 去做视频任务
- (void)shanTaskCenterAttachTaskNotification:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSInteger type = [[dic shanObjectOrNilForKey:@"taskType"] integerValue];
    self.taskType = type;   // 修改当前任务类型
    [self didAttachTask:type];
}

/// 签到
- (void)signInTask:(NSNotification *)notification {
    self.repairSignInID = @"";
    NSDictionary *dic = notification.userInfo;
    NSString *signInTaskId = [dic shanObjectOrNilForKey:@"signInTaskId"];
    
    // 需要签到的任务ID如果不是今天，就是补签,需要先看视频，再补签
    if (![signInTaskId yy_modelIsEqual:_signedModel.todaySignId]) {
        // 记录需要补签的id
        self.repairSignInID = signInTaskId;
        self.taskType = SHANTaskListTypeOfHideSign;
        [self didAttachTask:self.taskType];
        return;
    }
    [self signIn:signInTaskId];
}

#pragma mark - Action
- (void)backBtnAction {
    [self back];
}

/// 睡觉页面
- (void)openSleepViewController {
    SHANTaskModel *model = [self getTaskModelWithType:SHANTaskListTypeOfSleep];
    SHANTaskModel *hideModel = [self getTaskModelWithType:SHANTaskListTypeOfHideSleep];
    [SHANControlManager openSleepViewControllerWithSleepModel:model hideSleepModel:hideModel];
}

/// 吃饭页面
- (void)openEatViewController {
    SHANTaskModel *model = [self getTaskModelWithType:SHANTaskListTypeOfEat];
    [SHANControlManager openEatViewController:model];
}

/// 宝箱点击
- (void)clickTaskBoxAction {
    [ShanClickReportModel shanClickReport:ShanClickTypeOfTreasureChest];
    if (self.boxTaskState == ShanBoxTaskState_Normal) {// 正常
        [_taskCenterView clickTaskBoxAction];
    } else if (self.boxTaskState == ShanBoxTaskState_NotDone) { // 未看过追加视频
        if (![SHANAccountManager sharedManager].isLogin) return;
        SHANTaskModel *attachModel = [self getTaskModelWithType:SHANTaskListTypeOfHideBox];
        NSString *attachAward = [NSString stringWithFormat:@"看视频再领%@积分",attachModel.userTask.awardIntegral];
        
        ShanAttachTaskAgainAlertView *view = [[ShanAttachTaskAgainAlertView alloc] initWithFrame:self.view.bounds];
        [view shan_showAlert];
        view.titleTxt = @"本轮奖励已领取哦!";
        view.sureBtnTxt = attachAward;
        view.didSureAction = ^{
            self.taskType = SHANTaskListTypeOfHideBox;
            [self didAttachTask:self.taskType]; // 继续追加视频
        };
    }
}

#pragma mark - HTTP
/// 获取用户账户信息
- (void)getUserAccountInfo {
    if (![SHANAccountManager sharedManager].isLogin) {
        [self initReloadRewardInfo];
        return;
    }
    __weak typeof(self) weakself = self;
    [SHANUserAccountModel shanGetUserAccountInfoOfSuccess:^(id  _Nonnull data) {
        if (![SHANAccountManager sharedManager].isLogin) {
            [weakself initReloadRewardInfo];
            return;
        }
        SHANUserAccountModel *model = data;
        [SHANAccountManager sharedManager].coin = model.coin ? model.coin : @"0";
        [SHANAccountManager sharedManager].cash = model.cash ? model.cash : @"0";
        [weakself.taskCenterView shanReloadRewardInfo];
        
    } failure:^(NSString * _Nonnull errorMessage) {
        NSLog(@"errorMessage:%@",errorMessage);
        [weakself initReloadRewardInfo];
    }];
}

/// 获取任务列表
- (void)getTaskData {
    __weak typeof(self) weakself = self;
    [SHANTaskModel shanGetTaskOfSuccess:^(id  _Nonnull data) {
        NSArray *array = (NSArray *)data;
        weakself.originalTaskArray = [array mutableCopy];
        weakself.taskCenterView.taskArray = weakself.originalTaskArray;
        [weakself tipsOldUserAward];
    } failure:^(NSString * _Nonnull errorMessage) {
        
    }];
}

/// 获取签到列表
- (void)getSignInListData {
    __weak typeof(self) weakself = self;
    [ShanSignedModel shan_requestSignInListWithSuccess:^(ShanSignedModel * _Nonnull model) {
        weakself.signedModel = model;
        weakself.taskCenterView.signInView.signedModel = model;
    } failure:^(NSString * _Nonnull errMsg) {
        weakself.taskCenterView.signInView.signedModel = [ShanSignedModel new];
        NSLog(@"errorMessage:%@",errMsg);
    }];
}

/// 签到
- (void)signIn:(NSString *)signTaskId {
    __weak typeof(self) weakself = self;
    [ShanSignedModel shan_requestSignInWithId:signTaskId success:^(ShanSignInTaskBosModel * _Nonnull model) {
        // 从_signedModel获取今日id对应的签到奖励
        NSString *firstCoin = @"";
        for (ShanSignInTaskBosModel *taskBosModel in weakself.signedModel.signInTaskBos) {
            if ([taskBosModel.signTaskId isEqualToString:signTaskId]) {
                firstCoin = taskBosModel.awardCoin;
                break;
            }
        }
        
        if (!kSHANStringIsEmpty(self.repairSignInID)) { // 补签
            [[SHANAlertViewManager sharedManager] showAlertOfTaskFinishedWithReward:firstCoin taskType:SHANTaskTypeOfCoin];
        } else {
            [[SHANAlertViewManager sharedManager] showAlertOfAttachTaskWithcoin:firstCoin attachCoin:model.secondCoin attachTask:SHANTaskListTypeOfHideSign];
        }
        [weakself getSignInListData];
        [weakself getUserAccountInfo];
    } failure:^(NSString * _Nonnull errMsg) {
        [SHANHUD showInfoWithTitle:errMsg];
    }];
}

/// 邀请好友
- (void)invitationFriendWithCode:(NSString *)code TaskId:(NSString *)taskId {
    [SHANInviteModel shanGetInvitationFriendWithCode:code TaskId:taskId Success:^(id  _Nonnull data) {
        SHANInviteItem *model = (SHANInviteItem *)data;
        [self finishedInviteFriendTask:model.awardCash];
        [self reportRoutineTask:SHANTaskListTypeOfInviteUser];
    } Failure:^(NSString * _Nonnull errorMessage) {
        [self reloadTaskData];
        [SHANHUD showInfoWithTitle:errorMessage];
    }];
}

#pragma mark - HTTP ｜ 上报
/// 上报常规任务
- (void)reportRoutineTask:(SHANTaskListType)type {
    switch (type) {
        case SHANTaskListTypeOfCashOut:
        case SHANTaskListTypeOfRewardVideo:
        case SHANTaskListTypeOfInviteUser:
        case SHANTaskListTypeOfBindUser:
        case SHANTaskListTypeOfBox:
        case SHANTaskListTypeOfCash:
        case SHANTaskListTypeOfHideBox:
        case SHANTaskListTypeOfHideRewardVideo:
        case SHANTaskListTypeOfSleep:   // 待确定
        case SHANTaskListTypeOfHideSleep: // 待确定
            break;
        case SHANTaskListTypeOfHideSign:
        {
            [self reportSignInAttach];
        }
        default:
            return;
            break;
    }
    SHANTaskModel *model = [self getTaskModelWithType:type];
    NSString *taskId = model.userTask.id_;
    
#ifdef DEBUG
    [self testLogReportData:type];
#else
#endif
    [ShanReportTaskManager shanReportTaskWithType:type taskId:taskId success:^(NSDictionary * _Nonnull dic) {
        [self receiveRewards:[dic shanObjectOrNilForKey:@"data"]];  // 领取奖励
        [self reloadTaskData];
    } failure:^(NSString * _Nonnull errorMessage) {
        NSLog(@"%@",errorMessage);
#ifdef DEBUG
        [SHANHUD showInfoWithTitle:errorMessage];
#else
#endif
        
    }];
}

/// 上报签到追加任务奖励
- (void)reportSignInAttach {
    [ShanSignedModel shan_reportSignInAttachSuccess:^(NSDictionary * _Nonnull dict) {
        [self receiveRewards:dict];  // 领取奖励
        [self reloadTaskData];
    } failure:^(NSString * _Nonnull errMsg) {
        NSLog(@"errMsg:%@",errMsg);
    }];
}

/// 提示日志
- (void)testLogReportData:(SHANTaskListType)type {
    switch (type) {
        case SHANTaskListTypeOfRewardVideo:
            NSLog(@"上报：看视频（广告）赚积分");
            break;
        case SHANTaskListTypeOfInviteUser:
            NSLog(@"上报：邀请好友");
            break;
        case SHANTaskListTypeOfBindUser:
            NSLog(@"上报：绑定用户");
            break;
        case SHANTaskListTypeOfHideSign:
            NSLog(@"上报：签到任务-追加视频任务");
            break;
        case SHANTaskListTypeOfBox:
            NSLog(@"上报：宝箱任务");
            break;
        case SHANTaskListTypeOfCash:
            NSLog(@"上报：现金红包(倒计时)");
            break;
        case SHANTaskListTypeOfHideBox:
            NSLog(@"上报：宝箱任务-追加视频任务");
            break;
        case SHANTaskListTypeOfHideRewardVideo:
            NSLog(@"上报：看视频（广告）赚积分任务-追加视频任务");
            break;
        default:
            break;
    }
}

@end
