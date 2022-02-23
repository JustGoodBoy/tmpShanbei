//
//  SHANProfitTableViewCell.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/22.
//

/// 收益cell
#import "SHANProfitTableViewCell.h"
#import "SHANProfitRecordModel.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
#import "UIView+SHAN.h"
#import "NSString+SHAN.h"
#import "SHANHeader.h"
@interface SHANProfitTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *profitLabel;
@end

@implementation SHANProfitTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(16, 14, 200, 22);
    _titleLabel.font = [UIFont shan_PingFangRegularFont:16];
    _titleLabel.textColor = [UIColor shan_colorWithHexString:@"#333333"];
    _titleLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.frame = CGRectMake(16, CGRectGetMaxY(_titleLabel.frame) + 6, 100, 17);
    _dateLabel.font = [UIFont shan_PingFangRegularFont:12];
    _dateLabel.textColor = [UIColor shan_colorWithHexString:@"#999999"];
    _dateLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_dateLabel];
    
    _profitLabel = [[UILabel alloc] init];
    _profitLabel.frame = CGRectMake(kSHANScreenWidth - 60 - 16, CGRectGetMinY(_titleLabel.frame) + 13, 60, 20);
    _profitLabel.font = [UIFont shan_PingFangMediumFont:14];
    _profitLabel.textColor = [UIColor shan_colorWithHexString:@"#FD5558"];
    _profitLabel.textAlignment = NSTextAlignmentRight;
    _profitLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_profitLabel];
}

- (void)setProfitRecordModel:(SHANProfitRecordModel *)profitRecordModel {
    _profitRecordModel = profitRecordModel;
    
    NSString *replaceTitle =  [profitRecordModel.Description stringByReplacingOccurrencesOfString:@"金币" withString:@"积分"];
    _titleLabel.text = replaceTitle;
    _dateLabel.text = profitRecordModel.createDate;
    NSString *cashString = @"0";
    if (profitRecordModel.coin) {
        cashString = profitRecordModel.coin;
        if ([profitRecordModel.coin floatValue] > 0) {
            cashString = [NSString stringWithFormat:@"+%@",profitRecordModel.coin];
        }
        _profitLabel.text = cashString;
    }
    
    if (profitRecordModel.cash) {
        cashString = [NSString stringWithFormat:@"%.2f",[profitRecordModel.cash floatValue]/100];
        if ([profitRecordModel.cash floatValue] > 0) {
            cashString = [NSString stringWithFormat:@"+%@",cashString];
        }
        _profitLabel.text = cashString;
    }
    
    if ([cashString floatValue] > 0) {
        _profitLabel.textColor = [UIColor shan_colorWithHexString:@"#FD5558"];
    } else {
        _profitLabel.textColor = [UIColor shan_colorWithHexString:@"#B5B5B5"];
    }
}


@end
