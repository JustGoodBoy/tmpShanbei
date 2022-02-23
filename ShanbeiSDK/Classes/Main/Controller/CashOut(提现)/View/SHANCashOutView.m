//
//  SHANCashOutView.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/17.
//

#import "SHANCashOutView.h"
#import "SHANHeader.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
#import "UIView+SHAN.h"
#import "UIView+SHANGetController.h"
#import "UIImage+SHAN.h"
#import "NSString+SHAN.h"
#import "NSMutableAttributedString+SHAN.h"
#import "SHANAlertViewManager.h"
#import "SHANWXApiManager.h"
#import "SHANCashOutModel.h"
#import "SHANAccountManager.h"
#import "YYWebImage.h"
#import "SHANCashOutCollectionView.h"
#import "SHANWXUserInfoModel.h"
#import "SHANCashDrawalModel.h"
@interface SHANCashOutView ()
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIView *cashOutView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *weChatIDLabel;   // 微信id
@property (nonatomic, strong) UIButton *authBtn;  // 授权/切换账号
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) SHANCashOutCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cashDrawalList;
@property (nonatomic, copy) NSString *drawDepositCount; // 提现成功次数
@end

@implementation SHANCashOutView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.cashDrawalList = [NSMutableArray new];
        self.selectIndex = 0;
    }
    return self;
}

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight - kSHANStatusBarHeight - 40)];
    scrollView.backgroundColor = [UIColor shan_colorWithHexString:@"#F7F8FA"];
    scrollView.showsVerticalScrollIndicator = false;
    [self addSubview:scrollView];
    
    [self createBezierLayer:scrollView];
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor shan_colorWithHexString:@"FD5558"];
    backgroundView.frame = CGRectMake(0, -self.bounds.size.height*0.5, kSHANScreenWidth, self.bounds.size.height*0.5);
    [scrollView addSubview:backgroundView];
    
    UILabel *totalTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, kSHANScreenWidth, 20)];
    totalTitleLabel.text = @"总金额(元)";
    totalTitleLabel.textColor = [UIColor whiteColor];
    totalTitleLabel.textAlignment = NSTextAlignmentCenter;
    totalTitleLabel.font = [UIFont shan_PingFangRegularFont:14];
    [scrollView addSubview:totalTitleLabel];
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(totalTitleLabel.frame) + 8, kSHANScreenWidth, 33)];
    _totalLabel.text = @"0";
    _totalLabel.textColor = [UIColor whiteColor];
    _totalLabel.textAlignment = NSTextAlignmentCenter;
    _totalLabel.font = [UIFont shan_PingFangRegularFont:30];
    [scrollView addSubview:_totalLabel];
    
    // 微信
    [self createWeChatCard:scrollView];
    
    // 提现
    [self createCashOutView:scrollView];
    
    // 说明
    [self createExplainView:scrollView];
}

/// 曲线
- (void)createBezierLayer:(UIScrollView*)scrollView {
    CGFloat X = 0;
    CGFloat Y = 0;
    CGSize finalSize = CGSizeMake(kSHANScreenWidth - X, 132);
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    UIBezierPath *bezier = [[UIBezierPath alloc] init];
    // 起始点
    [bezier moveToPoint:CGPointMake(X, finalSize.height)];
    [bezier addLineToPoint:CGPointMake(X, Y)];
    [bezier addLineToPoint:CGPointMake(finalSize.width, Y)];
    [bezier addLineToPoint:CGPointMake(finalSize.width, finalSize.height)];
    
    // 突出点
    [bezier addQuadCurveToPoint:CGPointMake(X, finalSize.height) controlPoint:CGPointMake(finalSize.width / 2, finalSize.height + 24)];
    layer.path = bezier.CGPath;
    layer.fillColor = [UIColor shan_colorWithHexString:@"FD5558"].CGColor;
    [scrollView.layer addSublayer:layer];
}

/// 微信card
- (void)createWeChatCard:(UIScrollView *)scrollView {
    UIView *weChatCard = [[UIView alloc] initWithFrame:CGRectMake(16, 109, kSHANScreenWidth - 32, 64)];
    weChatCard.backgroundColor = UIColor.whiteColor;
    weChatCard.layer.cornerRadius = 16;
    weChatCard.layer.masksToBounds = YES;
    [scrollView addSubview:weChatCard];
    
    _icon = [[UIImageView alloc] init];
    _icon.frame = CGRectMake(16, 19, 26, 26);
    _icon.layer.cornerRadius = 4;
    _icon.layer.masksToBounds = YES;
    _icon.image = [UIImage SHANImageNamed:@"shan_weixin" className:self.class];
    [weChatCard addSubview:_icon];
    
    _weChatIDLabel = [[UILabel alloc] init];
    _weChatIDLabel.frame = CGRectMake(54, 22, CGRectGetWidth(weChatCard.frame) - 54 - 64 - 16 - 12, 20);
    _weChatIDLabel.font = [UIFont shan_PingFangRegularFont:14];
    _weChatIDLabel.textColor = [UIColor shan_colorWithHexString:@"#666666"];
    _weChatIDLabel.text = @"授权微信账户后提现";
    [weChatCard addSubview:_weChatIDLabel];
    
    _authBtn = [[UIButton alloc] init];
    _authBtn.frame = CGRectMake(CGRectGetWidth(weChatCard.frame) - 16 - 64, 20, 64, 24);
    _authBtn.layer.cornerRadius = 12;
    _authBtn.layer.masksToBounds = YES;
    _authBtn.layer.borderWidth = 1;
    _authBtn.layer.borderColor = [UIColor shan_colorWithHexString:@"#FD5558"].CGColor;
    _authBtn.titleLabel.font = [UIFont shan_PingFangRegularFont:13];
    [_authBtn setTitleColor:[UIColor shan_colorWithHexString:@"FD5558"] forState:UIControlStateNormal];
    [_authBtn setTitle:@"授权" forState:UIControlStateNormal];
    [_authBtn addTarget:self action:@selector(authBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [weChatCard addSubview:_authBtn];
}

/// 提现
- (void)createCashOutView:(UIScrollView *)scrollView {
    _cashOutView = [[UIView alloc] initWithFrame:CGRectMake(16, 109 + 64 + 16, kSHANScreenWidth - 32, 252)];
    _cashOutView.backgroundColor = UIColor.whiteColor;
    _cashOutView.layer.cornerRadius = 16;
    _cashOutView.layer.masksToBounds = YES;
    [scrollView addSubview:_cashOutView];
    
    CGFloat itemWidth = 94.0;
    CGFloat itemHeight = 62.0;
    CGFloat marginLeft = (((kSHANScreenWidth - 32) - itemWidth*3)/4) - 1;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = marginLeft;
    layout.minimumInteritemSpacing = 16;
    layout.sectionInset = UIEdgeInsetsMake(0, marginLeft ,0, marginLeft);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[SHANCashOutCollectionView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(_cashOutView.frame), 176) collectionViewLayout:layout];
    [_cashOutView addSubview:_collectionView];
    
    __weak typeof(self) weakself = self;
    _collectionView.clickItemBlock = ^(NSInteger index) {
        weakself.selectIndex = index;
    };
    
    UIButton *cashOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cashOutBtn.adjustsImageWhenHighlighted = NO;
    CGFloat cashOutBtnHeight = (CGRectGetWidth(_cashOutView.frame) - 64)*64/279;
    cashOutBtn.frame = CGRectMake(32, CGRectGetHeight(_cashOutView.frame) - 12 - cashOutBtnHeight, CGRectGetWidth(_cashOutView.frame) - 64, cashOutBtnHeight);
    [cashOutBtn setImage:[UIImage SHANImageNamed:@"shan_cashOut_btn" className:[self class]] forState:UIControlStateNormal];
    [cashOutBtn addTarget:self action:@selector(cashOutBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_cashOutView addSubview:cashOutBtn];
}

/// 说明
- (void)createExplainView:(UIScrollView *)scrollView {
    UIView *explainView = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_cashOutView.frame) + 16, kSHANScreenWidth - 32, 226)];
    explainView.backgroundColor = UIColor.whiteColor;
    explainView.layer.cornerRadius = 16;
    explainView.layer.masksToBounds = YES;
    [scrollView addSubview:explainView];
    
    NSString *explainString = @"\n1.每个额度每天限提1次。\n2.您的提现状态可以在“现金记录”中查看。\n3.提现申请后通常会快速到账。微信到账查询：微信-我的-钱包-零钱明细；支付宝到账查询：支付宝-我的-账单。\n4.如发现造假等违规操作，我们将阻止您使用并取消您获得的奖励。";
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"提现说明" attributes:@{
        NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:@"#333333"],
        NSFontAttributeName:[UIFont shan_PingFangRegularFont:16],
    }];
    NSAttributedString *desc = [[NSAttributedString alloc] initWithString:explainString attributes:@{
        NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:@"#666666"],
        NSFontAttributeName:[UIFont shan_PingFangRegularFont:12],
    }];
    [content appendAttributedString:desc];

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:10];
    [content addAttributes:@{NSParagraphStyleAttributeName:paraStyle}
                         range:NSMakeRange(0, content.length)];
    CGFloat height = [content shan_getHeightWithAttStr:content withWidth:CGRectGetWidth(explainView.frame) - 32];
    
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 24, CGRectGetWidth(explainView.frame) - 32, height)];
    explainLabel.numberOfLines = 0;
    [explainView addSubview:explainLabel];
    explainLabel.lineBreakMode = NSLineBreakByWordWrapping;
    explainLabel.attributedText = content;
    
    explainView.height = height + 24 + 24;
    scrollView.contentSize = CGSizeMake(kSHANScreenWidth, CGRectGetMaxY(explainView.frame) + 45);
}

#pragma mark - Public(公有⽅法)
- (void)shanReloadAccountInfo {
    if (!kSHANStringIsEmpty([SHANAccountManager sharedManager].headImgUrl)) {
        [_icon yy_setImageWithURL:[NSURL URLWithString:[SHANAccountManager sharedManager].headImgUrl] placeholder:[UIImage SHANImageNamed:@"shan_weixin" className:self.class]];
    }
    if (!kSHANStringIsEmpty([SHANAccountManager sharedManager].nickname)) {
        _weChatIDLabel.text = [SHANAccountManager sharedManager].nickname;
        [_authBtn setTitle:@"换账号" forState:UIControlStateNormal];
    } else {
        [_authBtn setTitle:@"授权" forState:UIControlStateNormal];
        _weChatIDLabel.text = @"授权微信账户后提现";
    }
}

#pragma mark - setter
- (void)setCashOutModel:(SHANCashOutModel *)cashOutModel {
    _cashOutModel = cashOutModel;
    
    NSString *cashString = @"0";
    cashString = [NSString stringWithFormat:@"%.2f",[_cashOutModel.cash floatValue]/100];
    cashString = [cashString removeSurplusZero:cashString];
    _totalLabel.text = cashString;
    
    SHANWXUserInfoModel *userInfoModel = _cashOutModel.weChatInfo;
    [SHANAccountManager sharedManager].nickname = userInfoModel.nickname;
    [SHANAccountManager sharedManager].headImgUrl = userInfoModel.headImgUrl; // 后台定义的headImgUrl（驼峰式）
    
    [self shanReloadAccountInfo];
    
    _cashDrawalList = [_cashOutModel.cashWithdrawalAmountList mutableCopy];
    _collectionView.dataArray = _cashDrawalList;
    
    _drawDepositCount = _cashOutModel.withdrawDepositCount;
}

#pragma mark - Action
/// 授权
- (void)authBtnAction {
    if (![[SHANWXApiManager sharedManager] shanIsWXAppInstalled]){
        [[SHANWXApiManager sharedManager] shanUninstalledWXAppTips:self.viewController];
        return;
    }
    if (![[SHANWXApiManager sharedManager] shanIsWXAppSupportApi]) {
        [[SHANWXApiManager sharedManager] shanLowVersionWXAppTips:self.viewController];
        return;
    }
    if ([_authBtn.titleLabel.text isEqualToString:@"授权"]) {
        [[SHANWXApiManager sharedManager] shanSendAuthRequestInViewController:self.viewController];
    } else {    // 换账号
        /// 应该使用 切换账号授权，但是没有openID，所以使用授权绑定
        [[SHANWXApiManager sharedManager] shanSendAuthRequestInViewController:self.viewController];
    }
}

/// 点击提现按钮
- (void)cashOutBtnAction {
    // 授权微信
    if (kSHANStringIsEmpty([SHANAccountManager sharedManager].nickname)) {
        [[SHANAlertViewManager sharedManager] showAlertAuthWXOfTpis];
        return;
    }
    // 有数据
    if (kSHANArrayIsEmpty(self.cashDrawalList)) {
        return;
    }
    // 累计次数
    if (self.selectIndex == 1) {
        SHANCashDrawalModel *model = _cashDrawalList[1];
        /// 提现累计次数 < 提现目标次数
        if ([_drawDepositCount integerValue] < [model.withdrawalCount intValue]) {
            [[SHANAlertViewManager sharedManager] showAlertOfCashOutCurrent:_drawDepositCount frequency:model.withdrawalCount];
            return;
        }
    }
    // 判断是否是首次提现
    !self.judgeFirstCashOutBlock ? : self.judgeFirstCashOutBlock();
}

/// 提现
- (void)shan_cashOut {
    SHANCashDrawalModel *model = _cashDrawalList[self.selectIndex];
    [[SHANAlertViewManager sharedManager] showAlertOfCashOutWithCash:model mode:@"微信"];
}
@end
