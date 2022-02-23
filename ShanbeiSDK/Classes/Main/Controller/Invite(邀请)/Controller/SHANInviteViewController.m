//
//  SHANInviteViewController.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/10/26.
//

#import "SHANInviteViewController.h"
#import "SHANHeader.h"
#import "UIColor+SHANHexString.h"
#import "UIImage+SHAN.h"
#import "UIFont+SHAN.h"

#import "NSMutableAttributedString+SHAN.h"
#import "SHANCardImageView.h"
#import "SHANInviteCollectionViewCell.h"
#import "SHANInviteCodeView.h"
#import "UIView+SHAN.h"
#import "SHANInviteModel+HTTP.h"
#import "SHANShareInviteView.h"
#import "SHANControlManager.h"
#import "SHANWXApiManager.h"
#import "SHANAccountManager.h"
#import "ShanbeiManager.h"
#import "SHANNoticeName.h"
#import "NSArray+SHAN.h"
#define marginTop (280 + kSHANStatusBarHeight + 44)
#define inviteViewHeight (232 + 53)

@interface SHANInviteViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SHANCardImageView *inviteView;
@property (nonatomic, strong) SHANCardImageView *helpView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SHANInviteCodeView *inviteCodeView;
@property (nonatomic, strong) UIButton *inviteBtn;
@property (nonatomic, strong) SHANInviteModel *inviteModel;
@property (nonatomic, copy) NSString *invitationCode;
@property (nonatomic, copy) NSString *downloadURL;
@end

@implementation SHANInviteViewController
#pragma mark - LifeCycle(⽣命周期)
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self initupNotice];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

#pragma mark - UI
- (void)setupUI {
    _inviteModel = [[SHANInviteModel alloc] init];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor shan_colorWithHexString:@"#FD3D45"];
    _scrollView.showsVerticalScrollIndicator = false;
    [self.view addSubview:_scrollView];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, 546*kSHANScreenW_Radius)];
    backgroundView.image = [UIImage SHANImageNamed:@"invite_bg" className:[self class]];
    backgroundView.userInteractionEnabled = YES;
    [_scrollView addSubview:backgroundView];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kSHANScreenWidth-239)/2, kSHANStatusBarHeight + 32, 239, 50)];
    titleImageView.image = [UIImage SHANImageNamed:@"invite_title_image" className:[self class]];
    [backgroundView addSubview:titleImageView];
    
    [self inviteViewUI];
    [self helpViewUI];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(16, kSHANStatusBarHeight + 7, 25, 25);
    [backBtn setImage:[UIImage SHANImageNamed:@"nav_icon_white_back" className:[self class]] forState:UIControlStateNormal];
    backBtn.adjustsImageWhenHighlighted = NO;
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:backBtn];
    _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_helpView.frame) + 40);
}

- (void)inviteViewUI {
    _inviteView = [[SHANCardImageView alloc] initWithFrame:CGRectMake(16, marginTop, kSHANScreenWidth - 32, inviteViewHeight)];
    _inviteView.cardTitle = @"您已邀请用户";
    [_scrollView addSubview:_inviteView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(50*kSHANScreenW_Radius, 62);
    layout.minimumLineSpacing = (_inviteView.frame.size.width - 56*kSHANScreenW_Radius - 50*kSHANScreenW_Radius*5)/4;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(28*kSHANScreenW_Radius, 70, _inviteView.frame.size.width - 56*kSHANScreenW_Radius, 62) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;   //是否显示滚动条
    _collectionView.scrollEnabled = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[SHANInviteCollectionViewCell class] forCellWithReuseIdentifier:@"SHANInviteCollectionViewCell"];
    [_inviteView addSubview:_collectionView];
    
    // 邀请码
    [_inviteView addSubview:self.inviteCodeView];
    
    _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _inviteBtn.frame = CGRectMake(28*kSHANScreenW_Radius, CGRectGetHeight(_inviteView.frame) - 20 - 57, _inviteView.width - 56*kSHANScreenW_Radius, 57);
    _inviteBtn.titleLabel.font = [UIFont shan_PingFangMediumFont:18];
    [_inviteBtn setTitle:@"立即邀请" forState:UIControlStateNormal];
    [_inviteBtn setTitleColor:[UIColor shan_colorWithHexString:@"#FDEAD0"] forState:UIControlStateNormal];
    [_inviteBtn addTarget:self action:@selector(inviteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_inviteView addSubview:_inviteBtn];
    
    UIImage *btnImage = [UIImage SHANImageNamed:@"taskCenter_btn_bg" className:[self class]];
    UIEdgeInsets btnEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 30);
    btnImage = [btnImage resizableImageWithCapInsets:btnEdgeInsets resizingMode:UIImageResizingModeStretch];
    [_inviteBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}

- (void)helpViewUI {
    NSString *helpString = @"1.点击邀请按钮，通过微信、QQ向好友发送邀请消息；或者您点开“面对面扫码”，让好友通过微信、浏览器等软件的扫码功能面对面扫您的二维码；\n\n2.通过以上方式，好友下载并安装本软件，好友打开软件后去填写您的邀请码，您可以直接复制本页面的邀请码并粘贴发送给好友；\n\n3.好友填写您的邀请码并提交成功后，您和好友将分别领取相应的奖励，快来试试吧~";
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:helpString attributes:@{
        NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:@"#A0715A"],
        NSFontAttributeName:[UIFont shan_PingFangRegularFont:14],
    }];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:5];
    [content addAttributes:@{NSParagraphStyleAttributeName:paraStyle}
                         range:NSMakeRange(0, content.length)];
    CGFloat width = kSHANScreenWidth - 32 - 64*kSHANScreenW_Radius;
    CGFloat height = [content shan_getHeightWithAttStr:content withWidth:width];
    
    _helpView = [[SHANCardImageView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_inviteView.frame) + 20, kSHANScreenWidth - 32, height + 70 + 30)];
    _helpView.cardTitle = @"如何邀请好友";
    [_scrollView addSubview:_helpView];
    
    UILabel *helpLabel = [[UILabel alloc] initWithFrame:CGRectMake(32*kSHANScreenW_Radius, 70, width, height)];
    helpLabel.numberOfLines = 0;
    helpLabel.attributedText = content;
    [_helpView addSubview:helpLabel];
}

#pragma mark - Notice
- (void)reloadAccountInfo {
    [self updateUI];
}

#pragma mark - Private
- (void)updateUI {
    [self getInvitationCode];
    if ([SHANAccountManager sharedManager].isLogin) {
        
        self.inviteCodeView.hidden = NO;
        _inviteView.height = inviteViewHeight;
    } else {
        self.inviteCodeView.hidden = YES;
        _inviteView.height = 232;
    }
    NSString *btnString = [SHANAccountManager sharedManager].isLogin ? @"立即邀请" : @"登录并开始邀请";
    [_inviteBtn setTitle:btnString forState:UIControlStateNormal];
    _inviteBtn.bottom = CGRectGetHeight(_inviteView.frame) - 20;
    _helpView.top = CGRectGetMaxY(_inviteView.frame) + 20;
    _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_helpView.frame) + 40);
}

- (void)initupNotice {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAccountInfo) name:SHANReloadAccountIDNotification object:nil];
}

#pragma mark - HTTP
/// 获取邀请码
- (void)getInvitationCode {
    [SHANInviteModel shanGetInviteListSuccess:^(id  _Nonnull data) {
        self.inviteModel = (SHANInviteModel *)data;
        self.downloadURL = self.inviteModel.url;
        self.invitationCode = self.inviteModel.invitationCode;
        self.inviteCodeView.inviteCode = self.inviteModel.invitationCode;
        [self.collectionView reloadData];
    } Failure:^(NSString * _Nonnull errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 不用self.inviteModel.inviteTaskPos.count 是因为保证进入页面有列表，不然空白
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHANInviteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHANInviteCollectionViewCell" forIndexPath:indexPath];
    SHANInviteItem *model = [self.inviteModel.inviteTaskPos shan_objectOrNilAtIndex:indexPath.row];
    [cell setInfoWithModel:model isInvited:indexPath.row < [self.inviteModel.friendCount integerValue]];
    return cell;
}

#pragma mark - lazyLoad
- (SHANInviteCodeView *)inviteCodeView {
    if (!_inviteCodeView) {
        _inviteCodeView = [[SHANInviteCodeView alloc] initWithFrame:CGRectMake(32*kSHANScreenW_Radius, 155, _inviteView.width - 64*kSHANScreenW_Radius, 32)];
        _inviteCodeView.backgroundColor = [UIColor shan_colorWithHexString:@"#FEF6E9" alphaComponent:0.4];
        _inviteCodeView.layer.cornerRadius = 16;
        _inviteCodeView.layer.masksToBounds = YES;
    }
    return _inviteCodeView;
}

#pragma mark - Action
- (void)inviteBtnAction {
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
                NSString *shareText = [NSString stringWithFormat:@"我在用这款%@APP：\n下载安装后填我邀请码\n%@\n即可领取现金红包，每天可提现\n下载地址：%@",appName,code,url];
                
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

- (void)backBtnAction {
    [self back];
}
@end
