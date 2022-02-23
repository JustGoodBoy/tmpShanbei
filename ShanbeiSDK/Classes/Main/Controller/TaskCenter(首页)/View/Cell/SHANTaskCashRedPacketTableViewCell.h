//
//  SHANTaskCashRedPacketTableViewCell.h
//  ShanbeiSDK
//
//  Created by GoodBoy on 2021/11/18.
//

#import <UIKit/UIKit.h>
@class SHANTaskModel;
NS_ASSUME_NONNULL_BEGIN

@interface SHANTaskCashRedPacketTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^clickTaskBlock)(SHANTaskModel *,NSString *);

@property (nonatomic, strong) SHANTaskModel *taskModel;

@property (nonatomic, assign) BOOL isHiddenLine;

@property (nonatomic, copy) NSString *countDownTitle;

@end

NS_ASSUME_NONNULL_END
