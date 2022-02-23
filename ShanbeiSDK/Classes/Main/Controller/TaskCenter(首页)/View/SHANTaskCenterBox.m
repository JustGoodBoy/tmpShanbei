//
//  SHANTaskCenterBox.m
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/18.
//

#import "SHANTaskCenterBox.h"
#import "UIColor+SHANHexString.h"
#import "UIFont+SHAN.h"
#import "UIImage+SHAN.h"
#import "ShanTimerManager.h"

@interface SHANTaskCenterBox ()

@end

@implementation SHANTaskCenterBox

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.image = [UIImage SHANImageNamed:@"shan_taskCenter_box" className:[self class]];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 18, self.frame.size.width, 14)];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont shan_PingFangMediumFont:10];
    _timeLabel.textColor = [UIColor shan_colorWithHexString:@"#FFE9B2"];
    _timeLabel.text = @"点击宝箱";
    [self addSubview:_timeLabel];
}




@end
