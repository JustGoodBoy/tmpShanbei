//
//  SHANTaskCenterView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import "SHANTaskCenterView.h"
#import "UIImage+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "UIView+SHAN.h"
#import "UIFont+SHAN.h"
#import "NSString+SHAN.h"
#import "UIButton+SHAN.h"
#import "SHANHeader.h"
#import "SHANTaskTableViewCell.h"
#import "SHANTaskCashRedPacketTableViewCell.h"
#import "SHANAlertViewManager.h"
#import "SHANControlManager.h"
#import "SHANAdvertisingPositionConfigModel.h"
#import "SHANTaskModel.h"
#import "SHANAdManager.h"
#import "UIView+SHANGetController.h"
#import "SHANAccountManager.h"
#import "SHANUserTaskModel.h"
#import "SHANAdvertisingPositionConfigModel.h"
#import "ShanbeiManager.h"
#import "SHANHUD.h"
#import "SHANCardImageView.h"
#import "NSArray+SHAN.h"
#import "SHANTimeStamp.h"
#import "ShanTimerManager.h"
#import "NSString+HHMMSS.h"
#import "ShanAttachTaskAgainAlertView.h"
#import "ShanClickReportModel.h"

#define rewardViewHeight 243
#define topCapHeight 53
#define bottomCapHeight 78
#define signInViewHeight 280
#define lineHeight 20

static NSString *taskCellID = @"SHANTaskTableViewCell";
static NSString *taskCashRedPacketCellID = @"SHANTaskCashRedPacketTableViewCell";
static NSInteger cashRedPacketDuration = (3*3600);

@interface SHANTaskCenterView ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate> {
    BOOL isAnimation; // 是否可以动画宝箱
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SHANCardImageView *rewardView;
@property (nonatomic, strong) SHANCardImageView *taskView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *coinBtn;
@property (nonatomic, strong) UIButton *cashBtn;
@property (nonatomic, strong) UIButton *toTaskBtn;

@property (nonatomic, strong) NSMutableArray *allTaskList;
@property (nonatomic, assign) NSInteger cashRedPacketIndex;
@property (nonatomic, copy) NSString *countDownTitle;
/// 看广告任务按钮倒计时
@property (nonatomic, assign) NSInteger videoTaskCountDown;
@end

@implementation SHANTaskCenterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        isAnimation = YES;
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
- (void)setupUI {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor shan_colorWithHexString:@"#FD3D45"];
    _scrollView.showsVerticalScrollIndicator = false;
    [self addSubview:_scrollView];

    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, 500*kSHANScreenW_Radius)];
    backgroundView.image = [UIImage SHANImageNamed:@"taskCenter_bg" className:[self class]];
    [_scrollView addSubview:backgroundView];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kSHANScreenWidth - 206)/2, kSHANStatusBarHeight + 45, 206, 49)];
    titleImageView.image = [UIImage SHANImageNamed:@"shan_titleImage" className:[self class]];
    [backgroundView addSubview:titleImageView];
    
    // 奖励
    [self setupRewardView];
    
    // 签到
    [self setupSignInView];
    
    // 任务
    [self setupTaskView];
    
    // 宝箱懒加载
    self.boxImgView.hidden = YES;
}

- (void)setupSignInView {
    _signInView = [[SHANSignInView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_rewardView.frame) + lineHeight, kSHANScreenWidth - 32, signInViewHeight)];
    [_scrollView addSubview:_signInView];
}

// 奖励view
- (void)setupRewardView {
    _rewardView = [[SHANCardImageView alloc] initWithFrame:CGRectMake(16, 369 * kSHANScreenW_Radius, kSHANScreenWidth - 32, rewardViewHeight)];
    _rewardView.cardTitle = @"您已获得奖励";
    [_scrollView addSubview:_rewardView];
    
    UIButton *cashOutBtn = [[UIButton alloc] init];
    cashOutBtn.adjustsImageWhenHighlighted = NO;
    cashOutBtn.frame = CGRectMake(CGRectGetWidth(_rewardView.frame) - 61 + 5, 40, 61, 32);
    [cashOutBtn setImage:[UIImage SHANImageNamed:@"taskCenter_cashOut" className:[self class]] forState:UIControlStateNormal];
    [cashOutBtn addTarget:self action:@selector(cashOutBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_rewardView addSubview:cashOutBtn];
    
    UILabel *coinTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 72, _rewardView.width*0.5, 18)];
    coinTitleLabel.text = @"积分收益";
    coinTitleLabel.textAlignment = NSTextAlignmentCenter;
    coinTitleLabel.textColor = [UIColor shan_colorWithHexString:@"A0715A"];
    coinTitleLabel.font = [UIFont shan_PingFangMediumFont:13];
    [_rewardView addSubview:coinTitleLabel];
    
    UILabel *cashTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_rewardView.width*0.5, 72, _rewardView.width*0.5, 18)];
    cashTitleLabel.text = @"现金收益";
    cashTitleLabel.textAlignment = NSTextAlignmentCenter;
    cashTitleLabel.textColor = [UIColor shan_colorWithHexString:@"A0715A"];
    cashTitleLabel.font = [UIFont shan_PingFangMediumFont:13];
    [_rewardView addSubview:cashTitleLabel];
    
    _coinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _coinBtn.frame = CGRectMake(0, 94, _rewardView.width*0.5, 26);
    _coinBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:24];
    [_coinBtn setTitle:@"0" forState:UIControlStateNormal];
    [_coinBtn setImage:[UIImage SHANImageNamed:@"taskCenter_arrow_red" className:self.class] forState:UIControlStateNormal];
    [_coinBtn setTitleColor:[UIColor shan_colorWithHexString:@"FD3D45"] forState:UIControlStateNormal];
    [_coinBtn shan_horizontalImageAndTitle:-3];
    [_coinBtn addTarget:self action:@selector(toMyProfitAction) forControlEvents:UIControlEventTouchUpInside];
    [_rewardView addSubview:_coinBtn];
    
    UIColor *cashTxtColor = [UIColor shan_colorWithHexString:@"FD3D45"];
    _cashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cashBtn.frame = CGRectMake(_rewardView.width*0.5, 94, _rewardView.width*0.5, 26);
    _cashBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:12];
    [_cashBtn setImage:[UIImage SHANImageNamed:@"taskCenter_arrow_red" className:self.class] forState:UIControlStateNormal];
    [_cashBtn setTitleColor:cashTxtColor forState:UIControlStateNormal];
    [_cashBtn shan_horizontalImageAndTitle:-3];
    [_cashBtn addTarget:self action:@selector(toMyProfitAction) forControlEvents:UIControlEventTouchUpInside];
    [_rewardView addSubview:_cashBtn];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"0元"];
    NSDictionary *attributedDict = @{
        NSFontAttributeName:[UIFont systemFontOfSize:24.0],
        NSForegroundColorAttributeName:cashTxtColor
    };
    [string setAttributes:attributedDict range:NSMakeRange(0, string.length-1)];
    [string setAttributes:@{
        NSForegroundColorAttributeName:cashTxtColor
    } range:NSMakeRange(string.length-1, 1)];
    [_cashBtn setAttributedTitle:string forState:UIControlStateNormal];
    
    // tips
    UIButton *tipsBtn = [[UIButton alloc] init];
    tipsBtn.adjustsImageWhenHighlighted = NO;
    tipsBtn.frame = CGRectMake((CGRectGetWidth(_rewardView.frame) - 200)/2, 137, 200, 17);
    tipsBtn.titleLabel.font = [UIFont shan_PingFangRegularFont:12];
    [tipsBtn setTitle:@"积分每天凌晨自动兑换成现金" forState:UIControlStateNormal];
    [tipsBtn setImage:[UIImage SHANImageNamed:@"taskCenter_icon_info" className:self.class] forState:UIControlStateNormal];
    [tipsBtn setTitleColor:[UIColor shan_colorWithHexString:shanMainTextColor] forState:UIControlStateNormal];
    [tipsBtn shan_horizontalImageAndTitle:-4];
    [tipsBtn addTarget:self action:@selector(tipsBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_rewardView addSubview:tipsBtn];
     
    _toTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _toTaskBtn.adjustsImageWhenHighlighted = NO;
    _toTaskBtn.frame = CGRectMake((_rewardView.width-221)*0.5, 166, 221, 57);
    [_toTaskBtn addTarget:self action:@selector(toTaskBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_rewardView addSubview:_toTaskBtn];
    [self initToTaskBtnBackground];
}

- (void)setupTaskView {
    _taskView = [[SHANCardImageView alloc] initWithFrame:CGRectMake(_rewardView.left, CGRectGetMaxY(_signInView.frame) + lineHeight, _rewardView.width, 372)];
    _taskView.cardTitle = @"做任务·领积分";
    [_scrollView addSubview:_taskView];
    _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_taskView.frame) + 49);
    
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    [_taskView addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SHANTaskTableViewCell class] forCellReuseIdentifier:taskCellID];
    [self.tableView registerClass:[SHANTaskCashRedPacketTableViewCell class] forCellReuseIdentifier:taskCashRedPacketCellID];
}

#pragma mark - setter
- (void)setTaskArray:(NSMutableArray *)taskArray {
    _allTaskList = taskArray;
    NSMutableArray *tempArray = [NSMutableArray array];
    BOOL isHideBox = true;
    // 过滤任务
    for (SHANTaskModel *model in taskArray) {
        SHANUserTaskModel *userTaskModel = model.userTask;
        // 添加有效任务到列表
        switch ([userTaskModel.advertisingType integerValue]) {
            case SHANTaskListTypeOfCashOut:
            case SHANTaskListTypeOfRewardVideo:
            case SHANTaskListTypeOfInviteUser:
            case SHANTaskListTypeOfBindUser:
            case SHANTaskListTypeOfSleep:
            case SHANTaskListTypeOfEat:
                [tempArray addObject:model];
                break;
            case SHANTaskListTypeOfBox:
                isHideBox = !userTaskModel.gain;
                break;
            case SHANTaskListTypeOfCash:
            {
                if (userTaskModel.gain) {
                    // 账号第一次进入
                    if ([SHANTimeStamp shan_isFirstIntoSDKWithAccount]) {
                        [ShanTimerManager sharedManager].isCashRedPacketTimer = false;
                    }
                    if (![SHANTimeStamp shan_isOutTime:cashRedPacketDuration]) {
                        _cashRedPacketIndex = tempArray.count;
                        [tempArray addObject:model];
                        
                        [self startCashRedPacketTimer];
                    }
                }
            }
                break;
            default:
                break;
        }
    }
    _taskArray = tempArray;
    
    CGFloat height = 0.0;
    for (SHANTaskModel *model in _taskArray) {
        height += model.cellHeight;
    }
    _tableView.frame = CGRectMake(24, topCapHeight, _rewardView.width - 48, height);
    _taskView.height = height + topCapHeight + bottomCapHeight;
    _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_taskView.frame) + 49);
    [_tableView reloadData];
    
    self.boxImgView.hidden = isHideBox;
}

#pragma mark - Public(公有⽅法)
- (void)shanReloadRewardInfo {
    // 积分
    NSString *coin = [NSString stringWithFormat:@"%@",[SHANAccountManager sharedManager].coin];
    [_coinBtn setTitle:coin forState:UIControlStateNormal];
    
    // 收益
    NSString *cash = [SHANAccountManager sharedManager].cash;
    if (kSHANStringIsEmpty(cash)) {
        cash = @"0";
    }
    cash = [NSString stringWithFormat:@"%.2f",[cash floatValue]/100];
    cash = [cash removeSurplusZero:cash];
    cash = [NSString stringWithFormat:@"%@元",cash];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cash];
    NSDictionary *attributedDict = @{
        NSFontAttributeName:[UIFont systemFontOfSize:24.0],
        NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:@"FD3D45"]
    };
    [string setAttributes:attributedDict range:NSMakeRange(0, string.length-1)];
    [string setAttributes:@{
        NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:@"FD3D45"]
    } range:NSMakeRange(string.length-1, 1)];
    [_cashBtn setAttributedTitle:string forState:UIControlStateNormal];
    
    [_coinBtn shan_horizontalImageAndTitle:-3];
    [_cashBtn shan_horizontalImageAndTitle:-3];
    // 登录/任务 按钮
    [self initToTaskBtnBackground];
}

// 登录/任务 按钮
- (void)initToTaskBtnBackground {
    NSString *btnImgName = [SHANAccountManager sharedManager].isLogin ? @"taskCneter_makeMoney" : @"taskCneter_login";
    UIImage *image = [UIImage SHANImageNamed:btnImgName className:[self class]];
    [_toTaskBtn setImage:image forState:UIControlStateNormal];
}

#pragma mark - Private(私有⽅法)
/// 做任务
- (void)clickTask:(SHANTaskModel *)taskModel code:(NSString *)code{
    ShanClickType clickType = ShanClickTypeOfDefault;
    SHANUserTaskModel *userTaskModel = taskModel.userTask;
    switch ([userTaskModel.advertisingType integerValue]) {
        case SHANTaskListTypeOfCashOut: // 提现
            clickType = ShanClickTypeOfToWithdraw;
            [self cashOutBtnAction];
            break;
        case SHANTaskListTypeOfRewardVideo: // 看视频
            clickType = ShanClickTypeOfSeeAd;
            [self watchAD:taskModel];
            break;
        case SHANTaskListTypeOfInviteUser: // 邀请用户
            clickType = ShanClickTypeOfInviteUsers;
            [self inviteFriend];
            break;
        case SHANTaskListTypeOfBindUser: // 绑定用户
            clickType = ShanClickTypeOfFillInviteCode;
            [self bindFriendWithCode:code taskId:userTaskModel.id_];
            break;
        case SHANTaskListTypeOfCash:    // 现金红包
            [self clickCashTask:taskModel];
            break;
        case SHANTaskListTypeOfSleep:   // 睡觉打卡
            clickType = ShanClickTypeOfSleepSubsidy;
            [self clickSleepClockIn:userTaskModel.id_ hideTaskId:@"" gain:userTaskModel.gain];
            break;
        case SHANTaskListTypeOfEat:     // 吃饭补助
            clickType = ShanClickTypeOfMealSubsidy;
            [self clickEatSubsidy];
            break;
        default:
            break;
    }
    
    // 点击上报
    [ShanClickReportModel shanClickReport:clickType];
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

/// 开始倒计时
- (void)startCashRedPacketTimer {
    if (![ShanTimerManager sharedManager].isCashRedPacketTimer) {
        [ShanTimerManager sharedManager].isCashRedPacketTimer = true;
        [[ShanTimerManager sharedManager] shan_startCashRedPacketTimerWith:cashRedPacketDuration];
    }
    [ShanTimerManager sharedManager].cashCountDownBlock = ^(NSInteger countdown) {
        if (countdown >= 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.cashRedPacketIndex inSection:0];
            self.countDownTitle = [NSString shan_getHHMMSSFromSS:countdown];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [self setTaskArray:self.allTaskList];
        }
    };
}

/// 根据任务类型从任务列表中获取 任务model
- (SHANTaskModel *)getTaskModelWithType:(SHANTaskListType)type {
    for (SHANTaskModel *model in _allTaskList) {
        SHANUserTaskModel *userTaskModel = model.userTask;
        if ([userTaskModel.advertisingType integerValue] == type) {
            return model;
        }
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat Y = scrollView.contentOffset.y;
    CGFloat maxHeight = scrollView.contentSize.height - _scrollView.height - 100;
    if (Y > maxHeight) {
        if (isAnimation) {
            isAnimation = NO;
            [UIView animateWithDuration:0.5 animations:^{
                self.boxImgView.frame = CGRectMake(self.bounds.size.width - 16, self.bounds.size.height - 71 - 92, 69, 71);
            }];
        }
    } else {
        if (!isAnimation) {
            isAnimation = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.boxImgView.frame = CGRectMake(self.bounds.size.width - 69 - 26, self.bounds.size.height - 71 - 92, 69, 71);
            }];
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _taskArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHANTaskModel *model = [self.taskArray shan_objectOrNilAtIndex:indexPath.row];
    SHANUserTaskModel *userTaskModel = model.userTask;
    if ([userTaskModel.advertisingType integerValue] == SHANTaskListTypeOfCash) {
        SHANTaskCashRedPacketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCashRedPacketCellID forIndexPath:indexPath];
        cell.clickTaskBlock = ^(SHANTaskModel * model,NSString *code) {
            [self clickTask:model code:code];
        };
        cell.taskModel = model;
        cell.isHiddenLine = indexPath.row == 0;
        cell.countDownTitle = self.countDownTitle;
        return cell;
    }
    SHANTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellID forIndexPath:indexPath];
    cell.clickTaskBlock = ^(SHANTaskModel * model,NSString *code) {
        [self clickTask:model code:code];
    };
    cell.taskModel = model;
    cell.isHiddenLine = indexPath.row == 0;
    if ([userTaskModel.advertisingType integerValue] == SHANTaskListTypeOfRewardVideo) {
        if (self.videoTaskState != ShanVideoTaskState_Normal && self.videoTaskCountDown > 0) {
            [cell setBtnStyle:[NSString shan_getNoUnitMMSSFromSS:_videoTaskCountDown] isRewardVideoTask:YES];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHANTaskModel *model = [_taskArray shan_objectOrNilAtIndex:indexPath.row];
    if (model.cellHeight){
        return model.cellHeight;
    }
    return 80;
}

#pragma mark - lazy
- (SHANTaskCenterBox *)boxImgView {
    if (!_boxImgView) {
        _boxImgView = [[SHANTaskCenterBox alloc] initWithFrame:CGRectMake(self.bounds.size.width - 69 - 26, self.bounds.size.height - 71 - 92, 69, 71)];
        [self addSubview:_boxImgView];
    }
    return _boxImgView;
}

#pragma mark - Action
/// 规则
- (void)tipsBtnAction {
    [[SHANAlertViewManager sharedManager] showAlertOfRule];
}

/// 任务
- (void)toTaskBtnAction {
    if ([SHANAccountManager sharedManager].isLogin) {
        CGFloat Y = CGRectGetMaxY(_rewardView.frame) - kSHANStatusBarHeight;
        [_scrollView setContentOffset:CGPointMake(0, Y) animated:YES];
    } else {
        if ([ShanbeiManager shareManager].loginBlock) {
            [ShanbeiManager shareManager].loginBlock();
        }
    }
}

/// 我的收益
- (void)toMyProfitAction {
    if ([self isNeedLogin]) return;
    [SHANControlManager openMyProfitViewController];
}

/// 提现
- (void)cashOutBtnAction {
    if ([self isNeedLogin]) return;
    [SHANControlManager openCashOutViewController];
}

/// 看广告
- (void)watchAD:(SHANTaskModel *)taskModel {
    if ([self isNeedLogin]) return;
    
    /// 看视频追加任务
    if (self.videoTaskState == ShanVideoTaskState_NotDone) {
        if ([self isNeedLogin]) return;
        
        SHANTaskModel *attachModel = [self getTaskModelWithType:SHANTaskListTypeOfHideRewardVideo];
        NSString *attachAward = [NSString stringWithFormat:@"看视频再领%@积分",attachModel.userTask.awardIntegral];
        
        ShanAttachTaskAgainAlertView *view = [[ShanAttachTaskAgainAlertView alloc] initWithFrame:self.bounds];
        [view shan_showAlert];
        view.titleTxt = @"本轮奖励已领取哦!";
        view.sureBtnTxt = attachAward;
        view.didSureAction = ^{
            NSArray *configArray = attachModel.advertisingPositionConfig;
            if (kSHANArrayIsEmpty(configArray)) {
                [SHANHUD showInfoWithTitle:@"暂无广告"];
                return;
            }
            SHANAdvertisingPositionConfigModel *configModel = configArray.firstObject;
            !self.didTaskTypeBlock ? : self.didTaskTypeBlock(SHANTaskListTypeOfHideRewardVideo);
            [[SHANAdManager sharedManager] shanLoadRewardvodAdWithPosId:configModel.advertisingPositionId type:SHANTaskListTypeOfHideRewardVideo];
        };
        
        return;
    }
    if (self.videoTaskState == ShanVideoTaskState_Done && self.videoTaskCountDown > 0) {
        return;
    }
    /// 看广告赚积分任务
    NSArray *configArray = taskModel.advertisingPositionConfig;
    if (kSHANArrayIsEmpty(configArray)) {
        [SHANHUD showInfoWithTitle:@"暂无广告"];
        return;
    }
    SHANAdvertisingPositionConfigModel *configModel = configArray.firstObject;
    !self.didTaskTypeBlock ? : self.didTaskTypeBlock(SHANTaskListTypeOfRewardVideo);
    [[SHANAdManager sharedManager] shanLoadRewardvodAdWithPosId:configModel.advertisingPositionId type:SHANTaskListTypeOfRewardVideo];
}

#pragma mark - 此处有问题，需要终止该函数（可不可以从dispatch_after取消来想）
/// 倒计时
- (void)shan_rewardCountDown:(NSInteger)second {
    if (![SHANAccountManager sharedManager].isLogin) {
        self.videoTaskState = ShanVideoTaskState_Normal;
        self.videoTaskCountDown = 0;
        return;
    }
    
    if (second < 0) {
        self.videoTaskState = ShanVideoTaskState_Normal;
        self.videoTaskCountDown = 0;
        return;
    }
    
    self.videoTaskCountDown = second;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    __block NSInteger countdown = second;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        countdown--;
        [self shan_rewardCountDown:countdown];
    });
}

/// 邀请用户
- (void)inviteFriend {
    [SHANControlManager openInviteViewController];
}

/// 绑定用户
- (void)bindFriendWithCode:(NSString *)code taskId:(NSString *)taskId {
    if ([self isNeedLogin]) return;
    
    if (kSHANStringIsEmpty(code)) {
        [SHANHUD showInfoWithTitle:@"请输入邀请码"];
    } else {
        !self.inviteFriendBlock ? : self.inviteFriendBlock(code,taskId);
    }
}

/// 点击宝箱
- (void)clickTaskBoxAction {
    if ([self isNeedLogin]) return;
    !self.didTaskTypeBlock ? : self.didTaskTypeBlock(SHANTaskListTypeOfBox);
    !self.reportTaskBlock ? : self.reportTaskBlock(SHANTaskListTypeOfBox);
}

/// 现金红包
- (void)clickCashTask:(SHANTaskModel *)taskModel {
    if ([self isNeedLogin]) return;
    
    NSArray *configArray = taskModel.advertisingPositionConfig;
    if (kSHANArrayIsEmpty(configArray)) {
        [SHANHUD showInfoWithTitle:@"暂无广告"];
        return;
    }
    SHANAdvertisingPositionConfigModel *configModel = configArray.firstObject;
    
    !self.didTaskTypeBlock ? : self.didTaskTypeBlock(SHANTaskListTypeOfCash);
    [[SHANAdManager sharedManager] shanLoadRewardvodAdWithPosId:configModel.advertisingPositionId type:SHANTaskListTypeOfCash];
}

/// 睡觉打卡
- (void)clickSleepClockIn:(NSString *)taskId hideTaskId:(NSString *)hideTaskId gain:(BOOL)gain {
    !self.reportTaskBlock ? : self.reportTaskBlock(SHANTaskListTypeOfSleep);
}

/// 点击去吃饭补助
- (void)clickEatSubsidy {
    if ([self isNeedLogin]) return;
    !self.reportTaskBlock ? : self.reportTaskBlock(SHANTaskListTypeOfEat);
}

@end
