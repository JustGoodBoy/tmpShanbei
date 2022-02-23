//
//  SHANFaceToFaceViewController.m
//  FDFullscreenPopGesture
//
//  Created by GoodBoy on 2021/10/27.
//

#import "SHANFaceToFaceViewController.h"
#import "SHANHeader.h"
#import "UIColor+SHANHexString.h"
#import "UIImage+SHAN.h"
#import "UIFont+SHAN.h"
#import "UIDevice+SHAN.h"
#import "SHANShareModel.h"
#import "UIView+SHAN.h"
#import "NSMutableAttributedString+SHAN.h"
#import "YYWebImage.h"
#import "NSString+SHAN.h"
@interface SHANFaceToFaceViewController (){
    UIView *bodyView;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SHANShareModel *shareModel;
@end

@implementation SHANFaceToFaceViewController
#pragma mark - LifeCycle(⽣命周期)
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self getShareInfo];
}

#pragma mark - UI
- (void)setupUI {
    self.shareModel = [[SHANShareModel alloc] init];
    self.view.backgroundColor = [UIColor shan_colorWithHexString:@"FF7487"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(16, kSHANStatusBarHeight + 7, 25, 25);
    [backButton setImage:[UIImage SHANImageNamed:@"nav_icon_white_back" className:[self class]] forState:UIControlStateNormal];
    backButton.adjustsImageWhenHighlighted = NO;
    [backButton addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(41, kSHANStatusBarHeight + 7, kSHANScreenWidth - 82, 25);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"面对面扫码";
    titleLabel.font = [UIFont shan_PingFangMediumFont:18];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kSHANStatusBarHeight + 44, kSHANScreenWidth, kSHANScreenHeight - kSHANStatusBarHeight - 44)];
    _scrollView.backgroundColor = [UIColor shan_colorWithHexString:@"#FD3D45"];
    _scrollView.showsVerticalScrollIndicator = false;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    [self bodyViewUI];
}

- (void)bodyViewUI {
    bodyView = [UIView new];
    bodyView.frame = CGRectMake(15, 46, kSHANScreenWidth - 30, 633);
    bodyView.layer.cornerRadius = 8;
    bodyView.layer.masksToBounds = YES;
    bodyView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bodyView];
    
    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.frame = CGRectMake((kSHANScreenWidth - 68)/2, bodyView.top - 34, 68, 68);
    iconImgView.layer.borderWidth = 4;
    iconImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconImgView.layer.cornerRadius = 34;
    iconImgView.layer.masksToBounds = YES;
    iconImgView.image = [UIImage imageNamed:[UIDevice shan_getAppIcon]];
    iconImgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:iconImgView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(0, 44, bodyView.width, 25);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont shan_PingFangMediumFont:18];
    nameLabel.textColor = [UIColor shan_colorWithHexString:@"#464646"];
    nameLabel.text = [UIDevice shan_getAppName];
    [bodyView addSubview:nameLabel];
}

- (void)contentUI {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:6];
    NSMutableAttributedString *content = [self.shareModel.content getAttributedString:[UIColor shan_colorWithHexString:@"#8B8B8B"] highLightColor:[UIColor shan_colorWithHexString:@"#FF424A"] font:[UIFont shan_PingFangMediumFont:13]];
    [content addAttributes:@{NSParagraphStyleAttributeName:paraStyle}
                         range:NSMakeRange(0, content.length)];
    CGFloat contentHeight = [content shan_getHeightWithAttStr:content withWidth:bodyView.width - 49 - 49];
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.frame = CGRectMake(49, 77, bodyView.width - 49 - 49, contentHeight);
    contentLabel.numberOfLines = 0;
    [bodyView addSubview:contentLabel];
    contentLabel.attributedText = content;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *shortDescribe = [UILabel new];
    shortDescribe.frame = CGRectMake(49, contentLabel.bottom + 24, bodyView.width - 49 - 49, 18);
    shortDescribe.textAlignment = NSTextAlignmentCenter;
    shortDescribe.text = self.shareModel.shortDescription;
    shortDescribe.font = [UIFont shan_PingFangRegularFont:13];
    shortDescribe.textColor = [UIColor shan_colorWithHexString:@"#FF7788"];
    [bodyView addSubview:shortDescribe];
    
    UILabel *invitationCode = [UILabel new];
    invitationCode.frame = CGRectMake(49, shortDescribe.bottom + 4, bodyView.width - 49 - 49, 55);
    invitationCode.textAlignment = NSTextAlignmentCenter;
    invitationCode.text = self.shareModel.invitationCode;
    invitationCode.font = [UIFont shan_PingFangMediumFont:40];
    invitationCode.textColor = [UIColor shan_colorWithHexString:@"#FF7788"];
    [bodyView addSubview:invitationCode];
    
    [self lineView:invitationCode.bottom + 27];
    
    UIView *leftCircle = [UIView new];
    leftCircle.frame = CGRectMake(-8, invitationCode.bottom + 27 - 8, 16, 16);
    leftCircle.backgroundColor = [UIColor shan_colorWithHexString:@"FF7487"];
    leftCircle.layer.cornerRadius = 8;
    leftCircle.layer.masksToBounds = YES;
    [bodyView addSubview:leftCircle];
    
    UIView *rightCircle = [UIView new];
    rightCircle.frame = CGRectMake(bodyView.width - 8, CGRectGetMinY(leftCircle.frame), 16, 16);
    rightCircle.backgroundColor = [UIColor shan_colorWithHexString:@"FF7487"];
    rightCircle.layer.cornerRadius = 8;
    rightCircle.layer.masksToBounds = YES;
    [bodyView addSubview:rightCircle];
    
    UIImageView *qrcodeImgView = [[UIImageView alloc] initWithFrame:CGRectMake((bodyView.width - 130)/2, invitationCode.bottom + 60, 130, 130)];
    [qrcodeImgView yy_setImageWithURL:[NSURL URLWithString:self.shareModel.image] placeholder:nil];
    [bodyView addSubview:qrcodeImgView];
    
    NSMutableAttributedString *describe = [self.shareModel.Description getAttributedString:[UIColor shan_colorWithHexString:@"#8B8B8B"] highLightColor:[UIColor shan_colorWithHexString:@"#FF424A"] font:[UIFont shan_PingFangMediumFont:14]];
    [describe addAttributes:@{NSParagraphStyleAttributeName:paraStyle}
                         range:NSMakeRange(0, describe.length)];
    
    UILabel *describeLabel = [UILabel new];
    describeLabel.frame = CGRectMake(42, qrcodeImgView.bottom + 30, bodyView.width - 42 - 42, contentHeight);
    describeLabel.numberOfLines = 0;
    [bodyView addSubview:describeLabel];
    describeLabel.attributedText = describe;
    describeLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)lineView:(CGFloat)Y {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(35, Y, bodyView.width - 70, 2);
    [shapeLayer setFillColor:[UIColor whiteColor].CGColor];
    [shapeLayer setStrokeColor:[UIColor shan_colorWithHexString:@"#ECECEC"].CGColor];
    [shapeLayer setLineWidth:2];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //⚠️ 重点: 30=线的宽度 4=每条线的间距
    [shapeLayer setLineDashPattern:@[@3,@3]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, bodyView.width - 70, 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [bodyView.layer addSublayer:shapeLayer];
}

#pragma mark - Private
- (void)computedHeight:(SHANShareModel *)model {
    _shareModel = model;
    CGFloat topPageHeight = 0;
    CGFloat bottomPageHeight = 0;
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:model.content attributes:@{
        NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:@"#8B8B8B"],
        NSFontAttributeName:[UIFont shan_PingFangMediumFont:13],
    }];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:6];
    [content addAttributes:@{NSParagraphStyleAttributeName:paraStyle}
                         range:NSMakeRange(0, content.length)];
    CGFloat contentHeight = [content shan_getHeightWithAttStr:content withWidth:kSHANScreenWidth - 30 - 49 - 49];
    
    topPageHeight = 77 + contentHeight + 128;
    
    
    NSMutableAttributedString *describe = [[NSMutableAttributedString alloc] initWithString:model.Description attributes:@{
        NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:@"#8B8B8B"],
        NSFontAttributeName:[UIFont shan_PingFangMediumFont:14],
    }];
    [describe addAttributes:@{NSParagraphStyleAttributeName:paraStyle}
                         range:NSMakeRange(0, describe.length)];
    CGFloat describeHeight = [content shan_getHeightWithAttStr:content withWidth:kSHANScreenWidth - 30 - 42 - 42];
    
    bottomPageHeight = 192 + describeHeight + 66;
    
    [self contentUI];
    bodyView.height = topPageHeight + bottomPageHeight;
    _scrollView.contentSize = CGSizeMake(0, topPageHeight + bottomPageHeight + 45 + 46);
}

#pragma mark - HTTP
- (void)getShareInfo {
    [SHANShareModel shanGetShareInfoSuccess:^(id  _Nonnull data) {
        SHANShareModel *model = (SHANShareModel *)data;
        [self computedHeight:model];
    } Failure:^(NSString * _Nonnull errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
}

#pragma mark - Action
- (void)backBtnAction {
    [self back];
}
@end
