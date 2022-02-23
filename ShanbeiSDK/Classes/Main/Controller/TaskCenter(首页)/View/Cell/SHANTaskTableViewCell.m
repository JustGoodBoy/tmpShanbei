//
//  SHANTaskTableViewCell.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import "SHANTaskTableViewCell.h"
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
#import "SHANMenu.h"
@interface SHANTaskTableViewCell ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *taskTitleLabel;
@property (nonatomic, strong) UILabel *taskDescribeLabel;
@property (nonatomic, strong) UIButton *taskBtn;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UITextField *codeTextField;
@end

@implementation SHANTaskTableViewCell

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
    
    // 邀请码
    _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(43, _taskTitleLabel.bottom + 5, width - 30, 26)];
    _codeTextField.placeholder = @"此处填写邀请码";
    _codeTextField.font = [UIFont shan_PingFangRegularFont:11];
    _codeTextField.layer.borderWidth = 1;
    _codeTextField.layer.borderColor = [UIColor shan_colorWithHexString:@"#B98A73"].CGColor;
    _codeTextField.layer.cornerRadius = 13;
    _codeTextField.layer.masksToBounds = YES;
    [self.contentView addSubview:_codeTextField];
    _codeTextField.hidden = YES;
    
    [_codeTextField setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)]];
    [_codeTextField setLeftViewMode:UITextFieldViewModeAlways];
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
    
    if (!_codeTextField.isHidden) {
        _codeTextField.text = @"";
    }
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
    [_taskBtn setImage:[UIImage SHANImageNamed:@"" className:[self class]] forState:UIControlStateNormal];
    // 睡觉任务-特殊处理
    if ([userTaskModel.advertisingType integerValue] == SHANTaskListTypeOfSleep) {
        _taskBtn.userInteractionEnabled = YES;
    }
    
    [_taskBtn setTitle:userTaskModel.buttonName forState:UIControlStateNormal];
    
    if ([userTaskModel.advertisingType integerValue] == 6) {
        _codeTextField.hidden = NO;
        _taskDescribeLabel.hidden = YES;
        _codeTextField.top = CGRectGetMaxY(_taskTitleLabel.frame) + 5;
        return;
    } else {
        _codeTextField.hidden = YES;
        _taskDescribeLabel.hidden = NO;
    }
    // 描述
    NSString *replaceSubheading =  [userTaskModel.subheading stringByReplacingOccurrencesOfString:@"金币" withString:@"积分"];
    CGFloat height = [replaceSubheading shan_getHeightwithContent:replaceSubheading withFont:[UIFont shan_PingFangRegularFont:11] withWidth:kSHANScreenWidth - 80 - 43 - 78 - 19];
    _taskDescribeLabel.top = CGRectGetMaxY(_taskTitleLabel.frame) + 5;
    _taskDescribeLabel.height = height;
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

- (void)setIsHiddenLine:(BOOL)isHiddenLine {
    if (isHiddenLine){
        _bottomLine.hidden = YES;
    } else {
        _bottomLine.hidden = NO;
    }
}

/// 按钮的文字和图片
- (void)setBtnStyle:(NSString *)title isRewardVideoTask:(BOOL)isRewardVideoTask {
    NSString *btnImg = @"";
    if (isRewardVideoTask) {
        btnImg = @"shan_icon_gift";
    }
    
    [_taskBtn setImage:[UIImage SHANImageNamed:btnImg className:[self class]] forState:UIControlStateNormal];
    [_taskBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark - Action
- (void)taskBtnAction {
    !self.clickTaskBlock ? : self.clickTaskBlock(self.taskModel,self.codeTextField.text);
}

@end
