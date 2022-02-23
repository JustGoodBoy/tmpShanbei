//
//  SHANLoadingManager.m
//  Pods
//
//  Created by GoodBoy on 2021/9/24.
//

#import "SHANLoadingManager.h"
#import "SHANHeader.h"
static SHANLoadingManager *_manager = nil;

@interface SHANLoadingManager ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation SHANLoadingManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[super allocWithZone:NULL] init];
    });

    return _manager;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [SHANLoadingManager sharedManager];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [SHANLoadingManager sharedManager];
}

- (void)createActivityIndicator {
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSHANScreenWidth, kSHANScreenHeight)];
    self.backgroundView.backgroundColor = UIColor.clearColor;
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [self.backgroundView addSubview:self.activityIndicator];
    //设置小菊花的frame
    self.activityIndicator.frame= CGRectMake((kSHANScreenWidth - 100)/2, (kSHANScreenHeight - 100)/2, 100, 100);
    //设置小菊花颜色
    self.activityIndicator.color = [UIColor whiteColor];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    //设置背景颜色
    self.activityIndicator.backgroundColor = [UIColor blackColor];
    //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    self.activityIndicator.hidesWhenStopped = NO;
    
    self.activityIndicator.layer.cornerRadius = 8;
    self.activityIndicator.layer.masksToBounds = YES;
    
}

- (void)startAnimating {
    [self createActivityIndicator];
    [self.activityIndicator startAnimating];
}

- (void)stopAnimating {
    [self.activityIndicator stopAnimating];
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

@end
