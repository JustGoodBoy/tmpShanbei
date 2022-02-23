//
//  SHANTaskCashRedPacketTableViewCell.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/18.
//

#import "SHANTaskCashRedPacketTableViewCell.h"
#import "UIView+SHAN.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
#import "NSString+SHAN.h"
#import "SHANAlertViewManager.h"
#import "YYWebImage.h"
#import "SHANHeader.h"
#import "SHANUserTaskModel.h"
#import "UIImage+SHAN.h"
#import "SHANTaskModel.h"

@interface SHANTaskCashRedPacketTableViewCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *taskTitleLabel;
@property (nonatomic, strong) UILabel *taskDescribeLabel;
@property (nonatomic, strong) UIButton *taskBtn;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UILabel *countdownLabel;
@end

@implementation SHANTaskCashRedPacketTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.clearColor;
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 32, 32)];
    [self.contentView addSubview:_icon];
    
    CGFloat width = (kSHANScreenWidth - 80) - 43 - 97;
    _taskTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, _icon.top, width, 20)];
    _taskTitleLabel.font = [UIFont shan_PingFangSemiboldFont:14];
    _taskTitleLabel.textColor = [UIColor shan_colorWithHexString:shanMainTextColor];
    _taskTitleLabel.numberOfLines = 0;
    [self.contentView addSubview:_taskTitleLabel];
    
    // 描述
    _taskDescribeLabel = [[UILabel alloc] init];
    _taskDescribeLabel.numberOfLines = 0;
    _taskDescribeLabel.lineBreakMode = NSLineBreakByClipping;
    _taskDescribeLabel.frame = CGRectMake(43, _taskTitleLabel.bottom + 5, width, 16);
    _taskDescribeLabel.font = [UIFont shan_PingFangRegularFont:11];
    _taskDescribeLabel.textColor = [UIColor shan_colorWithHexString:@"#B98A73"];
    [self.contentView addSubview:_taskDescribeLabel];
    
    //倒计时
    _countdownLabel = [[UILabel alloc] init];
    _countdownLabel.frame = CGRectMake(43, _taskDescribeLabel.bottom + 8, 96, 22);
    _countdownLabel.layer.cornerRadius = 4;
    _countdownLabel.layer.masksToBounds = YES;
    _countdownLabel.backgroundColor = [UIColor shan_colorWithHexString:@"#FD494F" alphaComponent:0.08];
    _countdownLabel.textColor = [UIColor shan_colorWithHexString:@"#F5232C"];
    _countdownLabel.font = [UIFont shan_PingFangRegularFont:11];
    _countdownLabel.textAlignment = NSTextAlignmentCenter;
    _countdownLabel.text = @"03:00:00后结束";
    [self.contentView addSubview:_countdownLabel];
    
    // 按钮
    _taskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _taskBtn.adjustsImageWhenHighlighted = NO;
    _taskBtn.frame = CGRectMake((kSHANScreenWidth - 80) - 78, 21, 82, 40);
    _taskBtn.titleLabel.font = [UIFont shan_PingFangRegularFont:14];
    [self.contentView addSubview:_taskBtn];
    [_taskBtn addTarget:self action:@selector(taskBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth - 80, 1)];
    _bottomLine.backgroundColor = [UIColor shan_colorWithHexString:@"#F4DBBE" alphaComponent:0.34];
    [self addSubview:_bottomLine];
}

#pragma mark - setter
- (void)setTaskModel:(SHANTaskModel *)taskModel {
    _taskModel = taskModel;
    SHANUserTaskModel *userTaskModel = _taskModel.userTask;
    
    // icon
    [_icon yy_setImageWithURL:[NSURL URLWithString:userTaskModel.iconUrl] placeholder:nil];
    
    // title
    NSString *replaceTitle =  [userTaskModel.title stringByReplacingOccurrencesOfString:@"金币" withString:@"积分"];
    _taskTitleLabel.text = replaceTitle;
    CGFloat titleHeight = [_taskTitleLabel.text shan_getHeightwithContent:_taskTitleLabel.text withFont:[UIFont shan_PingFangSemiboldFont:14] withWidth:(kSHANScreenWidth - 80) - 43 - 97];
    _taskTitleLabel.height = titleHeight;
    
    // 按钮背景
    if (userTaskModel.gain) {
        [_taskBtn setBackgroundImage:[UIImage SHANImageNamed:@"taskCenter_taskNotStartedBtn" className:[self class]] forState:UIControlStateNormal];
        [_taskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _taskBtn.userInteractionEnabled = YES;
    } else {
        [_taskBtn setBackgroundImage:[UIImage SHANImageNamed:@"taskCenter_taskFinishedBtn" className:[self class]] forState:UIControlStateNormal];
        [_taskBtn setTitleColor:[UIColor shan_colorWithHexString:@"#A0A0A0"] forState:UIControlStateNormal];
        _taskBtn.userInteractionEnabled = NO;
    }
    [_taskBtn setTitle:userTaskModel.buttonName forState:UIControlStateNormal];
    
    // 描述
    NSString *replaceSubheading =  [userTaskModel.subheading stringByReplacingOccurrencesOfString:@"金币" withString:@"积分"];
    CGFloat height = [replaceSubheading shan_getHeightwithContent:replaceSubheading withFont:[UIFont shan_PingFangRegularFont:11] withWidth:kSHANScreenWidth - 80 - 43 - 78 - 19];
    _taskDescribeLabel.top = CGRectGetMaxY(_taskTitleLabel.frame) + 5;
    _taskDescribeLabel.height = height;
    _countdownLabel.top = CGRectGetMaxY(_taskDescribeLabel.frame) + 8;
    if ([replaceSubheading containsString:@"<"]) {
        NSArray  *descArray = [replaceSubheading componentsSeparatedByString:@"<"];
        NSArray  *descSubArray = [descArray[1] componentsSeparatedByString:@">"];
        NSString *coinString = descSubArray[0];
        
        NSMutableAttributedString *describeStr = [[NSMutableAttributedString alloc] initWithString:descArray[0]];
        NSAttributedString * coin= [[NSAttributedString alloc] initWithString:coinString attributes:@{
            NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:@"#FD3D45"],
        }];
        [describeStr appendAttributedString:coin];
        
        NSAttributedString *unit = [[NSAttributedString alloc] initWithString:descSubArray[1]];
        [describeStr appendAttributedString:unit];
        
        _taskDescribeLabel.attributedText = describeStr;
    } else {
        _taskDescribeLabel.text = replaceSubheading;
    }
}

#pragma mark - setter
- (void)setIsHiddenLine:(BOOL)isHiddenLine {
    if (isHiddenLine){
        _bottomLine.hidden = YES;
    } else {
        _bottomLine.hidden = NO;
    }
}

- (void)setCountDownTitle:(NSString *)countDownTitle {
    _countdownLabel.text = [NSString stringWithFormat:@"%@后结束", countDownTitle];
}

#pragma mark - Action
- (void)taskBtnAction {
    !self.clickTaskBlock ? : self.clickTaskBlock(self.taskModel,@"");
}

@end
