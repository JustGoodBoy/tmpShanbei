//
//  SHANSignInView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/10/25.
//

#import "SHANSignInView.h"
#import "SHANCommonUIHeader.h"
#import "UIView+SHAN.h"
#import "SHANHeader.h"
#import "SHANSignInCollectionViewCell.h"
#import "SHANAlertViewManager.h"
#import "SHANNoticeName.h"
#import "SHANCardImageView.h"
#import "SHANAccountManager.h"
#import "ShanbeiManager.h"
#import "NSArray+SHAN.h"
#import "ShanSignedModel.h"
#import "SHANHUD.h"
#import "NSString+HHMMSS.h"
#import "SHANMenu.h"
#import "ShanClickReportModel.h"
@interface SHANSignInView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UIButton *signInBtn;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SHANCardImageView *bgImageView;
@property (nonatomic, strong) NSMutableArray *signInList;

@property (nonatomic, assign) NSInteger countDown;
@property (nonatomic, assign) BOOL isOverCountDown;
@end

@implementation SHANSignInView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return  self;
}

- (void)setupUI {
    _bgImageView = [[SHANCardImageView alloc] initWithFrame:self.bounds];
    _bgImageView.cardTitle = @"来签到·领积分";
    [self addSubview:_bgImageView];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 5;
    layout.itemSize = [SHANSignInCollectionViewCell shan_cellSize];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;   //是否显示滚动条
    _collectionView.scrollEnabled = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[SHANSignInCollectionViewCell class] forCellWithReuseIdentifier:@"SHANSignInCollectionViewCell"];
    [_bgImageView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.centerX.mas_equalTo(_bgImageView);
        make.size.mas_equalTo(CGSizeMake(310, 85));
    }];
    
    // tips
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 174, self.width, 17)];
    _tipsLabel.font = [UIFont shan_PingFangRegularFont:12];
    _tipsLabel.textColor = [UIColor shan_colorWithHexString:@"#A0715A"];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    [_bgImageView addSubview:_tipsLabel];
    
    // button
    _signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _signInBtn.frame = CGRectMake((self.width - 221)/2, CGRectGetMaxY(_tipsLabel.frame) + 12, 221, 57);
    _signInBtn.adjustsImageWhenHighlighted = NO;
    _signInBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:18];
    [_signInBtn setTitle:@"立即签到" forState:UIControlStateNormal];
    [_signInBtn setTitleColor:[UIColor shan_colorWithHexString:@"#FDEAD0"] forState:UIControlStateNormal];
    [_signInBtn addTarget:self action:@selector(signInBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btnImage = [UIImage SHANImageNamed:@"taskCenter_btn_bg" className:[self class]];
    UIEdgeInsets btnEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 30);
    btnImage = [btnImage resizableImageWithCapInsets:btnEdgeInsets resizingMode:UIImageResizingModeStretch];
    [_signInBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [_bgImageView addSubview:_signInBtn];
    
    _tipsLabel.text = @"连续签到领积分";
}

#pragma mark - setter
- (void)setSignedModel:(ShanSignedModel *)signedModel {
    self.isOverCountDown = YES;
    self.countDown = 0;
    _signedModel = signedModel;
    
    BOOL isSignToday = signedModel.isSignToday;
    if ([SHANAccountManager sharedManager].isLogin) {
        [_signInBtn setTitle:isSignToday ? @"已签到" : @"立即签到" forState:UIControlStateNormal];
        _signInBtn.userInteractionEnabled = !isSignToday;
    } else {
        [_signInBtn setTitle:@"立即签到" forState:UIControlStateNormal];
        _signInBtn.userInteractionEnabled = YES;
    }
    
    _signInList = [signedModel.signInTaskBos mutableCopy];
    if (kSHANArrayIsEmpty(_signInList)) return;
    NSInteger cycle = _signInList.count;
    NSInteger coin = 0;
    
    for (ShanSignInTaskBosModel *model in _signInList) {
        coin = coin + [model.awardCoin integerValue];
    }
    
    [self tipsContent:[NSString stringWithFormat:@"%ld",cycle] Coin:[NSString stringWithFormat:@"%ld",coin]];
    
    // 判断 今天对应的签到是否有倒计时
    NSInteger index = [self todayIndexOfSignList];
    ShanSignInTaskBosModel *model = [_signedModel.signInTaskBos shan_objectOrNilAtIndex:index];
    if (!kSHANStringIsEmpty(model.countdown) && [model.countdown integerValue] > 0) {
        self.isOverCountDown = NO;
        [self doubleRewardCountDown:[model.countdown integerValue]];
    }
    
    if (self.width <= 310) {
        _collectionView.scrollEnabled = YES;
    }
    [_collectionView reloadData];
}

#pragma mark - Private(私有⽅法)
/// 内容提示
- (void)tipsContent:(NSString *)cycleString Coin:(NSString *)coinString {
    NSMutableAttributedString *tips = [[NSMutableAttributedString alloc] initWithString:@"连续签到" attributes:@{
        NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:@"#A0715A"],
    }];
    NSAttributedString *cycle = [[NSAttributedString alloc] initWithString:cycleString attributes:@{
        NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:@"#FD3D45"],
    }];
    [tips appendAttributedString:cycle];
    
    NSMutableAttributedString *day = [[NSMutableAttributedString alloc] initWithString:@"天领" attributes:@{
        NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:@"#A0715A"],
    }];
    [tips appendAttributedString:day];
    
    NSMutableAttributedString *coin = [[NSMutableAttributedString alloc] initWithString:coinString attributes:@{
        NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:@"#FD3D45"],
    }];
    [tips appendAttributedString:coin];
    
    NSMutableAttributedString *unit = [[NSMutableAttributedString alloc] initWithString:@"积分" attributes:@{
        NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:@"#A0715A"],
    }];
    [tips appendAttributedString:unit];
    
    _tipsLabel.attributedText = tips;
}

/// 今天在签到列表中的位置
- (NSInteger)todayIndexOfSignList {
    NSInteger index = 0;
    for (int i = 0; i < _signedModel.signInTaskBos.count ; i++) {
        ShanSignInTaskBosModel *model = _signedModel.signInTaskBos[i];
        if ([model.signTaskId isEqualToString:_signedModel.todaySignId]) {
            index = i;
            break;
        }
    }
    return index;
}
#pragma mark - 此处有问题，需要终止该函数（可不可以从dispatch_after取消来想）
/// 倒计时
- (void)doubleRewardCountDown:(NSInteger)second {
    if (second < 0) {
        self.isOverCountDown = YES;
    }
    if (![SHANAccountManager sharedManager].isLogin) {
        self.isOverCountDown = YES;
    }
    if (self.isOverCountDown) {
        self.countDown = 0;
        return;
    }
    self.countDown = second;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self todayIndexOfSignList] inSection:0];
    
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]];
    }];
    
    __block NSInteger countdown = second;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        countdown--;
        [self doubleRewardCountDown:countdown];
    });
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _signInList.count > 0 ? _signInList.count : 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHANSignInCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHANSignInCollectionViewCell" forIndexPath:indexPath];
    
    ShanSignInTaskBosModel *model = [_signInList shan_objectOrNilAtIndex:indexPath.item];
    [cell setSignInModel:model todaySignId:_signedModel.todaySignId];
    if ([self todayIndexOfSignList] == indexPath.item) {
        if (self.countDown > 0) {
            [cell setCoinLabelText:[NSString shan_getNoUnitMMSSFromSS:self.countDown]];
        } else {
            [cell setCoinLabelText:model.awardCoin];
        }
    } else {
        [cell setCoinLabelText:model.awardCoin];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ShanSignInTaskBosModel *model = [_signInList shan_objectOrNilAtIndex:indexPath.item];
    // 是今天，return;
    BOOL isToday = [_signedModel.todaySignId isEqualToString:model.signTaskId];
    if (isToday) {
        // 可翻倍,去看追加视频
        if (self.countDown > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SHANTaskCenterAttachTaskNotification object:nil userInfo:@{@"taskType":[NSString stringWithFormat:@"%ld",SHANTaskListTypeOfHideSign]}];
        }
        return;
    }
    
    // 签到或未到时间，return;
    if (!model || ![model.signStatus isEqualToString:@"0"]) return;
    
    NSString *signInTaskId = model.signTaskId;
    if (kSHANStringIsEmpty(signInTaskId)) {
        [SHANHUD showInfoWithTitle:@"补签失败！"];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SHANTaskCenterSignInTaskNotification object:nil userInfo:@{@"signInTaskId":signInTaskId}];
}

#pragma mark - Action
- (void)signInBtnAction {
    [ShanClickReportModel shanClickReport:ShanClickTypeOfUserSign];
    if ([SHANAccountManager sharedManager].isLogin) {
        NSString *signInTaskId = _signedModel.todaySignId;
        if (kSHANStringIsEmpty(signInTaskId)) {
            [SHANHUD showInfoWithTitle:@"签到失败！"];
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SHANTaskCenterSignInTaskNotification object:nil userInfo:@{@"signInTaskId":signInTaskId}];
    } else {
        if ([ShanbeiManager shareManager].loginBlock) {
            [ShanbeiManager shareManager].loginBlock();
        }
    }
}

@end
