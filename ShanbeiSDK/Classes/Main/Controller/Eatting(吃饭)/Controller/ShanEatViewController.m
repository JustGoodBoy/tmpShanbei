//
//  ShanEatViewController.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2022/1/22.
//

#import "ShanEatViewController.h"
#import "UIImage+SHAN.h"
#import "SHANNavigationView.h"
#import "SHANCommonUIHeader.h"
#import "ShanEatTimeView.h"
#import "ShanEatModel.h"
#import "ShanShareManager.h"
#import "SHANAccountManager.h"
#import "ShanbeiManager.h"
#import "SHANAdManager.h"
#import "SHANNoticeName.h"
#import "SHANTaskModel.h"
#import "NSData+SHAN.h"
#import "SHANHUD.h"
#import "SHANAlertViewManager.h"
#import "NSDictionary+SHAN.h"
#import "SHANMenu.h"
#import "SHANAdvertisingPositionConfigModel.h"
#import "SHANHUD.h"
#import "NSArray+SHAN.h"
#import "NSString+HHMMSS.h"
#import "ShanEatTimeGuideView.h"
@interface ShanEatViewController ()
@property (nonatomic, strong) ShanEatModel *eatModel;
@property (nonatomic, strong) UIButton *eatSubsidyBtn;
/// 是否结束倒计时
@property (nonatomic, assign) BOOL isOverCountDown;
/// 吃饭补贴状态
@property (nonatomic, assign) ShanEatTaskState eatTaskState;
/// 当前补贴在数组中的下标
@property (nonatomic, assign) NSInteger currentSubsidyIndex;
@end

@implementation ShanEatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mealSubsideAttachAction) name:ShanMealSubsideAttachTaskNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mealSubsideAttachTaskReward) name:ShanMealSubsideAttachADTaskFinishNotification object:nil];
    
    // 新手引导
    if (![ShanEatTimeGuideView shan_isNeedShowGuide]) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self guideViewAction];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isOverCountDown = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupView {
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.userInteractionEnabled = YES;
    bgImgView.image = [UIImage SHANImageNamed:@"shan_eat_bg" className:self.class];
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImgView];
    
    SHANNavigationView *navView = [[SHANNavigationView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANStatusBarHeight + 40) title:@"吃饭打卡赚金币"];
    navView.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakself = self;
    navView.backClickBlock = ^{
        [weakself back];
    };
    [self.view addSubview:navView];
    
    UIImage *shareImg = [UIImage SHANImageNamed:@"shan_icon_whiteShare" className:[self class]];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.adjustsImageWhenHighlighted = NO;
    [shareBtn setImage:shareImg forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(kSHANStatusBarHeight + 7);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    UIImage *eatTimeBtnImg = [UIImage SHANImageNamed:@"shan_eat_time_btn" className:self.class];
    UIButton *eatTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    eatTimeBtn.adjustsImageWhenHighlighted = NO;
    [eatTimeBtn setImage:eatTimeBtnImg forState:UIControlStateNormal];
    [eatTimeBtn addTarget:self action:@selector(eatTimeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgImgView addSubview:eatTimeBtn];
    [eatTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(kSHANCurveScreen ? -62 : -28);
        make.left.mas_equalTo(22);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 40, 0, 40);
    UIImage *tmpImage = [UIImage SHANImageNamed:@"shan_eat_subsidy_btn" className:self.class];
    UIImage *eatSubsidyImg = [tmpImage resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    _eatSubsidyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _eatSubsidyBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:18];
    _eatSubsidyBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _eatSubsidyBtn.adjustsImageWhenHighlighted = NO;
    [_eatSubsidyBtn setBackgroundImage:eatSubsidyImg forState:UIControlStateNormal];
    [_eatSubsidyBtn setTitle:@"领取补贴" forState:UIControlStateNormal];
    [_eatSubsidyBtn setTitleColor:[UIColor shan_colorWithHexString:@"#814400"] forState:UIControlStateNormal];
    [_eatSubsidyBtn addTarget:self action:@selector(eatSubsidyAction) forControlEvents:UIControlEventTouchUpInside];
    [bgImgView addSubview:_eatSubsidyBtn];
    [_eatSubsidyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(eatTimeBtn);
        make.left.mas_equalTo(eatTimeBtn.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(kSHANScreenWidth - 108, 53));
    }];
}

#pragma mark - Private
/// 当前补贴积分
- (NSString *)currentAwardCoin {
    NSString *award = @"";
    for (ShanMealSubsideBosModel *subsideBosModel in self.eatModel.mealSubsideBos) {
        if ([self.eatModel.mealSubsideId isEqualToString:subsideBosModel.mealSubsideId]) {
            award = subsideBosModel.awardIntegral;
            break;
        }
    }
    return award;
}

/// 获取当前补贴在数组中的位置
- (NSInteger)getSubsidyIndex {
    NSInteger index = 0;
    for (int i = 0; i < self.eatModel.mealSubsideBos.count; i++) {
        ShanMealSubsideBosModel *subsideBosModel = [self.eatModel.mealSubsideBos shan_objectOrNilAtIndex:i];
        if ([self.eatModel.mealSubsideId isEqualToString:subsideBosModel.mealSubsideId]) {
            index = i;
            break;
        }
    }
    return index;
}

#pragma mark - Notification
/// 餐补任务事件
- (void)mealSubsideAttachAction {
    NSArray *configArray = self.taskModel.advertisingPositionConfig;
    if (kSHANArrayIsEmpty(configArray)) {
        [SHANHUD showInfoWithTitle:@"暂无广告"];
        return;
    }
    SHANAdvertisingPositionConfigModel *configModel = configArray.firstObject;
    //
    [[SHANAdManager sharedManager] shanLoadRewardvodAdWithPosId:configModel.advertisingPositionId type:SHANTaskListTypeOfEat];
    //[[SHANAdManager sharedManager] shanLoadRewardvodAdWithPosId:@"b4a2ca550c29315749" type:SHANTaskListTypeOfEat];
}

/// 餐补任务奖励,上报
- (void)mealSubsideAttachTaskReward {
    [ShanEatModel shan_reportMealSubsideAttachWithSuccess:^(NSString * _Nonnull reward) {
        if (kSHANStringIsEmpty(reward)) return;
        [[SHANAlertViewManager sharedManager] showAlertOfTaskFinishedWithReward:reward taskType:SHANTaskTypeOfCoin];
        self.eatTaskState = ShanEatTaskState_Done;
        [self setupData];
    } failure:^(NSString * _Nonnull errMsg) {
        NSLog(@"errMsg: %@",errMsg);
    }];
}

#pragma mark - HTTP
/// 获取补贴列表
- (void)setupData {
    self.isOverCountDown = YES;
    [ShanEatModel shan_requestSubsideInfoWithSuccess:^(ShanEatModel * _Nonnull model) {
        self.eatModel = model;
        if ([model.additionalRewardsCountdown integerValue] > 0) {
            self.isOverCountDown = NO;
            self.eatTaskState = ShanEatTaskState_NotDone;
            [self countDown:[model.additionalRewardsCountdown integerValue]];
        } else {
            self.isOverCountDown = YES;
        }
        [self updateBtnState];
    } failure:^(NSString * _Nonnull errMsg) {
        self.isOverCountDown = YES;
        NSLog(@"ShanEatModel errMsg: %@",errMsg);
    }];
}

/// 补贴下发
- (void)requestSubsideReward {
    NSString *mealSubsideId = self.eatModel.mealSubsideId;
    [ShanEatModel shan_requestSubsideRewardWithId:mealSubsideId success:^(NSDictionary * _Nonnull dict) {
        if (kSHANDictIsEmpty(dict)) {
            [SHANHUD showInfoWithTitle:@"领取失败!"];
            return;
        }
        NSString *tip = [dict shanObjectOrNilForKey:@"tip"];
        if (!kSHANStringIsEmpty(tip)) {
            [SHANHUD showInfoWithTitle:tip];
            return;
        }
        NSString *award = [self currentAwardCoin];
        
        NSString *additionalAward = [dict shanObjectOrNilForKey:@"additionalAward"];
        [[SHANAlertViewManager sharedManager] showAlertOfAttachTaskWithcoin:award attachCoin:additionalAward attachTask:SHANTaskListTypeOfEat];
        [self setupData];
        self.eatTaskState = ShanEatTaskState_NotDone;
    } failure:^(NSString * _Nonnull errMsg) {
        [SHANHUD showInfoWithTitle:errMsg];
    }];
}

#pragma mark - Action
- (void)eatTimeBtnAction {
    ShanEatTimeView *eatTimeView = [[ShanEatTimeView alloc] initWithFrame:self.view.bounds];
    [eatTimeView shan_showAlert:self.eatModel.mealSubsideBos];
}

- (void)shareBtnAction {
    [[ShanShareManager sharedManager] shan_showShareView];
}

- (void)updateBtnState {
    // 当前餐补领取状态: 1 已领取  2 已过期  3 可领取  4 待领取
    ShanMealSubsideBosModel *subsideBosModel = [self.eatModel.mealSubsideBos shan_objectOrNilAtIndex:[self getSubsidyIndex]];
    NSString *btnText = [NSString stringWithFormat:@"领取%@", self.eatModel.title];
    NSString *btnBgImg = @"shan_eat_subsidy_btn";
    // 不在补助周期中
    if ([subsideBosModel.receiveStatus integerValue] != 3) {
        btnBgImg = @"shan_eat_subsidy_grey_btn";
    }
    
    // 10分钟倒计时结束
    if (self.isOverCountDown) {
        // 已领取、将按钮置灰，并提示补助已领取
        if ([subsideBosModel.receiveStatus integerValue] == 1) {
            // 获取下一个补贴标题
            btnText = @"今日补贴已领完";
            if ([self getSubsidyIndex] < self.eatModel.mealSubsideBos.count - 1) {
                ShanMealSubsideBosModel *nextSubsideBosModel = [self.eatModel.mealSubsideBos shan_objectOrNilAtIndex:[self getSubsidyIndex] + 1];
                btnText = [NSString stringWithFormat:@"  补贴已领取，别忘记%@哦  ",nextSubsideBosModel.title];
            }
            btnBgImg = @"shan_eat_subsidy_grey_btn";
        }
    } else {
        btnBgImg = @"shan_eat_subsidy_btn";
    }
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 40, 0, 40);
    UIImage *tmpImage = [UIImage SHANImageNamed:btnBgImg className:self.class];
    UIImage *eatSubsidyImg = [tmpImage resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    
    [_eatSubsidyBtn setTitle:btnText forState:UIControlStateNormal];
    [_eatSubsidyBtn setBackgroundImage:eatSubsidyImg forState:UIControlStateNormal];
}

/// 领取补贴
- (void)eatSubsidyAction {
    if (![SHANAccountManager sharedManager].isLogin) {
        if ([ShanbeiManager shareManager].loginBlock) {
            [ShanbeiManager shareManager].loginBlock();
        }
        return;
    }
    // 没看过追加视频
    if (self.eatTaskState == ShanEatTaskState_NotDone) {
        [[SHANAdManager sharedManager] shanLoadRewardvodAdWithPosId:@"b4a2ca550c29315749" type:SHANTaskListTypeOfEat];
        return;
    }
    // 当前餐补领取状态: 1 已领取  2 已过期  3 可领取  4 待领取
    ShanMealSubsideBosModel *subsideBosModel = [self.eatModel.mealSubsideBos shan_objectOrNilAtIndex:[self getSubsidyIndex]];
    if ([subsideBosModel.receiveStatus integerValue] == 1) {
        NSLog(@"领取过补贴，不作任何处理，点击无效");
    } else if ([subsideBosModel.receiveStatus integerValue] == 3) {
        [self requestSubsideReward];
    } else if ([subsideBosModel.receiveStatus integerValue] == 4) {
        NSString *tips = [NSString stringWithFormat:@"别忘了%@是%@哦",subsideBosModel.timePeriod,subsideBosModel.title];
        [SHANHUD showInfoWithTitle:tips];
    }
}

// 倒计时
- (void)countDown:(NSInteger)second {
    if (second < 0) {
        self.isOverCountDown = YES;
        self.eatTaskState = ShanEatTaskState_Normal;
    }
    if (self.isOverCountDown) {
        [_eatSubsidyBtn setTitle:@"领取补贴" forState:UIControlStateNormal];
        return;
    }
    [self.eatSubsidyBtn setTitle:[NSString stringWithFormat:@"领取双倍奖励%@",[NSString shan_getNoUnitMMSSFromSS:second]] forState:UIControlStateNormal];
    __block NSInteger countdown = second;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        countdown--;
        [self countDown:countdown];
    });
}

/// 新手引导
- (void)guideViewAction {
    ShanEatTimeGuideView *guideView = [[ShanEatTimeGuideView alloc] initWithFrame:self.view.bounds];
    [guideView shan_showAlert];
}

@end
