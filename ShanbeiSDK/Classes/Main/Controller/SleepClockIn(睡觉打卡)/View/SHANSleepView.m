//
//  SHANSleepView.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/11/24.
//

#import "SHANSleepView.h"
#import "SHANHeader.h"
#import "UIColor+SHANHexString.h"
#import "UIImage+SHAN.h"
#import "UIFont+SHAN.h"
#import "SHANNavigationView.h"
#import "UIView+SHANGetController.h"
#import "NSString+SHAN.h"
#import "SHANSleepModel.h"
#import "SHANSleepCollectionViewCell.h"
#import "NSString+HHMMSS.h"
#import "NSMutableAttributedString+SHAN.h"
@interface SHANSleepView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView *clockInImgView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *sleepBtn;
@end

@implementation SHANSleepView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor shan_colorWithHexString:@"0C1224"];
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenWidth)];
    backgroundView.image = [UIImage SHANImageNamed:@"shan_sleepTask_bg" className:[self class]];
    [self addSubview:backgroundView];
    
    SHANNavigationView *navView = [[SHANNavigationView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANStatusBarHeight + 40) title:@"睡觉打卡赚金币"];
    navView.backgroundColor = [UIColor clearColor];
    navView.backClickBlock = ^{
        [self clickBack];
    };
    [self addSubview:navView];
    
    UIImage *shareImg = [UIImage SHANImageNamed:@"shan_icon_whiteShare" className:[self class]];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.adjustsImageWhenHighlighted = NO;
    shareBtn.frame = CGRectMake(kSHANScreenWidth - 25 -16, kSHANStatusBarHeight + 7, 25, 25);
    [shareBtn setImage:shareImg forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:shareBtn];
    
    [self setupClockInView];
    [self setupTipsView];
}

- (void)setupTipsView {
    
    CGFloat width = (kSHANScreenWidth - 32);
    CGFloat height = width * (196/343.0);
    CGFloat X = 16;
    CGFloat Y = (CGRectGetMinY(_clockInImgView.frame) - height - 12);
    UIImageView *tipsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, width, height)];
    tipsImgView.image = [UIImage SHANImageNamed:@"shan_sleepTask_tips_bg" className:[self class]];
    [self addSubview:tipsImgView];
    
    UIImageView *leftQuotationMarksImgView = [[UIImageView alloc] initWithFrame:CGRectMake(32, 22, 18, 12)];
    leftQuotationMarksImgView.image = [UIImage SHANImageNamed:@"shan_sleepTask_leftQuotationMarks" className:[self class]];
    [tipsImgView addSubview:leftQuotationMarksImgView];
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 52, 297, 112)];
    _tipsLabel.numberOfLines = 0;
    [tipsImgView addSubview:_tipsLabel];
}

- (void)setupClockInView {
    CGFloat width = (kSHANScreenWidth - 32);
    CGFloat height = 255;
    CGFloat X = 16;
    CGFloat Y = (kSHANScreenHeight - height - 29);
    _clockInImgView = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, width, height)];
    _clockInImgView.image = [UIImage SHANImageNamed:@"shan_sleepTask_clockIn_bg" className:[self class]];
    _clockInImgView.userInteractionEnabled = YES;
    [self addSubview:_clockInImgView];
    
    
    [self setupCollectionView];
}

- (void)setupCollectionView {
    CGFloat width = (kSHANScreenWidth - 32);
    CGFloat spacing = (width - 46 - 50*5)/6.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置item的大小
    layout.itemSize = CGSizeMake(50, 67);
    // 设置每个分区的 上左下右 的内边距
    layout.sectionInset = UIEdgeInsetsMake(0, 23 + spacing , 0, 23 + spacing);
    // 设置item的行间距和列间距
    layout.minimumInteritemSpacing = floorf(spacing);
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 27, width, 150) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    [self.clockInImgView addSubview:_collectionView];
    [self.collectionView registerClass:[SHANSleepCollectionViewCell class] forCellWithReuseIdentifier:@"SHANSleepCollectionViewCellID"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
    
    /// 睡觉btn
    _sleepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sleepBtn.frame = CGRectMake(26 + spacing, CGRectGetMaxY(_collectionView.frame) + 10, width - 2*(26 + spacing), 49);
    _sleepBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:18];
    UIImage *btnbgImg = [UIImage SHANImageNamed:@"shan_sleepTask_sleepBtn" className:[self class]];
    [_sleepBtn setBackgroundImage:btnbgImg forState:UIControlStateNormal];
    [_sleepBtn setTitle:@"我要睡了" forState:UIControlStateNormal];
    [_sleepBtn setTitleColor:[UIColor shan_colorWithHexString:@"814400"] forState:UIControlStateNormal];
    _sleepBtn.adjustsImageWhenHighlighted = NO;
    [_clockInImgView addSubview:_sleepBtn];
    [_sleepBtn addTarget:self action:@selector(sleepBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Private
- (void)setupTipsTxt:(NSString *)tips {
    NSString *desc = [tips stringByReplacingOccurrencesOfString:@"金币" withString:@"积分"];
    NSMutableAttributedString *describe = [desc getAttributedString:[UIColor shan_colorWithHexString:@"#D2D8F8"] highLightColor:[UIColor shan_colorWithHexString:@"#FFD043"] font:[UIFont shan_PingFangMediumFont:14]];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:7];
    [describe addAttributes:@{NSParagraphStyleAttributeName:paraStyle}
                         range:NSMakeRange(0, describe.length)];
    _tipsLabel.attributedText = describe;
    CGFloat height = [describe shan_getHeightWithAttStr:describe withWidth:297];
    _tipsLabel.frame = CGRectMake(32, 52, 297, height);
}

#pragma mark - Public
- (void)shan_reloadSleepBtn:(NSInteger)duration {
    if (!_sleepBtn.isSelected) {
        _sleepBtn.selected = true;
    }
    NSString *timeString = [NSString shan_getHHMMSSFromSS:duration];
    NSString *btnTitle = [NSString stringWithFormat:@"睡眠中 %@",timeString];
    [_sleepBtn setTitle:btnTitle forState:UIControlStateNormal];
}

- (void)shan_renewSleepBtn {
    _sleepBtn.selected = false;
    [_sleepBtn setTitle:@"我要睡了" forState:UIControlStateNormal];
}

#pragma mark - setter
- (void)setSleepModel:(SHANSleepModel *)sleepModel {
    _sleepModel = sleepModel;
    [self setupTipsTxt:sleepModel.Description];
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.sleepModel.taskSum > 0) {
        return self.sleepModel.taskSum + 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SHANSleepCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHANSleepCollectionViewCellID" forIndexPath:indexPath];
    if (indexPath.item == 5) {
        UICollectionViewCell *def_cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
        return def_cell;
    }
    // 因为第5个是空白，
    NSInteger tmpIndex = 0;
    if (indexPath.item > 5) {
        tmpIndex = 1;
    }
    if (indexPath.item <= self.sleepModel.finishCount - 1 + tmpIndex) {
        cell.rewardState = 0;
    } else if (indexPath.item >= self.sleepModel.finishCount + tmpIndex && indexPath.item <= (self.sleepModel.finishCount + self.sleepModel.taskCount) - 1 + tmpIndex) {
        cell.rewardState = 1;
    } else {
        cell.rewardState = 2;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击item：%ld",(long)indexPath.item);
    if (indexPath.item == 5) {
        NSLog(@"空白Item");
        return;
    }
    if (indexPath.item <= self.sleepModel.finishCount - 1) {
        NSLog(@"已领取");
    } else if (indexPath.item >= self.sleepModel.finishCount && indexPath.item <= (self.sleepModel.finishCount + self.sleepModel.taskCount) - 1) {
        NSLog(@"可领取");
        !self.clickRewardBlock ? : self.clickRewardBlock();
    } else {
        NSLog(@"待完成");
    }
}

#pragma mark - Action
- (void)shareBtnAction {
    !self.clickShareBlock ? : self.clickShareBlock();
}

- (void)clickBack {
    !self.clickBackBlock ? : self.clickBackBlock();
}

- (void)sleepBtnAction {
    if (_sleepBtn.isSelected) return;
    !self.clickSleepBlock ? : self.clickSleepBlock();
}

@end
