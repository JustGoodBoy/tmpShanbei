//
//  SHANTaskFinishedAlertView.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/9/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SHANTaskType) {
    SHANTaskTypeOfCoin = 0,    // 积分任务
    SHANTaskTypeOfCashRMB,      // 现金任务
};

/// 完成任务
@interface SHANTaskFinishedAlertView : UIView

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) SHANTaskType taskType;

@property (nonatomic, copy) void (^didCloseAction)(void);

@property (nonatomic, copy) void (^didAcceptAction)(void);

@end

NS_ASSUME_NONNULL_END
