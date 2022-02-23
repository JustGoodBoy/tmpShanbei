//
//  SHANCashOutCollectionViewCell.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/23.
//

#import "SHANCashOutCollectionViewCell.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
#import "NSString+SHAN.h"
#import "SHANCashDrawalModel.h"
#import "SHANHeader.h"
@interface SHANCashOutCollectionViewCell ()
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@end

@implementation SHANCashOutCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 90, 52)];
    _contentLabel.layer.borderWidth = 2;
    _contentLabel.layer.cornerRadius = 8;
    _contentLabel.layer.masksToBounds = YES;
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90 - 49, 0, 49, 16)];
    _tipsLabel.textColor = [UIColor whiteColor];
    _tipsLabel.font = [UIFont shan_PingFangMediumFont:9];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tipsLabel];
    
    CGFloat radius = 6; // 圆角大小
    UIRectCorner corner = UIRectCornerBottomLeft | UIRectCornerTopRight;
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_tipsLabel.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _tipsLabel.bounds;
    maskLayer.path = path.CGPath;
    _tipsLabel.layer.mask = maskLayer;
}

- (void)setModel:(SHANCashDrawalModel *)model {
    _model = model;
    [self changeStyle];
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    [self changeStyle];
}

- (void)changeStyle {
    NSString *hexColorStr = @"#333333";
    NSString *tipsColorStr = @"#D8D8D8";
    if (_isSelect){
        hexColorStr = @"#FF3F4E";
        tipsColorStr = @"#FF3F4E";
        _contentLabel.backgroundColor = [UIColor shan_colorWithHexString:@"#FEF5F8"];
        _contentLabel.layer.borderColor = [UIColor shan_colorWithHexString:@"#FF3F4E"].CGColor;
    } else {
        _contentLabel.backgroundColor = [UIColor whiteColor];
        _contentLabel.layer.borderColor = [UIColor shan_colorWithHexString:@"#EEEEEE"].CGColor;
    }
    
    NSString *cashString = [NSString stringWithFormat:@"%.2f",[_model.money floatValue]/100];
    cashString = [cashString removeSurplusZero:cashString];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:cashString attributes:@{
        NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:hexColorStr],
        NSFontAttributeName:[UIFont shan_PingFangMediumFont:26],
    }];
    NSAttributedString *unit = [[NSAttributedString alloc] initWithString:@" 元" attributes:@{
        NSForegroundColorAttributeName:[UIColor shan_colorWithHexString:hexColorStr],
        NSFontAttributeName:[UIFont shan_PingFangMediumFont:12],
    }];
    [title appendAttributedString:unit];

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setLineSpacing:10];
    paraStyle.alignment = NSTextAlignmentCenter;
    [title addAttributes:@{NSParagraphStyleAttributeName:paraStyle}
                         range:NSMakeRange(0, title.length)];
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.attributedText = title;
    
    _tipsLabel.text = _model.Description;
    _tipsLabel.backgroundColor = [UIColor shan_colorWithHexString:tipsColorStr];
    _tipsLabel.hidden = kSHANStringIsEmpty(_model.Description);
}

@end
